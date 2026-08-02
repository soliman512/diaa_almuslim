import 'package:diaa_almuslim/core/controllers/al_quran_controller.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:diaa_almuslim/features/al_quran/surah_button.dart';
import 'package:diaa_almuslim/features/al_quran/surah_page.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlQuran extends StatefulWidget {
  final double fontSizeFactor;

  const AlQuran({super.key, required this.fontSizeFactor});

  @override
  State<AlQuran> createState() => _AlQuranState();
}

class _AlQuranState extends State<AlQuran> {
  final AlQuranController _alQuranController = AlQuranController();
  late ScrollController _scrollController;

  TextEditingController searchController = TextEditingController();

 

  ValueNotifier<bool> removeHeader = ValueNotifier<bool>(false);

  @override
  void initState() {
    _scrollController = ScrollController();
    _alQuranController.init();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final double currentScrollOffset = _scrollController.offset;
    if (currentScrollOffset >= 40) {
      removeHeader.value = true;
    } else {
      removeHeader.value = false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _alQuranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(pageName: ConstTexts.quran, showSettingsButton: false),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: removeHeader,
        builder: (context, value, child) {
          return value
              ? FloatingActionButton(
                  onPressed: () {
                    _scrollController.jumpTo(0);
                  },
                  backgroundColor: ConstColors.goldAccent,
                  foregroundColor: ConstColors.primaryTeal,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.keyboard_double_arrow_up_rounded),
                )
              : const SizedBox.shrink();
        },
      ),
      body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    ValueListenableBuilder(
                      valueListenable: removeHeader,
                      builder: (builder, value, child) {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          child: value
                              ? const SizedBox.shrink()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom ==
                                        0)
                                      GestureDetector(
                                        onTap: () async {
                                          final pref =
                                              await SharedPreferences.getInstance();
                                          final int? lastPage = pref.getInt(
                                            'last_readed_page',
                                          );
                                          if (!context.mounted) {
                                            return;
                                          }
                                        
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  SurahPage(
                                                    pageNumber: lastPage ?? 0,
                                                    jsonData: _alQuranController.allSurahs,
                                                    shouldHighlightText:
                                                        false,
                                                    highlightVerse: "",
                                                  )),
                                            ),
                                          );
                                        },
      
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient:
                                                ConstColors.tealGradient,
                                          ),
                                          child: const ListTile(
                                            leading: Icon(
                                              Icons.watch_later_outlined,
                                              color: ConstColors.goldAccent,
                                            ),
                                            title: Text(
                                              "آخر ما تمَّ قراءَته",
                                              style: TextStyle(
                                                color: ConstColors.goldAccent,
                                              ),
                                            ),
                                            // subtitle: Text(
                                            //   "",
                                            //   style: TextStyle(
                                            //     color: Colors.black45,
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: ConstColors.goldAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: searchController,
                                      builder: (context, value, child) =>
                                          TextField(
                                            // onChanged: (value){
                                            //   value
                                            //   if(search)
                                            // },
                                            onChanged: (value) {
                                              _alQuranController
                                                  .onSearchChanged(value);
                                            },
                                            textInputAction:
                                                TextInputAction.search,
                                            cursorColor:
                                                ConstColors.deepOrange,
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              filled: false,
                                              fillColor: ConstColors.input,
                                              enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          context.isDarkMode
                                                          ? ConstColors
                                                                .goldAccent
                                                          : ConstColors
                                                                .primaryTeal,
                                                      width: 1,
                                                    ),
                                                  ),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          context.isDarkMode
                                                          ? ConstColors
                                                                .goldAccent
                                                          : ConstColors
                                                                .primaryTeal,
                                                      width: 1,
                                                    ),
                                                  ),
                                              hint: Opacity(
                                                opacity: .4,
                                                child: Text(
                                                  'ابحث عن سورة أو اية او رقم الصفحة',
                                                  style: TextTheme.of(
                                                    context,
                                                  ).bodySmall,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: context.isDarkMode
                                                    ? ConstColors.goldAccent
                                                    : ConstColors.primaryTeal,
                                              ),
                                              suffixIcon: value.text.isEmpty
                                                  ? null
                                                  : IconButton(
                                                      onPressed: () {
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
      
                                                        searchController
                                                            .clear();
                                                        _alQuranController
                                                            .onSearchChanged(
                                                              "",
                                                            );
                                                        // pageNumbers.clear();
                                                      },
                                                      icon: const Icon(
                                                        Icons.clear_rounded,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder(
                                      valueListenable: searchController,
                                      builder: ((context, value, child) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 3,
                                          children: [
                                            const Expanded(child: Divider()),
                                            Expanded(
                                              child: Opacity(
                                                opacity: .4,
                                                child: Text(
                                                  _alQuranController.pageNumbers.isEmpty ||
                                                          value.text
                                                              .trim()
                                                              .isEmpty
                                                      ? "الفهرس"
                                                      : "الصفحات",
                                                  textAlign: TextAlign.center,
                                                  style: TextTheme.of(
                                                    context,
                                                  ).bodySmall,
                                                ),
                                              ),
                                            ),
                                            const Expanded(child: Divider()),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                    Expanded(
                      flex: 14,
                      child: ListenableBuilder(
                        listenable: _alQuranController,
                        builder: (context, child) {
                          if (_alQuranController.isLoading) {
                            return const Center(child: Porgress());
                          }
                          // get all surahs or search by surah
                          if (_alQuranController.displaySurahs.isNotEmpty) {
                            return ListView.builder( controller: _scrollController,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  _alQuranController.displaySurahs.length,
                              itemBuilder: (context, index) {
                                var currentSurah =
                                    _alQuranController.displaySurahs[index];
                                return SurahButton(
                                  surhaName: currentSurah.arabicName,
                                  surahId: currentSurah.id,
                                  surahType:
                                      currentSurah.revelationPlace == 'Meccan'
                                      ? SurahType.makkah
                                      : SurahType.madinah,
                                  versesCount:
                                      "آياتها ${currentSurah.versesCount}",
                                  onTap: () {
                                    Navigator.push(
                                      context,
      
                                      MaterialPageRoute(
                                        builder: (builder) => SurahPage(
                                          // surahName: currentSurah.arabicName,
                                          highlightVerse: "",
      
                                          jsonData: _alQuranController.allSurahs,
      
                                          pageNumber: getPageNumber(
                                            currentSurah.id,
      
                                            1,
                                          ),
      
                                          shouldHighlightText: false,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                          //search by ayah
                          if (_alQuranController.ayahSearchResults != null) {
                            final results = _alQuranController
                                .ayahSearchResults!["result"];
                            final occurences = _alQuranController
                                .ayahSearchResults!["occurences"];
                            int count = occurences > 10 ? 10 : occurences;
      
                            return ListView.builder( controller: _scrollController,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: count,
                              itemBuilder: (context, index) {
                                int surahNum = results[index]["surah"];
                                int verseNum = results[index]["verse"];
      
                                return Card(
                                  color: ConstColors.primaryTeal,
      
                                  elevation: 2,
      
                                  child: ListTile(
                                    onTap: () {
                                      int targetPage = getPageNumber(
                                        surahNum,
      
                                        verseNum,
                                      );
      
                                      Navigator.push(
                                        context,
      
                                        MaterialPageRoute(
                                          builder: ((context) => SurahPage(
                                            pageNumber: targetPage,
      
                                            jsonData: _alQuranController.allSurahs,
      
                                            shouldHighlightText: true,
      
                                            highlightVerse: getVerse(
                                              surahNum,
      
                                              verseNum,
                                            ),
                                          )),
                                        ),
                                      );
                                    },
      
                                    contentPadding: const EdgeInsets.all(8),
      
                                    title: Text(
                                      getVerse(surahNum, verseNum),
      
                                      style: const TextStyle(
                                        fontSize: 18,
      
                                        fontFamily: 'arsura',
      
                                        color: Colors.white,
                                      ),
                                    ),
      
                                    trailing: const Icon(
                                      Icons.arrow_circle_left_rounded,
      
                                      color: Colors.white54,
                                    ),
      
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                      ),
      
                                      child: Text(
                                        "سورة ${getSurahNameArabic(surahNum)}",
      
                                        style: const TextStyle(
                                          color: ConstColors.deepYellow,
      
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          //search by page number
                          if (_alQuranController.pageNumbers.isNotEmpty) {
                            return ListView.builder( controller: _scrollController,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  _alQuranController.pageNumbers.length,
                              itemBuilder: (context, index) {
                                int currentPage =
                                    _alQuranController.pageNumbers[index];
                                var pageData = getPageData(currentPage);
                                List<int> surahsInThisPage = pageData
                                    .map<int>((data) => data["surah"] as int)
                                    .toSet()
                                    .toList();
      
                                return Column(
                                  children: surahsInThisPage.map((surahNum) {
                                    return SurahButton(
                                      surhaName: getSurahNameArabic(surahNum),
                                      surahId: surahNum,
                                      surahType:
                                          getPlaceOfRevelation(surahNum) ==
                                              'Makkah'
                                          ? SurahType.makkah
                                          : SurahType.madinah,
                                      versesCount: "صفحة : $currentPage",
                                      onTap: () {
                                        Navigator.push(
                                          context,
      
                                          MaterialPageRoute(
                                            builder: ((context) => SurahPage(
                                              highlightVerse: "",
      
                                              shouldHighlightText: false,
      
                                              pageNumber: currentPage,
      
                                              jsonData: _alQuranController.allSurahs,
                                            )),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          }
      
                          return Center(
                            child: Text(
                              "لا توجد نتائج مطابقة للبحث",
                              style: TextTheme.of(context).bodyMedium,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
