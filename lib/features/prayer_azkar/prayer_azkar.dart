import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/services/app_actions_service.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/progress.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:diaa_almuslim/features/prayer_azkar/prayer_azkar_logic.dart';

extension DarkModeX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

class PrayerAzkar extends StatefulWidget {
  const PrayerAzkar({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;

  @override
  State<PrayerAzkar> createState() => _PrayerAzkarState();
}

class _PrayerAzkarState extends State<PrayerAzkar> {
  final CardSwiperController _controller = CardSwiperController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  List _azkar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAzkar();
  }

  @override
  void dispose() {
    _controller.dispose();
    _counter.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  Future<void> _loadAzkar() async {
    try {
      _azkar = await PrayerAzkarLogic.getPrayerAzkar();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      AppActionsService.showErrorSnackBar(context, e.toString());
    }
  }

  bool _onSwipe(
    int previousIndex,
    int? nextIndex,
    CardSwiperDirection direction,
  ) {
    _currentIndex.value = nextIndex ?? 0;
    _counter.value = 0;
    return true;
  }

  bool _onUndo(int? previousIndex, int index, CardSwiperDirection direction) {
    _currentIndex.value = index;
    _counter.value = 0;
    return true;
  }

  void _onEnd() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColors.primaryTeal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => _buildCompletionBottomSheet(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: ConstTexts.prayerAzkar,
        showSettingsButton: true,
      ),
      body: SpecialBody(
        body: _isLoading
            ? const Porgress()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: double.infinity,
                    child: CardSwiper(
                      controller: _controller,
                      cardsCount: _azkar.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      onEnd: _onEnd,
                      allowedSwipeDirection: const AllowedSwipeDirection.only(
                        right: true,
                        left: true,
                      ),
                      backCardOffset: const Offset(0, -30),
                      numberOfCardsDisplayed: 3,
                      isLoop: false,
                      padding: EdgeInsets.zero,
                      cardBuilder:
                          (
                            context,
                            index,
                            horizontalThreshold,
                            verticalThreshold,
                          ) {
                            return _buildAzkarCard(
                              context,
                              _azkar[index],
                              index,
                            );
                          },
                    ),
                  ),
                  const Spacer(),
                  _buildFooterActionBar(context),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildAzkarCard(
    BuildContext context,
    Map<String, dynamic> zikr,
    int index,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: ConstColors.tealGradient,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: Colors.white30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  (index + 1).toString().toArabicFormat(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Colors.white30)),
            ],
          ),
          Expanded(
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(widget.fontSizeFactor)),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        zikr["content"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'arsura',
                          fontSize: 22,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _buildRepeatBadge(context, zikr["repeat"]),
                      if (zikr["time"] != null) ...[
                        const SizedBox(height: 12),
                        _buildTimeBadge(context, zikr["time"]),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActionBar(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_counter, _currentIndex]),
      builder: (context, _) {
        final int currentRepeat =
            (_azkar.isNotEmpty && _currentIndex.value < _azkar.length)
            ? (_azkar[_currentIndex.value]["repeat"] ?? 1)
            : 1;
        final bool isCounterEqualRepeat = _counter.value >= currentRepeat;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: ConstColors.primaryTeal,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 30,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_counter.value + 1 >= currentRepeat) {
                        _counter.value = currentRepeat;
                        await Future.delayed(const Duration(milliseconds: 150));
                        _controller.swipe(CardSwiperDirection.right);
                      } else {
                        _counter.value++;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCounterEqualRepeat
                          ? ConstColors.goldAccent.withValues(alpha: .2)
                          : Colors.transparent,
                      side: const BorderSide(color: ConstColors.goldAccent),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                      child: Text(
                        _counter.value.toString().toArabicFormat(),
                        key: ValueKey<int>(_counter.value),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildCircularActionButton(
                icon: Icons.restart_alt_rounded,
                onTap: () => _controller.undo(),
                backgroundColor: ConstColors.goldAccent,
                iconColor: ConstColors.primaryTeal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    required Color iconColor,
    bool isGradient = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGradient ? null : backgroundColor,
        gradient: isGradient ? ConstColors.tealGradient : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatBadge(BuildContext context, dynamic repeat) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        _getRepeatText(repeat),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeBadge(BuildContext context, String time) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: ConstColors.goldAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: ConstColors.goldAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCompletionBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "تقبل الله صلاتك\nثبتك الله وزادك",
            style: TextStyle(
              color: ConstColors.goldAccent,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColors.goldAccent,
                foregroundColor: ConstColors.primaryTeal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "آمين",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRepeatText(dynamic repeat) {
    final int r = (repeat is int)
        ? repeat
        : int.tryParse(repeat.toString()) ?? 0;
    final String countWord = _getCountWord(r);
    return "الـتــكـرار: ${Tafqeet.convert(r.toString())} $countWord (${r.toString().toArabicFormat()})";
  }

  String _getCountWord(int r) {
    if (r == 0) return "مرة";
    final int mod = r % 100;
    if ((r >= 3 && r <= 10) || (r > 100 && mod >= 3 && mod <= 10)) {
      return "مرات";
    }
    return "مرة";
  }
}
