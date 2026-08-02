import 'package:diaa_almuslim/core/constants/images.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/features/home/prayer_times_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diaa_almuslim/core/widgets/header.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/routes.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/date_format.dart';
import 'package:diaa_almuslim/core/widgets/main_button.dart';
import 'package:diaa_almuslim/core/widgets/settings_button.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/controllers/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  final List<Map<String, dynamic>> homeButtonsList = [
    {
      'title': ConstTexts.prayerAzkar,
      'icon': ConstIcons.prayer,
      'pageRouteName': ConstRoutes.prayerAzkar,
    },
    {
      'title': ConstTexts.mesbha,
      'icon': ConstIcons.sebha,
      'pageRouteName': ConstRoutes.sebha,
    },
    {
      'title': ConstTexts.hisnElmuslim,
      'icon': ConstIcons.hisnElmuslim,
      'pageRouteName': ConstRoutes.hisnAlmuslim,
    },
    {
      'title': ConstTexts.meraj,
      'icon': ConstIcons.meraj,
      'pageRouteName': ConstRoutes.meraj,
    },
    {
      'title': ConstTexts.allahNames,
      'icon': ConstIcons.allahNames,
      'pageRouteName': ConstRoutes.allahNames,
    },
    {
      'title': ConstTexts.qibla,
      'icon': ConstIcons.kaaba,
      'pageRouteName': ConstRoutes.qibla,
    },
    {
      'title': ConstTexts.nearestMosque,
      'icon': ConstIcons.nearestMosque,
      'pageRouteName': ConstRoutes.nearestMosque,
    },
    {
      'title': ConstTexts.moonPhase,
      'icon': ConstIcons.moonPhase,
      'pageRouteName': ConstRoutes.moonPhase,
    },
    // {
    //   'title': ConstTexts.settings,
    //   'icon': ConstIcons.settings,
    //   'pageRouteName': ConstRoutes.allahNames,
    // },
  ];
  ValueNotifier<bool> changeAppBarBackgroundColor = ValueNotifier<bool>(false);
  final HomeController _homeController = HomeController();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    _homeController.init();
    // AppActionsService.hasNewUpdate();
  }

  void _onScroll() {
    final double currentScrollOffset = _scrollController.offset;
    if (currentScrollOffset >= 40) {
      changeAppBarBackgroundColor.value = true;
    } else {
      changeAppBarBackgroundColor.value = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_homeController.isLocationError) {
        _homeController.getUserLocation();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _homeController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.sizeOf(context);
    // bool DarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder(
          valueListenable: changeAppBarBackgroundColor,
          builder: (context, value, child) {
            return AppBar(
              elevation: 0,
              centerTitle: value,
              toolbarHeight: 60,
              backgroundColor: value
                  ? context.isDarkMode
                        ? ConstColors.darkBackAppBar
                        : ConstColors.lightBackAppBar
                  : Colors.transparent,
              title: Image.asset(
                ConstIcons.appLogo,
                width: 36,
                color: context.isDarkMode
                    ? const Color(0xffa98b63)
                    : ConstColors.primaryTeal,
              ),
              actions: value
                  ? null
                  : [
                      ListenableBuilder(
                        listenable: _homeController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: ConstColors.mainGradientColor,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Row(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AutoSizeText(
                                  maxFontSize: 14,
                                  minFontSize: 4,
                                  DateManager.getCurrentNafha(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Image.asset(
                                  DateManager.isMorning()
                                      ? ConstIcons.sun
                                      : ConstIcons.moon,
                                  width: 26,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                    ],
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            context.isDarkMode
                ? ConstImages.mainDarkBackground
                : ConstImages.mainLightBackground,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                spacing: 22,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),

                  // hijri date
                  ListenableBuilder(
                    listenable: _homeController,
                    builder: (context, child) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   begin: Alignment
                          //       .centerLeft, // بداية التدرج من اليسار
                          //   end: Alignment
                          //       .centerRight, // نهاية التدرج في اليمين
                          //   colors: [
                          //     Color(0xFF0F3943), // اللون الداكن في اليسار
                          //     Color(
                          //       0xFF1E656B,
                          //     ), // اللون الأفتح باتجاه اليمين
                          //   ],
                          // ),
                          color: ConstColors.primaryTeal,
                          border: const Border.symmetric(
                            vertical: BorderSide(
                              color: ConstColors.goldAccent,
                              width: 12,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _homeController.todayHijriDate.toArabicFormat(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(255, 223, 172, 107),
                              ),
                        ),
                      );
                    },
                  ),
                  // header ayah
                  Header(
                    content: _homeController.todayHijriDate.contains('الجمعة')
                        ? "اجعل يومك صلاة على النبي ﷺ .. جمعة مباركة"
                        : (_homeController.headerAyah.isNotEmpty
                              ? _homeController.headerAyah
                              : "قـــل الحــمد للـــه"),
                  ),
                  // prayer times
                  PrayerTimesCardWidget(homeController: _homeController),

                  // buttons
                  // ---------
                  //quran
                  MainButtonVTwo(
                    title: ConstTexts.quran,
                    descrption: "إجعل لنفسك وردا من القران .. ولو آية",
                    icon: ConstIcons.quran,
                    routeName: ConstRoutes.alQuran,
                    noRotate: true,
                  ),
                  //morning / evening azkar
                  MainButtonVTwo(
                    title: DateManager.isMorning()
                        ? ConstTexts.morningAzkar
                        : ConstTexts.eveningAzkar,
                    icon: ConstIcons.morningEveningAzkar,
                    routeName: ConstRoutes.azkar,
                    descrption: DateManager.isMorning()
                        ? "حِصنك المَتين من الشُّروق إلى المَغيب"
                        : "سَكِينةُ رُوحِك في إقبالِ اللَّيلِ والظُّلْمة",
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2,
                        ),
                    itemCount: homeButtonsList.length,
                    itemBuilder: (context, i) => SecondaryButtonVTwo(
                      title: homeButtonsList[i]['title'],
                      icon: homeButtonsList[i]['icon'],
                      routeName: homeButtonsList[i]['pageRouteName'],
                      noRotate: true,
                    ),
                  ),
                  //settings button
                      const SettingsButton(),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     ValueListenableBuilder(
                  //       valueListenable: showUpdateDot,
                  //       builder: (context, value, child) {
                  //         return Visibility(
                  //           visible: value,
                  //           child: const Positioned(
                  //             left: 2,
                  //             top: 0,
                  //             child: CircleAvatar(
                  //               backgroundColor: ConstColors.deepOrange,
                  //               radius: 8,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
