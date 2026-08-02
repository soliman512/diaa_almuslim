
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diaa_almuslim/core/themes/app_theme.dart';
import 'package:diaa_almuslim/features/al_quran/al_quran.dart';
import 'package:diaa_almuslim/features/allah_names/allah_names.dart';
import 'package:diaa_almuslim/features/hisn_almuslim/hisn_almuslim.dart';
import 'package:diaa_almuslim/features/meraj/meraj.dart';
import 'package:diaa_almuslim/features/moon_phase/moon_phase.dart';
import 'package:diaa_almuslim/features/morning_evening_azkar/morning_evening_azkar.dart';
import 'package:diaa_almuslim/features/nearest_mosque/nearest_mosque.dart';
import 'package:diaa_almuslim/features/prayer_azkar/prayer_azkar.dart';
import 'package:diaa_almuslim/features/qibla/qibla.dart';
import 'package:diaa_almuslim/features/sebha/sebha.dart';
import 'package:diaa_almuslim/features/splash/splash_screen.dart';
import 'package:diaa_almuslim/features/home/home.dart';
import 'package:diaa_almuslim/features/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final String savedFontSize = prefs.getString('font_size') ?? "متوسط";
  final String savedThemeMode = prefs.getString('theme_mode') ?? "light";
  runApp(MyApp(initFontSize: savedFontSize, initThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final String initThemeMode;
  final String initFontSize;
  const MyApp({
    super.key,
    required this.initFontSize,
    required this.initThemeMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentThemeMode = ThemeMode.light;
  String _currentFontSize = "متوسط";

  double _getFontSize(String size) {
    switch (size) {
      case 'صغير':
        return 0.85;

      case 'كبير':
        return 1.35;
      //متوسط = default = 1.00
      case 'متوسط':
      default:
        return 1.00;
    }
  }

  void changeFontSize(String newSize) async {
    setState(() {
      _currentFontSize = newSize;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("font_size", _currentFontSize);
  }

  void changeTheme(ThemeMode themeMode) async {
    setState(() {
      _currentThemeMode = themeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "theme_mode",
      _currentThemeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.initThemeMode == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    _currentFontSize = widget.initFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72727272727275, 800.7272727272727),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: const Locale('ar'),
          useInheritedMediaQuery: true,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'EG')],

          title: 'ضياء',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightModeTheme,
          darkTheme: AppTheme.darkModeTheme,
          themeMode: _currentThemeMode,
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const SplashScreen(),
            "/home": (context) => const Home(),
            "/al_quran": (context) =>
                AlQuran(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/morning_evening_azkar": (context) => MorningEveningAzkar(
              fontSizeFactor: _getFontSize(_currentFontSize),
            ),
            "/sebha": (context) => const Sebha(),
            "/allah_names": (context) =>
                AllahNames(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/meraj": (context) =>
                Meraj(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/hisn_almuslim": (context) => const HisnAlmuslim(),
            "/moon_phase": (context) =>
                MoonPhaseScreen(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/nearest_mosque": (context) =>
                NearestMosque(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/qibla": (context) => const Qibla(),
            "/prayer_azkar": (context) =>
                PrayerAzkar(fontSizeFactor: _getFontSize(_currentFontSize)),
            "/settings": (context) => Settings(
              currentFontSize: _currentFontSize,
              onFontSizeChanged: changeFontSize,
              currentMode: _currentThemeMode,
              onThemeChanged: changeTheme,
            ),
          },

          // حافظت لك على كود التكبير لكي تستخدمه متى شئت
          // builder: (context, child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(
          //       textScaler: TextScaler.linear(_getFontSize(_currentFontSize)),
          //     ),
          //     child: child!,
          //   );
          // },
        );
      },
    );
  }
}
