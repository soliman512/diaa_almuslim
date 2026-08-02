import 'package:diaa_almuslim/core/constants/routes.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diaa_almuslim/core/widgets/basmallah.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/widgets/surah_header.dart';

///TODO:
/// header [done]
/// change surah name [done]
/// show current hizb and current juz and snackbar [done]
/// right/left page [done]
/// last page [done]
/// mark [done]
/// dark mode [done]
/// verse auto-highlight [done]

class SurahPage extends StatefulWidget {
  final int pageNumber;
  final dynamic jsonData;

  final bool shouldHighlightText;
  final dynamic highlightVerse;

  final int? verse;
  final bool shouldHighlightVerse;

  const SurahPage({
    Key? key,
    required this.pageNumber,
    required this.jsonData,
    this.shouldHighlightText = false,
    this.highlightVerse,
    this.verse,
    this.shouldHighlightVerse = false,
  }) : super(key: key);

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  static const Map<int, String> _quranMarks = {
    // ---------------- الجزء الأول ----------------
    2: 'الحزب الأول',
    4: 'ربع الحزب الأول',
    7: 'نصف الحزب الأول',
    9: 'ثلاثة أرباع الحزب الأول',
    12: 'الحزب الثاني',
    14: 'ربع الحزب الثاني',
    16: 'نصف الحزب الثاني',
    19: 'ثلاثة أرباع الحزب الثاني',

    // ---------------- الجزء الثاني ----------------
    22: 'الحزب الثالث',
    24: 'ربع الحزب الثالث',
    27: 'نصف الحزب الثالث',
    29: 'ثلاثة أرباع الحزب الثالث',
    32: 'الحزب الرابع',
    34: 'ربع الحزب الرابع',
    37: 'نصف الحزب الرابع',
    39: 'ثلاثة أرباع الحزب الرابع',

    // ---------------- الجزء الثالث ----------------
    42: 'الحزب الخامس',
    44: 'ربع الحزب الخامس',
    46: 'نصف الحزب الخامس',
    48: 'ثلاثة أرباع الحزب الخامس',
    52: 'الحزب السادس',
    54: 'ربع الحزب السادس',
    56: 'نصف الحزب السادس',
    59: 'ثلاثة أرباع الحزب السادس',

    // ---------------- الجزء الرابع ----------------
    62: 'الحزب السابع',
    64: 'ربع الحزب السابع',
    66: 'نصف الحزب السابع',
    69: 'ثلاثة أرباع الحزب السابع',
    72: 'الحزب الثامن',
    74: 'ربع الحزب الثامن',
    77: 'نصف الحزب الثامن',
    79: 'ثلاثة أرباع الحزب الثامن',

    // ---------------- الجزء الخامس ----------------
    82: 'الحزب التاسع',
    84: 'ربع الحزب التاسع',
    87: 'نصف الحزب التاسع',
    89: 'ثلاثة أرباع الحزب التاسع',
    92: 'الحزب العاشر',
    94: 'ربع الحزب العاشر',
    97: 'نصف الحزب العاشر',
    99: 'ثلاثة أرباع الحزب العاشر',

    // ---------------- الجزء السادس ----------------
    102: 'الحزب الحادي عشر',
    104: 'ربع الحزب الحادي عشر',
    107: 'نصف الحزب الحادي عشر',
    109: 'ثلاثة أرباع الحزب الحادي عشر',
    112: 'الحزب الثاني عشر',
    114: 'ربع الحزب الثاني عشر',
    117: 'نصف الحزب الثاني عشر',
    119: 'ثلاثة أرباع الحزب الثاني عشر',

    // ---------------- الجزء السابع ----------------
    122: 'الحزب الثالث عشر',
    124: 'ربع الحزب الثالث عشر',
    126: 'نصف الحزب الثالث عشر',
    129: 'ثلاثة أرباع الحزب الثالث عشر',
    132: 'الحزب الرابع عشر',
    135: 'ربع الحزب الرابع عشر',
    137: 'نصف الحزب الرابع عشر',
    139: 'ثلاثة أرباع الحزب الرابع عشر',

    // ---------------- الجزء الثامن ----------------
    142: 'الحزب الخامس عشر',
    144: 'ربع الحزب الخامس عشر',
    146: 'نصف الحزب الخامس عشر',
    149: 'ثلاثة أرباع الحزب الخامس عشر',
    152: 'الحزب السادس عشر',
    154: 'ربع الحزب السادس عشر',
    156: 'نصف الحزب السادس عشر',
    159: 'ثلاثة أرباع الحزب السادس عشر',

    // ---------------- الجزء التاسع ----------------
    162: 'الحزب السابع عشر',
    164: 'ربع الحزب السابع عشر',
    167: 'نصف الحزب السابع عشر',
    169: 'ثلاثة أرباع الحزب السابع عشر',
    172: 'الحزب الثامن عشر',
    174: 'ربع الحزب الثامن عشر',
    177: 'نصف الحزب الثامن عشر',
    179: 'ثلاثة أرباع الحزب الثامن عشر',

    // ---------------- الجزء العاشر ----------------
    182: 'الحزب التاسع عشر',
    184: 'ربع الحزب التاسع عشر',
    187: 'نصف الحزب التاسع عشر',
    189: 'ثلاثة أرباع الحزب التاسع عشر',
    192: 'الحزب العشرون',
    194: 'ربع الحزب العشرون',
    196: 'نصف الحزب العشرون',
    199: 'ثلاثة أرباع الحزب العشرون',

    // ---------------- الجزء الحادي عشر ----------------
    202: 'الحزب الحادي والعشرون',
    204: 'ربع الحزب الحادي والعشرين',
    206: 'نصف الحزب الحادي والعشرين',
    209: 'ثلاثة أرباع الحزب الحادي والعشرين',
    212: 'الحزب الثاني والعشرون',
    214: 'ربع الحزب الثاني والعشرين',
    217: 'نصف الحزب الثاني والعشرين',
    219: 'ثلاثة أرباع الحزب الثاني والعشرين',

    // ---------------- الجزء الثاني عشر ----------------
    222: 'الحزب الثالث والعشرون',
    224: 'ربع الحزب الثالث والعشرين',
    227: 'نصف الحزب الثالث والعشرين',
    229: 'ثلاثة أرباع الحزب الثالث والعشرين',
    232: 'الحزب الرابع والعشرون',
    235: 'ربع الحزب الرابع والعشرين',
    236: 'نصف الحزب الرابع والعشرين',
    239: 'ثلاثة أرباع الحزب الرابع والعشرين',

    // ---------------- الجزء الثالث عشر ----------------
    242: 'الحزب الخامس والعشرون',
    244: 'ربع الحزب الخامس والعشرين',
    247: 'نصف الحزب الخامس والعشرين',
    249: 'ثلاثة أرباع الحزب الخامس والعشرين',
    252: 'الحزب السادس والعشرون',
    254: 'ربع الحزب السادس والعشرين',
    257: 'نصف الحزب السادس والعشرين',
    259: 'ثلاثة أرباع الحزب السادس والعشرين',

    // ---------------- الجزء الرابع عشر ----------------
    262: 'الحزب السابع والعشرون',
    264: 'ربع الحزب السابع والعشرين',
    267: 'نصف الحزب السابع والعشرين',
    270: 'ثلاثة أرباع الحزب السابع والعشرين',
    272: 'الحزب الثامن والعشرون',
    274: 'ربع الحزب الثامن والعشرين',
    277: 'نصف الحزب الثامن والعشرين',
    279: 'ثلاثة أرباع الحزب الثامن والعشرين',

    // ---------------- الجزء الخامس عشر ----------------
    282: 'الحزب التاسع والعشرون',
    284: 'ربع الحزب التاسع والعشرين',
    287: 'نصف الحزب التاسع والعشرين',
    289: 'ثلاثة أرباع الحزب التاسع والعشرين',
    292: 'الحزب الثلاثون',
    294: 'ربع الحزب الثلاثين',
    297: 'نصف الحزب الثلاثين',
    299: 'ثلاثة أرباع الحزب الثلاثين',

    // ---------------- الجزء السادس عشر ----------------
    302: 'الحزب الحادي والثلاثون',
    304: 'ربع الحزب الحادي والثلاثين',
    307: 'نصف الحزب الحادي والثلاثين',
    309: 'ثلاثة أرباع الحزب الحادي والثلاثين',
    312: 'الحزب الثاني والثلاثون',
    314: 'ربع الحزب الثاني والثلاثين',
    317: 'نصف الحزب الثاني والثلاثين',
    320: 'ثلاثة أرباع الحزب الثاني والثلاثين',

    // ---------------- الجزء السابع عشر ----------------
    322: 'الحزب الثالث والثلاثون',
    324: 'ربع الحزب الثالث والثلاثين',
    326: 'نصف الحزب الثالث والثلاثين',
    329: 'ثلاثة أرباع الحزب الثالث والثلاثين',
    332: 'الحزب الرابع والثلاثون',
    334: 'ربع الحزب الرابع والثلاثين',
    336: 'نصف الحزب الرابع والثلاثين',
    339: 'ثلاثة أرباع الحزب الرابع والثلاثين',

    // ---------------- الجزء الثامن عشر ----------------
    342: 'الحزب الخامس والثلاثون',
    344: 'ربع الحزب الخامس والثلاثين',
    347: 'نصف الحزب الخامس والثلاثين',
    350: 'ثلاثة أرباع الحزب الخامس والثلاثين',
    352: 'الحزب السادس والثلاثون',
    354: 'ربع الحزب السادس والثلاثين',
    357: 'نصف الحزب السادس والثلاثين',
    359: 'ثلاثة أرباع الحزب السادس والثلاثين',

    // ---------------- الجزء التاسع عشر ----------------
    362: 'الحزب السابع والثلاثون',
    364: 'ربع الحزب السابع والثلاثين',
    367: 'نصف الحزب السابع والثلاثين',
    369: 'ثلاثة أرباع الحزب السابع والثلاثين',
    372: 'الحزب الثامن والثلاثون',
    374: 'ربع الحزب الثامن والثلاثين',
    377: 'نصف الحزب الثامن والثلاثين',
    379: 'ثلاثة أرباع الحزب الثامن والثلاثين',

    // ---------------- الجزء العشرون ----------------
    382: 'الحزب التاسع والثلاثون',
    384: 'ربع الحزب التاسع والثلاثين',
    386: 'نصف الحزب التاسع والثلاثين',
    389: 'ثلاثة أرباع الحزب التاسع والثلاثين',
    392: 'الحزب الأربعون',
    394: 'ربع الحزب الأربعين',
    396: 'نصف الحزب الأربعين',
    399: 'ثلاثة أرباع الحزب الأربعين',

    // ---------------- الجزء الحادي والعشرون ----------------
    402: 'الحزب الحادي والأربعون',
    404: 'ربع الحزب الحادي والأربعين',
    407: 'نصف الحزب الحادي والأربعين',
    410: 'ثلاثة أرباع الحزب الحادي والأربعين',
    412: 'الحزب الثاني والأربعون',
    416: 'ربع الحزب الثاني والأربعين',
    418: 'نصف الحزب الثاني والأربعين',
    420: 'ثلاثة أرباع الحزب الثاني والأربعين',

    // ---------------- الجزء الثاني والعشرون ----------------
    422: 'الحزب الثالث والأربعون',
    424: 'ربع الحزب الثالث والأربعين',
    427: 'نصف الحزب الثالث والأربعين',
    429: 'ثلاثة أرباع الحزب الثالث والأربعين',
    432: 'الحزب الرابع والأربعون',
    434: 'ربع الحزب الرابع والأربعين',
    436: 'نصف الحزب الرابع والأربعين',
    439: 'ثلاثة أرباع الحزب الرابع والأربعين',

    // ---------------- الجزء الثالث والعشرون ----------------
    442: 'الحزب الخامس والأربعون',
    444: 'ربع الحزب الخامس والأربعين',
    447: 'نصف الحزب الخامس والأربعين',
    449: 'ثلاثة أرباع الحزب الخامس والأربعين',
    452: 'الحزب السادس والأربعون',
    454: 'ربع الحزب السادس والأربعين',
    456: 'نصف الحزب السادس والأربعين',
    459: 'ثلاثة أرباع الحزب السادس والأربعين',

    // ---------------- الجزء الرابع والعشرون ----------------
    462: 'الحزب السابع والأربعون',
    464: 'ربع الحزب السابع والأربعين',
    467: 'نصف الحزب السابع والأربعين',
    469: 'ثلاثة أرباع الحزب السابع والأربعين',
    472: 'الحزب الثامن والأربعون',
    474: 'ربع الحزب الثامن والأربعين',
    477: 'نصف الحزب الثامن والأربعين',
    480: 'ثلاثة أرباع الحزب الثامن والأربعين',

    // ---------------- الجزء الخامس والعشرون ----------------
    482: 'الحزب التاسع والأربعون',
    484: 'ربع الحزب التاسع والأربعين',
    486: 'نصف الحزب التاسع والأربعين',
    488: 'ثلاثة أرباع الحزب التاسع والأربعين',
    492: 'الحزب الخمسون',
    494: 'ربع الحزب الخمسين',
    497: 'نصف الحزب الخمسين',
    500: 'ثلاثة أرباع الحزب الخمسين',

    // ---------------- الجزء السادس والعشرون ----------------
    502: 'الحزب الحادي والخمسون',
    504: 'ربع الحزب الحادي والخمسين',
    508: 'نصف الحزب الحادي والخمسين',
    510: 'ثلاثة أرباع الحزب الحادي والخمسين',
    512: 'الحزب الثاني والخمسون',
    515: 'ربع الحزب الثاني والخمسين',
    517: 'نصف الحزب الثاني والخمسين',
    519: 'ثلاثة أرباع الحزب الثاني والخمسين',

    // ---------------- الجزء السابع والعشرون ----------------
    522: 'الحزب الثالث والخمسون',
    524: 'ربع الحزب الثالث والخمسين',
    527: 'نصف الحزب الثالث والخمسين',
    529: 'ثلاثة أرباع الحزب الثالث والخمسين',
    532: 'الحزب الرابع والخمسون',
    536: 'ربع الحزب الرابع والخمسين',
    539: 'نصف الحزب الرابع والخمسين',
    541: 'ثلاثة أرباع الحزب الرابع والخمسين',

    // ---------------- الجزء الثامن والعشرون ----------------
    542: 'الحزب الخامس والخمسون',
    544: 'ربع الحزب الخامس والخمسين',
    547: 'نصف الحزب الخامس والخمسين',
    549: 'ثلاثة أرباع الحزب الخامس والخمسين',
    552: 'الحزب السادس والخمسون',
    554: 'ربع الحزب السادس والخمسين',
    556: 'نصف الحزب السادس والخمسين',
    558: 'ثلاثة أرباع الحزب السادس والخمسين',

    // ---------------- الجزء التاسع والعشرون ----------------
    562: 'الحزب السابع والخمسون',
    564: 'ربع الحزب السابع والخمسين',
    566: 'نصف الحزب السابع والخمسين',
    569: 'ثلاثة أرباع الحزب السابع والخمسين',
    572: 'الحزب الثامن والخمسون',
    574: 'ربع الحزب الثامن والخمسين',
    577: 'نصف الحزب الثامن والخمسين',
    579: 'ثلاثة أرباع الحزب الثامن والخمسين',

    // ---------------- الجزء الثلاثون ----------------
    582: 'الحزب التاسع والخمسون',
    585: 'ربع الحزب التاسع والخمسين',
    587: 'نصف الحزب التاسع والخمسين',
    589: 'ثلاثة أرباع الحزب التاسع والخمسين',
    591: 'الحزب الستون',
    594: 'ربع الحزب الستين',
    596: 'نصف الحزب الستين',
    599: 'ثلاثة أرباع الحزب الستين',
  };

  static const List<int> _juzStartPages = [
    0, // cover
    1, // الجزء الأول
    22, // الجزء الثاني
    42, // الجزء الثالث
    62, // الجزء الرابع
    82, // الجزء الخامس
    102, // الجزء السادس
    122, // الجزء السابع
    142, // الجزء الثامن
    162, // الجزء التاسع
    182, // الجزء العاشر
    202, // الجزء الحادي عشر
    222, // الجزء الثاني عشر
    242, // الجزء الثالث عشر
    262, // الجزء الرابع عشر
    282, // الجزء الخامس عشر
    302, // الجزء السادس عشر
    322, // الجزء السابع عشر
    342, // الجزء الثامن عشر
    362, // الجزء التاسع عشر
    382, // الجزء العشرون
    402, // الجزء الحادي والعشرون
    422, // الجزء الثاني والعشرون
    442, // الجزء الثالث والعشرون
    462, // الجزء الرابع والعشرون
    482, // الجزء الخامس والعشرون
    502, // الجزء السادس والعشرون
    522, // الجزء السابع والعشرون
    542, // الجزء الثامن والعشرون
    562, // الجزء التاسع والعشرون
    582, // الجزء الثلاثون
  ];

  static const List<String> _arabicOrdinals = [
    'الأول',
    'الثاني',
    'الثالث',
    'الرابع',
    'الخامس',
    'السادس',
    'السابع',
    'الثامن',
    'التاسع',
    'العاشر',
    'الحادي عشر',
    'الثاني عشر',
    'الثالث عشر',
    'الرابع عشر',
    'الخامس عشر',
    'السادس عشر',
    'السابع عشر',
    'الثامن عشر',
    'التاسع عشر',
    'العشرون',
    'الحادي والعشرون',
    'الثاني والعشرون',
    'الثالث والعشرون',
    'الرابع والعشرون',
    'الخامس والعشرون',
    'السادس والعشرون',
    'السابع والعشرون',
    'الثامن والعشرون',
    'التاسع والعشرون',
    'الثلاثون',
  ];

  final List<GlobalKey> richTextKeys = List.generate(604, (_) => GlobalKey());

  final ValueNotifier<int> currentPageNum = ValueNotifier<int>(0);
  final ValueNotifier<int> lastPage = ValueNotifier<int>(0);
  final ValueNotifier<int> markedPage = ValueNotifier<int>(0);

  late final PageController _pageController;

  SharedPreferences? _prefs;

  final Map<int, List> _pageDataCache = {};

  bool isPageMarked = false;

  @override
  void initState() {
    super.initState();
    currentPageNum.value = widget.pageNumber;
    _pageController = PageController(initialPage: currentPageNum.value);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (currentPageNum.value != 0) {
      isPageMarked = await _checkIsPageMarked(currentPageNum.value);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    currentPageNum.dispose();
    lastPage.dispose();
    markedPage.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  List _cachedPageData(int page) {
    return _pageDataCache.putIfAbsent(page, () => getPageData(page));
  }

  double _fontSizeForPage(int index) {
    if (index == 1 || index == 2) return 28.sp;
    if (index == 145 || index == 201) {
      return (index == 532 || index == 533) ? 22.5.sp : 22.4.sp;
    }
    return 23.1.sp;
  }

  String getArabicOrdinal(int number) {
    if (number < 1 || number > 30) {
      return 'الرقم خارج النطاق';
    }
    return _arabicOrdinals[number - 1];
  }

  Future<bool> _checkIsPageMarked(int page) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    return page == prefs.getInt('quran_marked_page');
  }

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder(
      valueListenable: currentPageNum,
      builder: (context, value, child) {
        return AppScaffold(
          extendBodyBehindAppBar: value == 0,
          appBar: _buildAppBar(context),
          body: PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: totalPagesCount + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Image.asset(
                  isDark
                      ? ConstIcons.darkQuranCover
                      : ConstIcons.lightQuranCover,
                  fit: BoxFit.cover,
                );
              }

              return SingleChildScrollView(
                child: Column(
                  spacing: 0,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: currentPageNum,
                      builder: (context, num, child) {
                        if (num == 0) return const SizedBox();
                        return _buildPageInfoBar(index: num);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          if (index == 1 || index == 2)
                            SizedBox(height: (screenSize.height * .15)),
                          _buildMushafRichText(index: index, isDark: isDark),
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

  Future<void> _onPageChanged(int page) async {
    final prefs = await _getPrefs();
    await prefs.setInt('last_readed_page', page);

    isPageMarked = await _checkIsPageMarked(page);

    if (_quranMarks.containsKey(page)) {
      final message = _quranMarks[page];
      Fluttertoast.showToast(
        msg: message ?? "علامة".toArabicFormat(),
        backgroundColor: ConstColors.primaryTeal,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    currentPageNum.value = page;
    lastPage.value = page;
  }

  Widget _buildPageInfoBar({required int index}) {
    final firstVerseData = _cachedPageData(index)[0];
    final int surahNum = firstVerseData["surah"];
    final int verseNum = firstVerseData["start"];
    final int currentJuz = getJuzNumber(surahNum, verseNum);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              if (isPageMarked)
                Icon(
                  Icons.bookmark,
                  color: context.isDarkMode
                      ? ConstColors.goldAccent
                      : ConstColors.primaryTeal,
                ),
              Text(
                "صفحة  $index".toArabicFormat(),
                style: TextStyle(
                  color: context.isDarkMode
                      ? ConstColors.goldAccent
                      : ConstColors.primaryTeal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'cairo',
                ),
              ),
            ],
          ),
          Transform.flip(
            flipX: index % 2 == 0,
            child: const Icon(Icons.menu_book_sharp, color: Colors.grey),
          ),
          Text(
            "الجزء  ${getArabicOrdinal(currentJuz)}".toArabicFormat(),
            style: TextStyle(
              color: context.isDarkMode
                  ? ConstColors.goldAccent
                  : ConstColors.primaryTeal,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMushafRichText({required int index, required bool isDark}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          width: double.infinity,
          child: RichText(
            key: richTextKeys[index - 1],
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            softWrap: true,
            locale: const Locale("ar"),
            text: TextSpan(
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 23.sp,
              ),
              children: _buildVerseSpans(index: index, isDark: isDark),
            ),
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _buildVerseSpans({
    required int index,
    required bool isDark,
  }) {
    final bool highlightEnabled =
        widget.shouldHighlightVerse && widget.verse != null;
    final double lineHeight = (index == 1 || index == 2) ? 2.h : 1.95.h;
    final double fontSize = _fontSizeForPage(index);
    final Color baseColor = isDark ? Colors.white : Colors.black;
    final String fontFamily = "QCF_P${index.toString().padLeft(3, "0")}";

    return _cachedPageData(index).expand((e) {
      final List<InlineSpan> spans = [];
      for (var i = e["start"]; i <= e["end"]; i++) {
        // Header
        if (i == 1) {
          spans.add(
            WidgetSpan(
              child: SurahHeader(e: e, jsonData: widget.jsonData),
            ),
          );
          if (index != 187 && index != 1) {
            spans.add(WidgetSpan(child: Basmallah(index: 0, isDark: isDark)));
          }
          if (index == 187) {
            spans.add(WidgetSpan(child: Container(height: 10.h)));
          }
        }

        String verseText = getVerseQCF(e["surah"], i).replaceAll(' ', '');

        if (i == e["start"]) {
          verseText =
              "${verseText.substring(0, 1)}\u200A${verseText.substring(1)}";
        }

        final bool isHighlighted = highlightEnabled && i == widget.verse;

        spans.add(
          TextSpan(
            text: verseText,
            style: TextStyle(
              color: baseColor,
              height: lineHeight,
              letterSpacing: 0.w,
              wordSpacing: 0,
              fontFamily: fontFamily,
              fontSize: fontSize,
              backgroundColor: isHighlighted
                  ? context.isDarkMode
                        ? ConstColors.goldAccent
                        : ConstColors.primaryTeal.withValues(alpha: 0.25)
                  : Colors.transparent,
            ),
          ),
        );
      }
      return spans;
    }).toList();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      centerTitle: true,
      title: ValueListenableBuilder<int>(
        valueListenable: currentPageNum,
        builder: (context, index, child) {
          if (index == 0) return const SizedBox();
          final int currentSurahNum = _cachedPageData(index)[0]["surah"];
          return RichText(
            text: TextSpan(
              text: "$currentSurahNum",
              style: TextStyle(
                color: context.isDarkMode
                    ? ConstColors.goldAccent
                    : ConstColors.primaryTeal,
                fontSize: 33.sp,
                fontFamily: "arsura",
              ),
            ),
          );
        },
      ),
      leading: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 12,
        position: PopupMenuPosition.under,
        color: ConstColors.primaryTeal,
        icon: Icon(
          Icons.more_outlined,
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          mentuButton(
            icon: Icons.bookmark_outline_rounded,
            title: 'الانتقال الى العلامة',
            value: 1,
            onTap: () async {
              final prefs = await _getPrefs();
              final int? markedPage = prefs.getInt('quran_marked_page');
              _pageController.animateToPage(
                markedPage ?? currentPageNum.value,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 1000),
              );
            },
          ),
          mentuButton(
            icon: Icons.bookmark_added_rounded,
            title: 'وضع العلامة هنا',
            value: 2,
            onTap: () async {
              final prefs = await _getPrefs();
              await prefs.setInt('quran_marked_page', currentPageNum.value);
              Fluttertoast.showToast(
                msg: "تم حفظ العلامة في هذه الصفحة",
                backgroundColor: context.isDarkMode
                    ? ConstColors.goldAccent
                    : ConstColors.primaryTeal,
                gravity: ToastGravity.TOP,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            },
          ),
          mentuButton(
            icon: Icons.library_books_rounded,
            title: 'الصفحات',
            value: 3,
            onTap: () => _showPagesSheet(context),
          ),
          mentuButton(
            icon: Icons.view_list_rounded,
            title: 'الأجزاء',
            value: 4,
            onTap: () => _showJuzSheet(context),
          ),
          mentuButton(
            icon: Icons.settings,
            title: ConstTexts.settings,
            onTap: () => Navigator.pushNamed(context, ConstRoutes.settings),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  void _showPagesSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      showDragHandle: false,
      elevation: 0,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      (builder) => Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          color: ConstColors.primaryTeal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -4),
              blurRadius: 20,
            ),
          ],
          border: Border.all(color: ConstColors.primaryTeal, width: 1),
        ),
        child: ListView.separated(
          itemCount: 604,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final page = index;

            if (page == 0) {
              return ListTile(
                onTap: () => Navigator.pop(context),
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "إلغاء",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontFamily: 'cairo',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListTile(
              onTap: () {
                Navigator.pop(context);
                _pageController.animateToPage(
                  page,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 1200),
                );
              },
              titleAlignment: ListTileTitleAlignment.center,
              leading: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontFamily: 'cairo',
                    color: Colors.white,
                  ),
                  children: [
                    const TextSpan(text: "صـفـحــة\t\t"),
                    TextSpan(
                      text: page.toString().toArabicFormat(),
                      style: const TextStyle(
                        color: ConstColors.goldAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Text(
                "سورة ${getSurahNameArabic(_cachedPageData(page)[0]['surah'])}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontFamily: 'cairo',
                  color: ConstColors.goldAccent,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showJuzSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      showDragHandle: false,
      elevation: 0,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      (builder) => Container(
        clipBehavior: Clip.antiAlias,

        margin: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          color: ConstColors.primaryTeal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -4),
              blurRadius: 20,
            ),
          ],
          border: Border.all(color: ConstColors.primaryTeal, width: 1),
        ),
        child: ListView.separated(
          itemCount: _juzStartPages.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final page = index;

            if (page == 0) {
              return ListTile(
                onTap: () => Navigator.pop(context),
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "إلغاء",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontFamily: 'cairo',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListTile(
              onTap: () {
                Navigator.pop(context);
                _pageController.animateToPage(
                  _juzStartPages[page],
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 1200),
                );
              },
              titleAlignment: ListTileTitleAlignment.center,
              leading: CircleAvatar(
                backgroundColor: Colors.white12,
                foregroundColor: Colors.white,
                child: Text(
                  page.toString().toArabicFormat(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              title: Text(
                "الـجــزء ${getArabicOrdinal(page)}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontFamily: 'cairo',
                  color: Colors.white,
                ),
              ),
              trailing: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "صــ ${_juzStartPages[page]} ـــ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontFamily: 'cairo',
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

PopupMenuItem mentuButton({
  dynamic value,
  IconData? icon,
  String? title,
  VoidCallback? onTap,
}) {
  return PopupMenuItem(
    value: value,
    onTap: onTap,
    child: ListTile(
      leading: Icon(icon ?? Icons.add, color: Colors.white),
      title: Text(
        title?.toArabicFormat() ?? 'عنصر',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
