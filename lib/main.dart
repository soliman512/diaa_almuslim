import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_almuslim/core/themes/app_theme.dart';
import 'package:zad_almuslim/features/allah_names/allah_names.dart';
import 'package:zad_almuslim/features/hisn_almuslim/hisn_almuslim.dart';
import 'package:zad_almuslim/features/meraj/meraj.dart';
import 'package:zad_almuslim/features/morning_evening_azkar/morning_evening_azkar.dart';
import 'package:zad_almuslim/features/prayer_azkar/prayer_azkar.dart';
import 'package:zad_almuslim/features/sebha/sebha.dart';
import 'package:zad_almuslim/features/splash/splash_screen.dart';
import 'package:zad_almuslim/features/home/home.dart';
import 'package:zad_almuslim/features/settings/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(
      locale: const Locale('ar'),
      useInheritedMediaQuery: true,
      // 2. These 3 lines are the "Engine" that flips the layout
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'EG')],

      title: 'Uns Al-Muslim',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightModeTheme,
      darkTheme: AppTheme.darkModeTheme,
      themeMode: _currentThemeMode,
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashScreen(),
        "/home": (context) => Home(),
        "/morning_evening_azkar": (context) =>
            MorningEveningAzkar(fontSizeFactor: _getFontSize(_currentFontSize)),
        "/sebha": (context) => Sebha(),
        "/allah_names": (context) =>
            AllahNames(fontSizeFactor: _getFontSize(_currentFontSize)),
        "/meraj": (context) =>
            Meraj(fontSizeFactor: _getFontSize(_currentFontSize)),
        "/hisn_almuslim": (context) => HisnAlmuslim(),
        "/prayer_azkar": (context) =>
            PrayerAzkar(fontSizeFactor: _getFontSize(_currentFontSize)),
        "/settings": (context) => Settings(
          currentFontSize: _currentFontSize,
          onFontSizeChanged: changeFontSize,
          currentMode: _currentThemeMode,
          onThemeChanged: changeTheme,
        ),
      },

      /// builder:
      /// each page will be selected by user will come to builder first before
      /// appears to user , this useful for if i need to make any changes on
      /// screen before drawing user screen (before appear)
      // builder: (context, child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(
      //       textScaler: TextScaler.linear(_getFontSize(_currentFontSize)),
      //     ),
      //     child: child!,
      //   );
      // },
    );
  }
}
