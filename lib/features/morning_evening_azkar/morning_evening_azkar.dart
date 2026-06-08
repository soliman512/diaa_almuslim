import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/utils/date_format.dart';
import 'package:zad_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:zad_almuslim/core/widgets/counter_button.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/features/morning_evening_azkar/evening_morning_azkar_logic.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';

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
    return Scaffold(
      key: _scaffoldKeyState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        onPressDrawer: () {
          _scaffoldKeyState.currentState!.openDrawer();
        },
        pageName: DateManager.isMorning()
            ? ConstTexts.morningAzkar
            : ConstTexts.eveningAzkar,
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? Porgress()
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
                                  Image.asset(ConstIcons.zikrNumber),

                                  //zikr number NUM
                                  Text(
                                    (value + 1).toString().toArabicFormat(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontFamily: 'cairo'),
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
                                                  fontFamily: "uthman",
                                                  fontSize: 20,
                                                  height: 1.8,
                                                ),
                                          ),
                                          if (reward.isNotEmpty) ...[
                                            const SizedBox(height: 10),
                                            Divider(
                                              color: ConstColors.input,
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
                                                  color: ConstColors.mainColor,
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
                                    TextSpan(text: "التكرار: "),
                                    TextSpan(
                                      text: azkar[value]["repeat"]
                                          .toString()
                                          .toArabicFormat(),
                                      style: TextStyle(fontFamily: 'cairo'),
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
                                  backgroundColor: ConstColors.mainColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(80),
                                      bottomRight: Radius.circular(80),
                                    ),
                                  ),
                                ),
                                label: Image.asset(ConstIcons.nextZikr),
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
                                    color: ConstColors.mainColor,
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
                                label: Image.asset(ConstIcons.pastZikr),
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
