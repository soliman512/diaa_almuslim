import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/json_files.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/date_format.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/widgets/counter_button.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:diaa_almuslim/features/morning_evening_azkar/evening_morning_azkar_logic.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';

class MorningEveningAzkar extends StatefulWidget {
  const MorningEveningAzkar({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<MorningEveningAzkar> createState() => _MorningEveningAzkarState();
}

class _MorningEveningAzkarState extends State<MorningEveningAzkar> {
  final GlobalKey<ScaffoldState> _scaffoldKeyState = GlobalKey<ScaffoldState>();
  List azkar = [];
  ValueNotifier<int> currentZikrNumber = ValueNotifier<int>(0);
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  bool isLoading = true;
  PageController zikrPageController = PageController();
  bool isTransitioning = false;
  void loadData() async {
    var data = await AzkarLogic.loadAzkar(
      DateManager.isMorning()
          ? ConstJsonFiles.morningAzkar
          : ConstJsonFiles.eveningAzkar,
    );
    setState(() {
      azkar.addAll(data);
      isLoading = false;
    });
  }

  void nextZikr() {
    if (currentZikrNumber.value < azkar.length - 1) {
      setState(() {
        counter.value = 0;
      });
      zikrPageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousZikr() {
    if (currentZikrNumber.value > 0) {
      setState(() {
        counter.value = 0;
      });
      zikrPageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateCounter() async {
    if (isTransitioning) return;

    if (counter.value < azkar[currentZikrNumber.value]['repeat']) {
      counter.value++;

      if (counter.value == azkar[currentZikrNumber.value]['repeat'] &&
          currentZikrNumber.value < azkar.length - 1) {
        if (mounted) {
          isTransitioning = true;

          await Future.delayed(const Duration(milliseconds: 250));

          counter.value = 0;
          currentZikrNumber.value++;

          await zikrPageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );

          isTransitioning = false;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    zikrPageController.dispose();
    currentZikrNumber.dispose();
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: _scaffoldKeyState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        showSettingsButton: true,
        pageName: DateManager.isMorning()
            ? ConstTexts.morningAzkar
            : ConstTexts.eveningAzkar,
      ),

      body: isLoading
          ? const Porgress()
          : SpecialBody(
              body: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(widget.fontSizeFactor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //content
                    Expanded(
                      flex: 4,
                      child: ValueListenableBuilder(
                        valueListenable: currentZikrNumber,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              const SizedBox(height: 100),
                              // number and number box
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  //zikr number box
                                  Image.asset(
                                    ConstIcons.zikrNumber,
                                    color: context.isDarkMode
                                        ? ConstColors.goldAccent
                                        : ConstColors.primaryTeal,
                                  ),

                                  //zikr number NUM
                                  Text(
                                    (value + 1).toString().toArabicFormat(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontFamily: 'arusura'),
                                  ),
                                ],
                              ),
                              // zikr + reward
                              const SizedBox(height: 40),
                              Expanded(
                                flex: 12,
                                child: PageView.builder(
                                  controller: zikrPageController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: azkar.length,
                                  onPageChanged: (newValue) {
                                    currentZikrNumber.value = newValue;
                                    counter.value = 0;
                                  },
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    String content = azkar[index]["content"];
                                    String reward = azkar[index]["reward"];

                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //content ZIKR
                                          Text(
                                            content,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontFamily: 'arsura',
                                                  fontSize: 20,
                                                  height: 1.8,
                                                ),
                                          ),
                                          if (reward.isNotEmpty) ...[
                                            const SizedBox(height: 10),
                                            Divider(
                                              color: context.isDarkMode
                                                  ? ConstColors.input
                                                        .withValues(alpha: .3)
                                                  : ConstColors.input,
                                              indent: 40,
                                              endIndent: 40,
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 40.0,
                                                  ),
                                              child: Text(
                                                reward,
                                                style: TextStyle(
                                                  color: context.isDarkMode
                                                      ? ConstColors.goldAccent
                                                      : ConstColors.primaryTeal,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Spacer(),

                              // times of repeat
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: [
                                    const TextSpan(text: "التكرار: "),
                                    TextSpan(
                                      text: azkar[value]["repeat"]
                                          .toString()
                                          .toArabicFormat(),
                                      style: const TextStyle(
                                        fontFamily: 'arusura',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),

                    // controls
                    Expanded(
                      flex: 1,
                      child: Row(
                        spacing: 8,
                        children: [
                          // nextZikr
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: FilledButton.icon(
                                onPressed: nextZikr,
                                style: FilledButton.styleFrom(
                                  backgroundColor: context.isDarkMode
                                      ? ConstColors.goldAccent
                                      : ConstColors.primaryTeal,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(80),
                                      bottomRight: Radius.circular(80),
                                    ),
                                  ),
                                ),
                                label: Image.asset(
                                  ConstIcons.nextZikr,
                                  color: context.isDarkMode
                                      ? ConstColors.primaryTeal
                                      : ConstColors.goldAccent,
                                ),
                              ),
                            ),
                          ),
                          //updateCounter
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: double.infinity,
                              child: ValueListenableBuilder(
                                valueListenable: counter,
                                builder: (context, value, child) =>
                                    CounterButton(
                                      onPressed: updateCounter,
                                      label: counter.value.toString(),
                                    ),
                              ),
                            ),
                          ),
                          //previousZikr
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: previousZikr,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: context.isDarkMode
                                        ? ConstColors.goldAccent
                                        : ConstColors.primaryTeal,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(80),
                                      bottomLeft: Radius.circular(80),
                                    ),
                                  ),
                                ),
                                label: Transform.flip(
                                  flipX: true,
                                  child: Image.asset(
                                    ConstIcons.nextZikr,
                                    color: context.isDarkMode
                                        ? ConstColors.goldAccent
                                        : ConstColors.primaryTeal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
