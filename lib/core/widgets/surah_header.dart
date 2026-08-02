import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';


class SurahHeader extends StatelessWidget {
  var e;
  var jsonData;

  SurahHeader({super.key, required this.e, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              ConstIcons.surahHeader,
              width: MediaQuery.of(context).size.width,
              color: context.isDarkMode ? ConstColors.goldAccent : ConstColors.primaryTeal,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: e["surah"].toString(),
            
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "arsura",
                    fontSize: 28,
                    color:context.isDarkMode ? ConstColors.goldAccent : ConstColors.primaryTeal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
