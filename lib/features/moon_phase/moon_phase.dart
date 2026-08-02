import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:hijri_date/moon_phases.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';

class MoonPhaseScreen extends StatefulWidget {
  MoonPhaseScreen({super.key, this.fontSizeFactor = 1.0});
  double? fontSizeFactor;
  @override
  State<MoonPhaseScreen> createState() => _MoonPhaseScreenState();
}

class _MoonPhaseScreenState extends State<MoonPhaseScreen> {
  String? todayHijriDate;
  void getHijriDate() {
    HijriDate.setLocal('ar');
    todayHijriDate = HijriDate.currentHijriDate.toString();
  }

  final moonInfo = HijriDate.now().getMoonPhase();
  @override
  void initState() {
    getHijriDate();
    // TODO: implement initState
    super.initState();
  }

  bool animateMoon = false;

  @override
  Widget build(BuildContext context) {
    // final testHijriDate = HijriDate()
    //   ..hYear = 1447
    //   ..hMonth = 1
    //   ..hDay = 17;
    // late MoonPhaseInfo moonInfo = testHijriDate.getMoonPhase();
    final hijriDate = HijriDate.fromDate(moonInfo.nextNewMoon);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: ConstTexts.moonPhase,
        showSettingsButton: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Color.fromARGB(255, 1, 7, 8),
                  Color.fromARGB(255, 1, 7, 8),
                  Color.fromARGB(255, 1, 7, 8),
                  Color.fromARGB(255, 4, 16, 19),
                  Color.fromARGB(255, 7, 28, 31),
                  // Color(0xFF28406B),
                  // Color.fromARGB(255, 128, 116, 107),
                  // Color(0xFFD47C5E),
                ],

                stops: [0.0, 0.28, 0.60, 0.80, 0.98],
              ),
            ),
          ),
          const Positioned.fill(
            child: StarryBackgroundWidget(
              starCount: 80,
              backgroundColor: Colors.transparent,
            ),
          ),
          // Positioned(
          //   bottom: -100,
          //   child: SizedBox(m
          //     width: MediaQuery.sizeOf(context).width,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Expanded(
          //           child: Image.asset(
          //             ConstIcons.palmsShadow,
          //             fit: BoxFit.contain,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),

                      opacity: animateMoon ? 0.05 : 1,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 40,
                        ),
                        child: AutoSizeText(
                          "وَالْقَمَــرَ قَدَّرْنَاهُ مَنَـازِلَ حَتَّـىٰ عَـادَ \nكَالْـعُرْجُـونِ الْقَدِيــمِ",
                          maxFontSize: 24,
                          minFontSize: 22,
                          style: TextStyle(
                            color: ConstColors.goldAccent,
                            fontFamily: 'arsura',
                            shadows: [
                              Shadow(
                                color: ConstColors.goldAccent,
                                blurRadius: 20,
                                offset: Offset.zero,
                              ),
                            ],
                            // fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          animateMoon = true;
                        });
                      },

                      onTapUp: (_) {
                        setState(() {
                          animateMoon = false;
                        });
                      },

                      onTapCancel: () {
                        setState(() {
                          animateMoon = false;
                        });
                      },
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: animateMoon ? .1 : 0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: animateMoon ? 1.2 : 1,
                          child: ImageMoonPhaseWidget(
                            moonInfo: moonInfo,
                            size: 200,
                            overlayColor: const Color.fromARGB(255, 1, 3, 8),
                            overlayOpacity: .92,
                            moonAssetPath: ConstIcons.realMoon,
                            moonScale: 1,
                            usePhaseBasedIllumination: false,
                            // assetPackage: null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedOpacity(
                      opacity: animateMoon ? 0.05 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          section(
                            todayHijriDate ?? "خطأ في جلب تاريخ اليوم هجريا",
                          ),

                          section(moonInfo.arabicName),
                          section(
                            "عمر القمر:  ${moonInfo.age.floor().toString().toArabicFormat()} الى ${moonInfo.age.ceil().toString().toArabicFormat()} أيام \nمنذ ولادة الهلال الجديد",
                          ),
                          section(
                            "ميلاد الهلال القادم: ${hijriDate.getDayName()}، \n${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear} هـ"
                                .toArabicFormat(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageMoonPhaseWidget extends StatelessWidget {
  final MoonPhaseInfo moonInfo;

  final double size;

  final Color overlayColor;

  final double overlayOpacity;

  final String moonAssetPath;

  final String? backgroundAssetPath;

  final BoxFit fit;

  final bool usePhaseBasedIllumination;

  final double moonScale;

  const ImageMoonPhaseWidget({
    super.key,

    required this.moonInfo,

    required this.moonAssetPath,

    this.size = 160,

    this.overlayColor = Colors.black,

    this.overlayOpacity = 0,

    this.backgroundAssetPath,

    this.fit = BoxFit.contain,

    this.usePhaseBasedIllumination = false,

    this.moonScale = 0.9,
  }) : assert(overlayOpacity >= 0 && overlayOpacity <= 1),

       assert(moonScale > 0 && moonScale <= 1);

  @override
  Widget build(BuildContext context) {
    final effectiveIllumination = usePhaseBasedIllumination
        ? _phaseToIllumination(moonInfo.phase)
        : moonInfo.illumination;

    return SizedBox(
      width: size + 40,

      height: size + 40,

      child: Stack(
        alignment: Alignment.center,

        children: [
          if (backgroundAssetPath != null)
            Image.asset(
              backgroundAssetPath!,

              width: size + 40,

              height: size + 40,

              fit: BoxFit.cover,
            ),

          Image.asset(
            moonAssetPath,

            width: size - 30,

            height: size - 30,

            fit: fit,
          ),

          if (overlayOpacity > 0)
            CustomPaint(
              size: Size(size - 30, size - 30),

              painter: _MoonPhaseOverlayPainter(
                phase: moonInfo.phase,

                illumination: effectiveIllumination,

                overlayColor: overlayColor,

                overlayOpacity: overlayOpacity,

                moonScale: moonScale,
              ),
            ),
        ],
      ),
    );
  }

  double _phaseToIllumination(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return 0;

      case MoonPhase.waxingCrescent:
        return 0.25;

      case MoonPhase.firstQuarter:
        return 0.5;

      case MoonPhase.waxingGibbous:
        return 0.75;

      case MoonPhase.fullMoon:
        return 1;

      case MoonPhase.waningGibbous:
        return 0.75;

      case MoonPhase.lastQuarter:
        return 0.5;

      case MoonPhase.waningCrescent:
        return 0.25;
    }
  }
}

class _MoonPhaseOverlayPainter extends CustomPainter {
  final MoonPhase phase;
  final double illumination;
  final Color overlayColor;
  final double overlayOpacity;
  final double moonScale;

  const _MoonPhaseOverlayPainter({
    required this.phase,
    required this.illumination,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.moonScale,
  });

  bool get _isWaxing {
    return phase == MoonPhase.waxingCrescent ||
        phase == MoonPhase.firstQuarter ||
        phase == MoonPhase.waxingGibbous;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final k = illumination.clamp(0.0, 1.0);
    if (overlayOpacity <= 0) return;

    if (k <= 0) {
      _drawFullShadow(canvas, size);
      return;
    }

    if (k >= 1) {
      return;
    }

    _drawCurvedShadow(canvas, size, k);
  }

  void _drawFullShadow(Canvas canvas, Size size) {
    final r = size.width / 2 * moonScale;
    final center = Offset(size.width / 2, size.height / 2);
    final shadowPaint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r, shadowPaint);
  }

  void _drawCurvedShadow(Canvas canvas, Size size, double k) {
    final r = size.width / 2 * moonScale;
    final center = Offset(size.width / 2, size.height / 2);

    final moonCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r));
    canvas.clipPath(moonCirclePath);

    final shadowPaint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;

    final ellipseWidth = 2 * r * (1 - 2 * k).abs();
    final ellipseRect = Rect.fromCenter(
      center: center,
      width: ellipseWidth,
      height: 2 * r,
    );
    final ellipsePath = Path()..addOval(ellipseRect);

    final leftHalfRect = Rect.fromLTRB(
      center.dx - r,
      center.dy - r,
      center.dx,
      center.dy + r,
    );
    final leftHalfPath = Path()..addRect(leftHalfRect);

    final rightHalfRect = Rect.fromLTRB(
      center.dx,
      center.dy - r,
      center.dx + r,
      center.dy + r,
    );
    final rightHalfPath = Path()..addRect(rightHalfRect);

    Path finalShadowPath;

    if (_isWaxing) {
      if (k <= 0.5) {
        finalShadowPath = Path.combine(
          PathOperation.union,
          leftHalfPath,
          ellipsePath,
        );
      } else {
        finalShadowPath = Path.combine(
          PathOperation.difference,
          leftHalfPath,
          ellipsePath,
        );
      }
    } else {
      if (k <= 0.5) {
        finalShadowPath = Path.combine(
          PathOperation.union,
          rightHalfPath,
          ellipsePath,
        );
      } else {
        finalShadowPath = Path.combine(
          PathOperation.difference,
          rightHalfPath,
          ellipsePath,
        );
      }
    }

    canvas.drawPath(finalShadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _MoonPhaseOverlayPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.illumination != illumination ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.overlayOpacity != overlayOpacity ||
        oldDelegate.moonScale != moonScale;
  }
}

Widget section(String content) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: ConstColors.goldAccent, width: .7),
    ),
    child: Text(
      content,
      style: const TextStyle(color: ConstColors.goldAccent),
      textAlign: TextAlign.center,
    ),
  );
}

class StarryBackgroundWidget extends StatelessWidget {
  final int starCount;

  final Color backgroundColor;

  const StarryBackgroundWidget({
    super.key,
    this.starCount = 150,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: CustomPaint(
        size: Size.infinite,
        painter: _StarPainter(starCount: starCount),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final int starCount;

  _StarPainter({required this.starCount});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (int i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      final radius = random.nextDouble() * 1.5 + 0.5;

      final opacity = random.nextDouble() * 0.8 + 0.2;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.starCount != starCount;
  }
}
