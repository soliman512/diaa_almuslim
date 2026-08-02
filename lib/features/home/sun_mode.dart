import 'package:auto_size_text/auto_size_text.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunModeWidget extends StatelessWidget {
  final bool isSunRise;
  final DateTime? time;

  const SunModeWidget({super.key, required this.isSunRise, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isSunRise ? Alignment.topRight : Alignment.bottomLeft,
          end: isSunRise ? Alignment.bottomLeft : Alignment.topRight,
          colors: const [
            ConstColors.goldAccent,
            Color.fromARGB(255, 218, 218, 218),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(isSunRise ? -2 : 2, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            bottom: isSunRise ? null : -16,
            left: isSunRise ? null : -8,
            top: isSunRise ? -16 : null,
            right: isSunRise ? -8 : null,
            child: Image.asset(ConstIcons.sunFull, width: 40, fit: BoxFit.fill),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: time != null
                ? SizedBox(
                    width: double.infinity,
                    child: AutoSizeText(
                      isSunRise
                          ? "الشروق: ${DateFormat.jm('ar').format(time!)}"
                                .toArabicFormat()
                          : "الغروب: ${DateFormat.jm('ar').format(time!)}"
                                .toArabicFormat(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  )
                : const Center(child: AutoSizeText("يتم التحميل ...")),
          ),
        ],
      ),
    );
  }
}
