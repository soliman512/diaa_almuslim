import 'dart:async';
import 'dart:math';
import 'package:adhan/adhan.dart';
import 'package:diaa_almuslim/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:geolocator/geolocator.dart'
    show Position, LocationPermission, Geolocator, LocationAccuracy;
import 'package:diaa_almuslim/core/utils/date_format.dart';
import 'package:diaa_almuslim/core/models/prayer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  List<PrayerModel> initialPrayerTimes = [];
  List<PrayerModel> finalPrayerTimes = [];

  PrayerModel nextPrayer = PrayerModel(
    name: "جاري الحساب",
    time: DateTime.now(),
  );

  String remainingTime = "00:00:00";
  String currentTimeFormatted = "";

  String todayHijriDate = "";
  String headerAyah = "";

  double? latitude;
  double? longitude;
  bool isLoading = true;

  Timer? _timer;
  DateTime? sunrise;
  DateTime? sunset;
  bool isLocationError = false;
  void init() {
    getHijriDate();
    getHeaderAyah();
    getUserLocation();
    startTimer();
    NotificationService().scheduleDailyAzkar();
  }

  //  Methods
  void getHijriDate() {
    HijriDate.setLocal('ar');
    todayHijriDate = HijriDate.currentHijriDate.toString();
    notifyListeners();
  }

  void getHeaderAyah() {
    List<String> ayat = ConstTexts.headerAyats;
    final randomGenerator = Random();
    int randomAyahNum = randomGenerator.nextInt(ayat.length);
    headerAyah = ayat[randomAyahNum];
    notifyListeners();
  }

  void getPrayerTimes(double lat, double lng) {
    initialPrayerTimes.clear();
    final myCoordinates = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    initialPrayerTimes.addAll([
      PrayerModel(name: "الفجر", time: prayerTimes.fajr),
      PrayerModel(name: "الظهر", time: prayerTimes.dhuhr),
      PrayerModel(name: "العصر", time: prayerTimes.asr),
      PrayerModel(name: "المغرب", time: prayerTimes.maghrib),
      PrayerModel(name: "العشاء", time: prayerTimes.isha),
    ]);
    NotificationService().schedulePrayers(initialPrayerTimes);
    getNextPrayer(lat, lng, params);
    sunrise = prayerTimes.sunrise;
    sunset = prayerTimes.maghrib;
    isLoading = false;

    notifyListeners();
  }

  void getNextPrayer(double lat, double lng, CalculationParameters params) {
    PrayerModel? localFoundPrayer;
    DateTime currentTime = DateTime.now();

    for (int i = 0; i < initialPrayerTimes.length; i++) {
      if (currentTime.isBefore(initialPrayerTimes[i].time)) {
        localFoundPrayer = initialPrayerTimes[i];
        break;
      }
    }

    if (localFoundPrayer != null) {
      nextPrayer = localFoundPrayer;
    } else {
      final myCoordinates = Coordinates(lat, lng);
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowComponents = DateComponents(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
      );

      final tomorrowPrayers = PrayerTimes(
        myCoordinates,
        tomorrowComponents,
        params,
      );

      nextPrayer = PrayerModel(name: "الفجر", time: tomorrowPrayers.fajr);
    }

    finalPrayerTimes.clear();
    finalPrayerTimes.addAll(
      initialPrayerTimes.where((prayer) => prayer.name != nextPrayer.name),
    );
  }

  String getRemainingTime(DateTime nextPrayerTime) {
    final duration = nextPrayerTime.difference(DateTime.now());

    if (duration.isNegative) return "00:00:00";

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  void startTimer() {
    _timer?.cancel();
    currentTimeFormatted = DateManager.getFormattedTime(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTimeFormatted = DateManager.getFormattedTime(DateTime.now());
      remainingTime = getRemainingTime(nextPrayer.time);

      notifyListeners();

      DateTime timeToSwitch = nextPrayer.time.add(const Duration(minutes: 1));
      DateTime now = DateTime.now();

      if (now.isAfter(timeToSwitch) && latitude != null && longitude != null) {
        getPrayerTimes(latitude!, longitude!);
      }
    });
  }

  Future<void> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedLat = prefs.getDouble('cached_lat');
    final cachedLng = prefs.getDouble('cached_lng');

    if (cachedLat != null && cachedLng != null) {
      latitude = cachedLat;
      longitude = cachedLng;
      getPrayerTimes(cachedLat, cachedLng);
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLocationError = true;
      if (cachedLat == null) isLoading = false;
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLocationError = true;
      if (cachedLat == null) isLoading = false;
      notifyListeners();
      return;
    }

    isLocationError = false;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      if (cachedLat != null && cachedLng != null) {
        double distance = Geolocator.distanceBetween(
          cachedLat,
          cachedLng,
          position.latitude,
          position.longitude,
        );

        if (distance < 5000) {
          return;
        }
      }

      await prefs.setDouble('cached_lat', position.latitude);
      await prefs.setDouble('cached_lng', position.longitude);

      latitude = position.latitude;
      longitude = position.longitude;

      getPrayerTimes(latitude!, longitude!);
    } catch (e) {
      if (cachedLat == null) {
        getPrayerTimes(0, 0);
        isLocationError = true;
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
