import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/services/app_actions_service.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';

import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diaa_almuslim/features/allah_names/allah_name_info.dart';
import 'package:diaa_almuslim/features/allah_names/allah_names_logic.dart';

class AllahNames extends StatefulWidget {
  const AllahNames({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<AllahNames> createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> {
  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);
  late ScrollController _scrollController;
  final Uri websiteUrl = Uri.parse("https://surahquran.com");
  final AllahNamesLogic names = AllahNamesLogic();
  bool isLoading = true;
  final AllahNamesLogic _logic = AllahNamesLogic();

  Future<void> openUrl() async {
    if (!await launchUrl(websiteUrl, mode: LaunchMode.externalApplication)) {
      if (!mounted) {
        return;
      }
      AppActionsService.showErrorSnackBar(
        context,
        "حدثت مشكلة غير متوقعة ، حاول لاحقا",
      );
    }
  }

  void _initData() async {
    try {
      await _logic.fetchData();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      throw Exception("Error while initializing data: $e");
    }
  }

  void _onScroll() {
    if (_scrollController.offset >= 40) {
      _isScrolled.value = true;
    } else {
      _isScrolled.value = false;
    }
  }

  @override
  void initState() {
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

  void showAllahNameBottomSheet(
    BuildContext context,
    String name,
    String meaning,
    double fontSizeFactor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: context.screenSize.height * .8,
        minHeight: context.screenSize.height * .6,
      ),
      isDismissible: true,
      // showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AllahNameInfoBottomSheet(
          name: name,
          meaning: meaning,
          fontSizeFactor: fontSizeFactor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: ConstTexts.allahNames,
        showSettingsButton: true,
      ),

      body: SpecialBody(
        showTopIcon: false,
        body: Column(
          children: [
            const SizedBox(height: 80),
            // header
            // Header(
            //   content:
            //       "يقول ﷺ: إن لله تسعة وتسعين اسمًا،\n من أحصاها دخل الجنة",
            // ),
            ValueListenableBuilder(
              valueListenable: _isScrolled,
              builder: (context, value, child) {
                return AnimatedSize(
                  clipBehavior: Clip.none,
                  duration: const Duration(milliseconds: 400),
                  child: value
                      ? const SizedBox.shrink()
                      : Container(
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: ConstColors.tealGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Image.asset(
                                  width: 400,
                                  ConstIcons.mosque,
                                  color: const Color.fromARGB(
                                    15,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        ConstIcons.allahNamesPageTitle,
                                        color: ConstColors.goldAccent,
                                        fit: BoxFit.contain,
                                        width: 200,
                                      ),
                                    ),
                                    const Text(
                                      "يقول النبي الكريم: إن لله تسعة وتسعين اسمًا،\n من أحصاها دخل الجنة",
                                      style: TextStyle(
                                        // fontFamily: "arsura",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: ConstColors.goldAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // source
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'المصدر:\t',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white38),
                                        ),
                                        TextButton(
                                          onPressed: () => showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            builder: (context) => Container(
                                              decoration: const BoxDecoration(
                                                gradient:
                                                    ConstColors.tealGradient,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(32),
                                                    ),
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                left: 24,
                                                right: 24,
                                                bottom: 40,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withValues(alpha: 0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  const Icon(
                                                    Icons.public,
                                                    color:
                                                        ConstColors.goldAccent,
                                                    size: 48,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    "فتح الموقع ؟",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    "سيؤدي فتح الموقع الى الخروج من التطبيق والتوجيه إلى المتصفح الخاص بك.",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.white70,
                                                          height: 1.5,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 32),
                                                  Row(
                                                    spacing: 12,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            openUrl();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                ConstColors
                                                                    .goldAccent,
                                                            foregroundColor:
                                                                ConstColors
                                                                    .primaryTeal,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    30,
                                                                  ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 14,
                                                                ),
                                                          ),
                                                          child: const Text(
                                                            "فتح",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          style: OutlinedButton.styleFrom(
                                                            side:
                                                                const BorderSide(
                                                                  color: Colors
                                                                      .white54,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    30,
                                                                  ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 14,
                                                                ),
                                                          ),
                                                          child: const Text(
                                                            "إلغاء",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "http://surahquran.com",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: ConstColors.goldAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
            // names
            Expanded(
              flex: 4,

              child: FutureBuilder(
                future: _logic.loadSavedNames(),
                builder: (context, snapshot) {
                  //waiting
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Porgress();
                  }
                  //no data
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    _initData();
                    return Center(
                      child: Text(
                        "جاري جلب الأسماء من الإنترنت...\nتأكد من اتصالك بالشبكة إذا طال الانتظار.\nهذا فقط في اول مرة",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.isDarkMode
                              ? ConstColors.goldAccent
                              : ConstColors.primaryTeal,
                        ),
                      ),
                    );
                  }
                  final nameList = snapshot.data!;

                  return GridView.builder(
                    controller: _scrollController,
                    itemCount: nameList.length,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final name = nameList[index]['name'];
                      final meaning = nameList[index]['meaning'];
                      final parts = name.split(' ');

                      final formattedName = parts.length > 2
                          ? "${parts[0]} ${parts[1]}\n${parts.sublist(2).join(' ')}"
                          : name;

                      return GestureDetector(
                        onTap: () {
                          showAllahNameBottomSheet(
                            context,
                            name,
                            meaning,
                            widget.fontSizeFactor,
                          );
                        },

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              ConstIcons.allahNameBox,
                              // color: context.isDarkMode
                              //     ? ConstColors.goldAccent
                              //     : ConstColors.primaryTeal,
                            ),
                            Text(
                              formattedName,
                              style: TextStyle(
                                color: ConstColors.goldAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: name.split(' ').length > 2 ? 12 : 20,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
