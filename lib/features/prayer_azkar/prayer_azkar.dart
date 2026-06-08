import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/services/app_actions_service.dart';
import 'package:zad_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:zad_almuslim/features/prayer_azkar/prayer_azkar_logic.dart';

class PrayerAzkar extends StatefulWidget {
  const PrayerAzkar({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;

  @override
  State<PrayerAzkar> createState() => _PrayerAzkarState();
}

class _PrayerAzkarState extends State<PrayerAzkar> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final CardSwiperController controller = CardSwiperController();
  List azkar = [];
  bool isLoading = true;
  int counter = 0;

  int currentIndex = 0;

  bool _onSwipe(
    int previousIndex,
    int? nextIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped. Now card $nextIndex is on top',
    );

    setState(() {
      currentIndex = nextIndex ?? 0;
      counter = 0;
    });
    return true;
  }

  bool _onUndo(int? previousIndex, int index, CardSwiperDirection direction) {
    debugPrint('The card $index was undod');
    setState(() {
      currentIndex = index;
      counter = 0;
    });
    return true;
  }

  void _onEnd() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ConstColors.deepOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 12,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              "تقبل الله صلاتك\nثبتك الله وزادك",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ConstColors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: SizedBox(
              width: double.infinity,
              child: const Text(
                "آمين",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getPrayerAzkar() async {
    try {
      azkar = await PrayerAzkarLogic.getPrayerAzkar();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if(!mounted) {
        return;
      }
      AppActionsService.showErrorSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    getPrayerAzkar();
    super.initState();
  }
@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int currentRepeat = (azkar.isNotEmpty && currentIndex < azkar.length)
        ? (azkar[currentIndex]["repeat"] ?? 1)
        : 1;

    bool isCounterEqualRepeat = counter >= currentRepeat;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldState,
      appBar: MyAppbar(
        pageName: ConstTexts.prayerAzkar,
        onPressDrawer: () => scaffoldState.currentState!.openDrawer(),
      ),
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(12),
        height: MediaQuery.sizeOf(context).height * .1,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -6),
              blurRadius: 12,
            ),
          ],
          border: Border.all(color: ConstColors.mainColor, width: 1.4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Expanded(
              flex: 2,

              child: ElevatedButton.icon(
                onPressed: () async {
                  if (counter + 1 >= currentRepeat) {
                    setState(() {
                      counter = currentRepeat;
                    });
                    await Future.delayed(Duration(milliseconds: 150));
                    controller.swipe(CardSwiperDirection.bottom);
                  } else {
                    setState(() {
                      counter++;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCounterEqualRepeat
                      ? ConstColors.mainColor
                      : ConstColors.deepOrange,
                  padding: EdgeInsets.zero,
                ),
                label: Text(
                  counter.toString().toArabicFormat(),
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => controller.swipe(CardSwiperDirection.bottom),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstColors.mainColor,
                  padding: EdgeInsets.zero,
                ),
                label: Icon(Icons.check_rounded, size: 24, color: Colors.white),
              ),
            ),
            Expanded(
              flex: 1,

              child: ElevatedButton.icon(
                onPressed: () => controller.undo(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.zero,
                ),
                label: Icon(
                  Icons.restart_alt_rounded,
                  size: 24,
                  color: ConstColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SpecialBody(
        body: isLoading
            ? Porgress()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 120),
                  Flexible(
                    child: CardSwiper(
                      controller: controller,
                      cardsCount: azkar.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      onEnd: _onEnd,
                      backCardOffset: const Offset(0, -40),
                      numberOfCardsDisplayed: 3,
                      isLoop: false,
                      padding: EdgeInsets.zero,

                      cardBuilder:
                          (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) => Container(
                            height: MediaQuery.sizeOf(context).height * .6,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: ConstColors.mainGradientColor,
                              color: ConstColors.mainColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaler: TextScaler.linear(
                                  widget.fontSizeFactor,
                                ),
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      spacing: 8,
                                      children: [
                                        const Expanded(
                                          child: Divider(color: Colors.white30),
                                        ),
                                        Text(
                                          (index + 1)
                                              .toString()
                                              .toArabicFormat(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Divider(color: Colors.white30),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 30),
                                    Text(
                                      azkar[index]["content"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "uthman",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        height: 1.8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 30),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ConstColors.secondMainColor
                                            .withOpacity(.25),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "الـتــكـرار: ${Tafqeet.convert(azkar[index]["repeat"].toString())} ${(azkar[index]["repeat"] == 0
                                            ? "مرة"
                                            : (azkar[index]["repeat"] >= 3 && azkar[index]["repeat"] <= 10) || (azkar[index]["repeat"] > 100 && azkar[index]["repeat"] % 100 >= 3 && azkar[index]["repeat"] % 100 <= 10)
                                            ? "مرات"
                                            : "مرة")} (${azkar[index]["repeat"].toString().toArabicFormat()})",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),

                                    if (azkar[index]["time"] != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          azkar[index]["time"],
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
