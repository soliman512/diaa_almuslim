import 'package:auto_size_text/auto_size_text.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String content;

  Header({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .08,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: .88,
            child: Image.asset(
              ConstIcons.homeHeader,
              fit: BoxFit.fill,
              width: double.infinity,
              color: context.isDarkMode
                  ? ConstColors.goldAccent
                  : ConstColors.primaryTeal,
            ),
          ),

          // Stack(
          //   children: [
          //     Container(
          //       clipBehavior: Clip.antiAlias,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(30),
          //       ),
          //       child: Stack(
          //         children: [
          //           Positioned(
          //             top: -12,
          //             right: -12,
          //             child: Image.asset(
          //               ConstIcons.ayahHeaderShape2,
          //               width: 60,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
              child: Center(
                child: AutoSizeText(
                  content,
                  // minFontSize: 16,
                  // maxFontSize: 24,
                  softWrap: true,
                  maxLines: null,
                  style: TextStyle(
                    fontFamily: "arsura",
                    // fontWeight: FontWeight.w600,
                    color: context.isDarkMode
                        ? ConstColors.goldAccent
                        : ConstColors.primaryTeal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
