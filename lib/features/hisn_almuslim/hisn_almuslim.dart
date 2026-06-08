import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/services/app_actions_service.dart';
import 'package:zad_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/features/hisn_almuslim/hisn_almuslim_logic.dart';

class HisnAlmuslim extends StatefulWidget {
  const HisnAlmuslim({super.key});

  @override
  State<HisnAlmuslim> createState() => _HisnAlmuslimState();
}

class _HisnAlmuslimState extends State<HisnAlmuslim> {
  //data
  dynamic data = [];

  //globals
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey _searchWidgetKey = GlobalKey();

  //controllers
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //value notifiers
  final ValueNotifier<double> _topPositionNotifier = ValueNotifier<double>(
    -100.0,
  );
  final ValueNotifier<bool> _showFloatingActionButton = ValueNotifier<bool>(
    false,
  );
  final ValueNotifier<bool> _showAllIntro = ValueNotifier<bool>(false);

  final ValueNotifier<List<MapEntry<String, dynamic>>> _filteredAzkarNotifier =
      ValueNotifier<List<MapEntry<String, dynamic>>>([]);

  //other vars
  bool isLoading = true;
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  void getData() async {
    try {
      data = await HisnAlmuslimLogic.getData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppActionsService.showErrorSnackBar(context, e.toString());
      print(e);
    }
  }

  void _filterAzkar(String query) {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredAzkarNotifier.value = [];
      return;
    }

    final allEntries = (data as Map<String, dynamic>).entries.toList().sublist(
      2,
    );

    final filtered = allEntries.where((entry) {
      final title = entry.key;
      final content = entry.value as Map;
      //search on title ( if founded return with to _filteredAzkarNotifier.value = filtered)
      if (title.contains(_searchQuery)) return true;

      final texts = content['text'] as List<dynamic>;
      final footnotes = content['footnote'] as List<dynamic>;

      //search in value[content] (text elements)
      for (var text in texts) {
        if (text.toString().contains(_searchQuery)) return true;
      }

      //search in value[content] (footnotes elements)
      for (var note in footnotes) {
        if (note.toString().contains(_searchQuery)) return true;
      }

      return false;
    }).toList();

    _filteredAzkarNotifier.value = filtered;
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 120) {
        _topPositionNotifier.value = -250.0;
      } else {
        _topPositionNotifier.value = -100.0;
      }
      if (_scrollController.offset > 3000) {
        _showFloatingActionButton.value = true;
      } else {
        _showFloatingActionButton.value = false;
      }
    });
    getData();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _topPositionNotifier.dispose();
    _showFloatingActionButton.dispose();
    _filteredAzkarNotifier.dispose();
    _showAllIntro.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: "",
        onPressDrawer: () => scaffoldState.currentState!.openDrawer(),
      ),
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _showFloatingActionButton,
        builder: (context, value, child) => Visibility(
          visible: value,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: () {
              if (_searchWidgetKey.currentContext != null) {
                Scrollable.ensureVisible(
                  _searchWidgetKey.currentContext!,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }

              FocusScope.of(context).requestFocus(_searchFocusNode);
            },
            foregroundColor: Colors.white,
            backgroundColor: ConstColors.deepOrange,
            child: Icon(Icons.search_rounded),
          ),
        ),
      ),
      body: Stack(
        children: [
          // top shape
          ValueListenableBuilder(
            valueListenable: _topPositionNotifier,
            builder: (context, _, child) => AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 80,
              right: 80,
              top: _topPositionNotifier.value,
              child: Opacity(
                opacity: .9,
                child: Image.asset(ConstIcons.hisnAlmuslimCoverShape),
              ),
            ),
          ),
          SpecialBody(
            body: isLoading
                ? Porgress()
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 120),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white10,
                                    blurRadius: 100,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                ConstIcons.hisnElmuslimTitle,
                                width: 260,
                              ),
                            ),
                            Opacity(
                              opacity: .8,
                              child: Text(
                                (data["المقدمة"]["footnote"] as List).reversed
                                    .join("\n"),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(height: 2),

                                textAlign: TextAlign.center,
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_searchWidgetKey.currentContext != null) {
                                    Scrollable.ensureVisible(
                                      _searchWidgetKey.currentContext!,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConstColors.deepOrange,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  "الذهاب للمحتوى مباشرة",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            (() {
                              final introList = data["المقدمة"]["text"] as List;
                              final basmalah = introList[0].toString();
                              final remainingText = introList
                                  .sublist(1)
                                  .join("\n");

                              return ValueListenableBuilder(
                                valueListenable: _showAllIntro,

                                builder: (context, value, child) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      basmalah,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),

                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),

                                    Text(
                                      remainingText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(height: 2),
                                      overflow: TextOverflow.fade,
                                      maxLines: value ? null : 7,
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _showAllIntro.value =
                                            !_showAllIntro.value;
                                      },
                                      child: Text(
                                        value ? "المختصر" : "الإظهار كاملََا",
                                        style: TextStyle(
                                          color: ConstColors.deepOrange,
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.dotted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })(),
                            Text(
                              "المحتوى بعد الفضل مباشرة",
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(fontSize: 10, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            line(),
                            Text(
                              "فضل الذكر",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ...List.generate(
                              (data["فضل الذكر"]["text"] as List).length,
                              (index) {
                                final String text =
                                    data["فضل الذكر"]["text"][index].toString();
                                final String footnote =
                                    data["فضل الذكر"]["footnote"][index]
                                        .toString();
                                return Card(
                                  color: ConstColors.mainColor,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                      child: Text(
                                        (index + 1).toString().toArabicFormat(),
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    title: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.6,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        footnote,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: ConstColors.secondMainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            line(),
                            SizedBox(height: 40),
                            TextField(
                              key: _searchWidgetKey,
                              controller: searchController,
                              onChanged: _filterAzkar,
                              focusNode: _searchFocusNode,
                              cursorColor: ConstColors.deepOrange,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: "ما الذي تريد معرفته",

                                hintStyle: TextStyle(color: Colors.black54),
                                fillColor: ConstColors.deepOrange.withOpacity(
                                  .08,
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ConstColors.deepOrange,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ConstColors.deepOrange,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: ConstColors.deepOrange,
                                  size: 28,
                                ),
                                suffixIcon:
                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: searchController,
                                      builder: (context, value, child) {
                                        return value.text.isNotEmpty
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    searchController.clear();
                                                  });
                                                },
                                                icon: Icon(Icons.close),
                                              )
                                            : const SizedBox.shrink();
                                      },
                                    ),
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                      // SliverAppBar(
                      //   pinned: true,
                      //   backgroundColor: Theme.of(
                      //     context,
                      //   ).scaffoldBackgroundColor,
                      //   title: Text(
                      //     "المحتوى",
                      //     style: Theme.of(context).textTheme.bodyMedium!
                      //         .copyWith(
                      //           fontWeight: FontWeight.bold,
                      //           color: ConstColors.mainColor,
                      //           fontSize: 18,
                      //         ),
                      //   ),
                      //   centerTitle: true,
                      //   elevation: 0,
                      //   automaticallyImplyActions: false,
                      //   automaticallyImplyLeading: false,
                      // ),
                      Azkar(
                        data: data,
                        filteredAzkarNotifier: _filteredAzkarNotifier,
                        checkIsUserTyping: searchController,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

Widget line() {
  return Column(children: [Divider(), SizedBox(height: 16)]);
}

class Azkar extends StatelessWidget {
  final List<MapEntry<String, dynamic>> azkarEntires;
  dynamic data;
  ValueNotifier<List<MapEntry<String, dynamic>>> filteredAzkarNotifier =
      ValueNotifier<List<MapEntry<String, dynamic>>>([]);
  TextEditingController checkIsUserTyping = TextEditingController();
  Azkar({
    super.key,
    required this.data,
    required this.filteredAzkarNotifier,
    required this.checkIsUserTyping,
  }) : azkarEntires = (data as Map<String, dynamic>).entries.toList().sublist(
         2,
       );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MapEntry<String, dynamic>>>(
      valueListenable: filteredAzkarNotifier,
      builder: (context, filteredList, child) {
        final bool isSearching = filteredList.isNotEmpty;
        final List<MapEntry<String, dynamic>> entriesToShow = isSearching
            ? filteredList
            : (data as Map<String, dynamic>).entries.toList().sublist(2);

        if (checkIsUserTyping.text.trim().isNotEmpty && !isSearching) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  "لا توجد نتائج مطابقة للبحث",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: entriesToShow.length,
            (context, index) {
              final entry = entriesToShow[index];
              // final entry = azkarEntires[index];
              final String zikrTitle = entry.key;
              final dynamic zikrContent = entry.value;

              final List<dynamic> texts = zikrContent["text"];
              final List<dynamic> footnotes = zikrContent["footnote"];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: ExpansionTile(
                  //opend
                  backgroundColor: const Color.fromARGB(242, 233, 233, 233),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: ConstColors.mainColor, width: 1.5),
                  ),
                  iconColor: ConstColors.mainColor,
                  textColor: ConstColors.mainColor,

                  //closed
                  collapsedTextColor: Colors.white,
                  collapsedBackgroundColor: ConstColors.mainColor,
                  collapsedIconColor: ConstColors.secondMainColor,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "${index + 1} - $zikrTitle".toArabicFormat(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          ...List.generate(
                            texts.length,
                            (subIndex) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16.0,
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    texts[subIndex].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 2,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "uthman",
                                      color: ConstColors.mainColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // const SizedBox(height: 12),
                                  line(),
                                  if (footnotes.length > subIndex)
                                    Text(
                                      footnotes[subIndex].toString(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
