import 'dart:async';
import 'dart:math';
import 'package:adhan/adhan.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:intl/intl.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/routes.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/services/app_actions_service.dart';
import 'package:zad_almuslim/core/utils/date_format.dart';
import 'package:zad_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:zad_almuslim/core/widgets/header.dart';
import 'package:zad_almuslim/core/widgets/main_button.dart';
import 'package:zad_almuslim/core/widgets/settings_button.dart';
import 'package:zad_almuslim/features/home/get_prayer_times.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isVisible = false;
  static final ValueNotifier<String> _timeNotifier = ValueNotifier("");
  Timer? _timer;
  String? todayHijriDate;
  String? headerAyah;
  List<Map<String, dynamic>> initialPrayerTimes = [];
  List<Map<String, dynamic>> finalPrayerTimes = [];
  Map<String, dynamic> nextPrayer = {
    "name": "جاري التحميل",
    "time": DateTime.now(),
  };
  Map<String, dynamic>? foundPrayer;
  ValueNotifier<String> remainder = ValueNotifier<String>("");
  double? latitude;
  double? longitude;
  bool isLoading = false;
  ValueNotifier<bool> showUpdateDot = ValueNotifier<bool>(false);

  void getHeaderAyah() {
    List<String> ayat = ConstTexts.headerAyats;
    final randomGenerator = Random();
    int randomAyahNum = randomGenerator.nextInt(ayat.length);
    headerAyah = ayat[randomAyahNum];
    setState(() {});
  }

  void getHijriDate() {
    HijriDate.setLocal('ar');
    todayHijriDate = HijriDate.currentHijriDate.toString();
  }

  void getPrayerTimes(double lat, double lng) {
    initialPrayerTimes.clear();
    final myCoordinates = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    initialPrayerTimes.addAll([
      {"name": "الفجر", "time": prayerTimes.fajr},
      {"name": "الظهر", "time": prayerTimes.dhuhr},
      {"name": "العصر", "time": prayerTimes.asr},
      {"name": "المغرب", "time": prayerTimes.maghrib},
      {"name": "العشاء", "time": prayerTimes.isha},
    ]);
    getNextPrayer(lat, lng, params);
    setState(() {});
  }

  void getNextPrayer(double lat, double lng, CalculationParameters params) {
    foundPrayer = null;
    DateTime currentTime = DateTime.now();

    for (int i = 0; i < initialPrayerTimes.length; i++) {
      if (currentTime.isBefore(initialPrayerTimes[i]['time'])) {
        foundPrayer = initialPrayerTimes[i];
        break;
      }
    }

    if (foundPrayer != null) {
      nextPrayer = foundPrayer!;
    } else {
      final myCoordinates = Coordinates(lat, lng);

      final tomorrow = DateTime.now().add(Duration(days: 1));
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

      nextPrayer = {"name": "الفجر", "time": tomorrowPrayers.fajr};
    }

    finalPrayerTimes.clear();
    finalPrayerTimes.addAll(
      initialPrayerTimes.where(
        (prayer) => prayer['name'] != nextPrayer['name'],
      ),
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
    _timeNotifier.value = DateManager.getFormattedTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeNotifier.value = DateManager.getFormattedTime(DateTime.now());
      remainder.value = getRemainingTime(nextPrayer['time']);
      DateTime timeToSwitch = nextPrayer['time'].add(Duration(minutes: 1));
      DateTime now = DateTime.now();
      if (now.isAfter(timeToSwitch)) {
        if (latitude != null && longitude != null) {
          _timer?.cancel();
          getPrayerTimes(latitude!, longitude!);
          startTimer();
        }
      }
    });
  }

  void getUserLocation() async {
    try {
      final Position position = await GetPrayerTimes.determinePosition();

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        getPrayerTimes(latitude!, longitude!);
      });
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      AppActionsService.showErrorSnackBar(context, " خطأ في جلب الموقع: $e");
      setState(() {
        getPrayerTimes(0, 0);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    AppActionsService.hasNewUpdate().then((isUpdateAvailable) {
      showUpdateDot.value = isUpdateAvailable;
    });
    getUserLocation();
    getHijriDate();
    startTimer();
    getHeaderAyah();
    AppActionsService.hasNewUpdate();
    Future.delayed(
      Duration(milliseconds: 10),
      () => setState(() {
        _isVisible = true;
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    remainder.dispose();
    _timeNotifier.dispose();
    showUpdateDot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Image.asset(ConstIcons.appbarLogo, width: 28),
            Image.asset(ConstIcons.homeLogoName, width: 80),
            // Text(
            //   ConstTexts.appName,
            //   style: Theme.of(
            //     context,
            //   ).textTheme.titleLarge!.copyWith(fontSize: 24),
            // ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: ConstColors.mainColor,
              borderRadius: BorderRadius.circular(80),
            ),
            child: ValueListenableBuilder(
              valueListenable: _timeNotifier,

              builder: (context, timeValue, child) => Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateManager.getCurrentNafha(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Image.asset(
                    DateManager.isMorning() ? ConstIcons.sun : ConstIcons.moon,
                    width: 26,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(100),
      //     boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      //     color: Theme.of(context).brightness == Brightness.dark
      //         ? Colors.black
      //         : Colors.white,
      //   ),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       IconButton(
      //         onPressed: () => getHeaderAyah(ConstTexts.headerAyats),
      //         // style: IconButton.styleFrom(
      //         //   shape: R
      //         // )
      //         icon: Icon(
      //           Icons.refresh_rounded,
      //           color: ConstColors.mainColor,
      //           size: 22,
      //         ),
      //       ),
      //       const SizedBox(width: 12),
      //       Flexible(
      //         fit: FlexFit.loose,
      //         child: AutoSizeText(
      //           headerAyah ?? "قل الحمد لله",
      //           style: const TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 14,
      //           ),
      //           maxLines: 1,
      //           overflow: TextOverflow.ellipsis,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeOut,
            bottom: _isVisible ? -40 : -300,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(ConstIcons.backgroundShape),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //hijri
                Text(
                  todayHijriDate!.toArabicFormat(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                ),
                if (todayHijriDate.toString().contains('الجمعة'))
                  Opacity(
                    opacity: .8,
                    child: Text(
                      "اجعل يومك صلاة على النبي ﷺ .. جمعة مباركة",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 10,
                        color: ConstColors.mainColor,
                      ),
                    ),
                  ),
                Divider(height: 6),

                //prayers times
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // next prayer
                        Expanded(
                          flex: 1,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ConstColors.mainColor,
                                width: 2,
                              ),
                            ),
                            child: ValueListenableBuilder(
                              valueListenable: remainder,
                              builder: (context, timeValue, child) =>
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          nextPrayer["name"] ?? "خطأ",
                                          style: TextStyle(
                                            color: ConstColors.mainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        AutoSizeText(
                                          timeValue == "00:00:00"
                                              ? "موعد الآذان"
                                              : "متبقي: ${timeValue.toArabicFormat()}"
                                                    .toArabicFormat(),
                                          style: TextStyle(
                                            color: ConstColors.mainColor,
                                            fontFamily: 'cairo',
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ),

                        // other prayers
                        Expanded(
                          flex: 2,
                          child: finalPrayerTimes.isEmpty
                              ? SizedBox(
                                  height: 4,
                                  child: LinearProgressIndicator(
                                    color: ConstColors.mainColor,
                                    backgroundColor: Colors.transparent,
                                    trackGap: 2,
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        spacing: 4,
                                        children: [
                                          for (int i = 0; i < 2; i++)
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: .4,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  "${finalPrayerTimes[i]['name']} : ${DateFormat.jm('ar').format(finalPrayerTimes[i]['time'])}"
                                                      .toArabicFormat(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        spacing: 4,
                                        children: [
                                          for (int i = 2; i < 4; i++)
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: .4,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  "${finalPrayerTimes[i]['name']} : ${DateFormat.jm('ar').format(finalPrayerTimes[i]['time'])}"
                                                      .toArabicFormat(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // header
                GestureDetector(
                  onTap: () => getHeaderAyah(),
                  child: Header(content: headerAyah ?? "قـــل الحــمد للـــه"),
                ),

                SizedBox(height: 30),
                // buttons
                Expanded(
                  flex: 7,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 18,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _timeNotifier,
                            builder: (context, _, _) => MainButton(
                              title: DateManager.isMorning()
                                  ? ConstTexts.morningAzkar
                                  : ConstTexts.eveningAzkar,
                              image: ConstIcons.azkar,
                              pageRouteName: ConstRoutes.azkar,
                            ),
                          ),
                          MainButton(
                            title: ConstTexts.prayerAzkar,
                            image: ConstIcons.prayer,
                            pageRouteName: ConstRoutes.prayerAzkar,
                          ),
                          MainButton(
                            title: ConstTexts.mesbha,
                            image: ConstIcons.sebha,
                            pageRouteName: ConstRoutes.sebha,
                          ),

                          MainButton(
                            title: ConstTexts.hisnElmuslim,
                            image: ConstIcons.hisnElmuslim,
                            pageRouteName: ConstRoutes.hisnAlmuslim,
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: SecondMainButton(
                                  title: ConstTexts.meraj,
                                  image: ConstIcons.meraj,
                                  pageRouteName: ConstRoutes.meraj,
                                ),
                              ),
                              Expanded(
                                child: SecondMainButton(
                                  title: ConstTexts.allahNames,
                                  image: ConstIcons.allahNames,
                                  pageRouteName: ConstRoutes.allahNames,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SettingsButton(),
                              ValueListenableBuilder(
                                valueListenable: showUpdateDot,
                                builder: (context, value, child) {
                                  return Visibility(
                                    visible: value,
                                    child: Positioned(
                                      left: 2,
                                      top: 0,
                                      child: CircleAvatar(
                                        backgroundColor: ConstColors.deepOrange,
                                        radius: 8,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
