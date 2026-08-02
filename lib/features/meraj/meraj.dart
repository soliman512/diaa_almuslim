import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:diaa_almuslim/features/meraj/meraj_logic.dart';
import 'package:diaa_almuslim/features/meraj/meraj_user_completed_azkar.dart';
import 'package:diaa_almuslim/features/meraj/meraj_zikr_counter.dart';

class Meraj extends StatefulWidget {
  const Meraj({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<Meraj> createState() => _MerajState();
}

class _MerajState extends State<Meraj> {
  List azkar = [];
  bool isLoading = true;
  int counter = 0;

  final MerajUserCompletedAzkar _userCompletedAzkar = MerajUserCompletedAzkar();

  void loadAzkar() async {
    var data = await MerajLogic.loadData();
    if (!mounted) return;
    setState(() {
      azkar.addAll(data);
      isLoading = false;
    });
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      _showWelcomeDialog();

      await prefs.setBool('isFirstTime', false);
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.8),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  // Container(color: Colors.transparent),
                  Positioned(
                    top: 70,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 210,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Container(
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: context.isDarkMode
                        ? ConstColors.goldAccent
                        : ConstColors.primaryTeal,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: ConstColors.goldAccent.withValues(alpha: 0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 295,
              left: 15,
              right: 15,
              bottom: 20,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 10,
                        children: [
                          _buildHintCard(
                            icon: Icons.touch_app_rounded,
                            text:
                                "يمكنك الضغط على الذكر لمعرفة تفاصيله أكثر وتعلمه",
                          ),
                          _buildHintCard(
                            icon: Icons.speaker_notes_rounded,
                            text: "اختر قول الذكر لقوله بالمرات المطلوبه",
                          ),
                          _buildHintCard(
                            icon: Icons.done,
                            text:
                                "بعد الانتهاء ستجد ان الذكر قد تم تمييزه بعلامة الحفظ",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.isDarkMode
                          ? ConstColors.goldAccent
                          : ConstColors.primaryTeal,
                      minimumSize: const Size(150, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "فهمت",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintCard({required IconData icon, required String text}) {
    return Card(
      color: Colors.black.withValues(alpha: 0.7),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          icon,
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: context.isDarkMode
                ? ConstColors.goldAccent
                : ConstColors.primaryTeal,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);
  late ScrollController _scrollController;

  @override
  void initState() {
    loadAzkar();
    _checkFirstTime();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _isScrolled.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= 40) {
      _isScrolled.value = true;
    } else {
      _isScrolled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder(
          valueListenable: _isScrolled,
          builder: (context, value, child) {
            return MyAppbar(
              pageName: ConstTexts.meraj,
              showSettingsButton: true,
              backgroundColor: _isScrolled.value
                  ? context.isDarkMode
                        ? ConstColors.darkBackAppBar
                        : ConstColors.lightBackAppBar
                  : null,
            );
          },
        ),
      ),

      body: SpecialBody(
        body: isLoading
            ? const Porgress()
            : ListView.builder(
                controller: _scrollController,
                itemCount: azkar.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final id = azkar[index]['id'];
                  final title = azkar[index]['title'];
                  final repeat = azkar[index]['repeat'];
                  final source = azkar[index]['source'];
                  final grade = azkar[index]['grade'];
                  final zikr = azkar[index]['zikr'];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.antiAlias,

                        builder: (context) {
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: context.screenSize.height * 0.6,
                              maxHeight: context.screenSize.height * 0.8,
                            ),
                            clipBehavior: Clip.antiAlias,
                            alignment: Alignment.center,
                            // height: context.screenSize.height * .8,
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: ConstColors.tealGradient,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 40,
                                children: [
                                  // data
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    spacing: 20,
                                    children: [
                                      ...[
                                        _sectionTitle(
                                          "الذكر المراد قوله",
                                          context,
                                        ),
                                        _zikrContentText(context, zikr),
                                      ],

                                      ...[
                                        _sectionTitle("التكرار", context),
                                        _zikrContentText(
                                          context,
                                          "${Tafqeet.convert(repeat.toString())} ${(repeat == 0
                                              ? "مرة"
                                              : (repeat >= 3 && repeat <= 10) || (repeat > 100 && repeat % 100 >= 3 && repeat % 100 <= 10)
                                              ? "مرات"
                                              : "مرة")}",
                                        ),
                                      ],

                                      ...[
                                        _sectionTitle("الفضل", context),

                                        _zikrContentText(context, source),
                                      ],
                                      ...[
                                        _sectionTitle("الإسناد", context),

                                        _zikrContentText(context, grade),
                                      ],
                                    ],
                                  ),

                                  // start button
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);

                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MerajZikrCounter(
                                                      id: id,
                                                      zikr: zikr,
                                                      repeat: repeat,
                                                      title: title,
                                                      fontSizeFactor:
                                                          widget.fontSizeFactor,
                                                    ),
                                              ),
                                            );

                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ConstColors.goldAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "قول الذكر",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color:
                                                        ConstColors.primaryTeal,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: FilledButton.icon(
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //     },
                                      //     style: FilledButton.styleFrom(
                                      //       padding: const EdgeInsets.symmetric(
                                      //         vertical: 14,
                                      //       ),
                                      //       backgroundColor: Colors.transparent,
                                      //       side: BorderSide.none,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10),
                                      //       ),
                                      //     ),
                                      //     label: Icon(
                                      //       Icons.close,
                                      //       color: ConstColors.goldAccent,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topRight,

                      children: [
                        //zikr
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(vertical: 14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: ConstColors.tealGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    textScaler: TextScaler.linear(
                                      widget.fontSizeFactor,
                                    ),
                                  ),
                                  child: Text(
                                    zikr,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //repeating
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ConstColors.goldAccent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(-4, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            "${repeat.toString().toArabicFormat()} ${(repeat == 0
                                ? "مرة"
                                : (repeat >= 3 && repeat <= 10) || (repeat > 100 && repeat % 100 >= 3 && repeat % 100 <= 10)
                                ? "مرات"
                                : "مرة")}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        //confirm zikr
                        FutureBuilder<bool>(
                          future: _userCompletedAzkar.checkIsZikrCompleted(id),

                          builder: (context, snapshot) {
                            final isCompleted = snapshot.data ?? false;

                            if (!isCompleted) {
                              return const SizedBox();
                            }

                            return Positioned(
                              left: 10,
                              top: 20,

                              child: Transform.rotate(
                                angle: 0.5,

                                child: Column(
                                  children: [
                                    Image.asset(
                                      ConstIcons.confirmUserZikr,
                                      width: 32,
                                    ),

                                    Text(
                                      "تم",

                                      style: TextStyle(
                                        color: context.isDarkMode
                                            ? ConstColors.goldAccent
                                            : ConstColors.primaryTeal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

Widget _sectionTitle(String title, BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 1),
    decoration: BoxDecoration(
      color: ConstColors.goldAccent.withValues(alpha: .05),
      border: Border.all(color: ConstColors.goldAccent, width: .4),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: ConstColors.goldAccent,
      ),
    ),
  );
}

Widget _zikrContentText(BuildContext context, String content) {
  return Text(
    content,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 18,
      fontFamily: 'arsura',
      color: ConstColors.goldAccent,
    ),
  );
}
