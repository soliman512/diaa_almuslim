import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

class MainButton extends StatelessWidget {
  final String title;
  final String image;
  final String pageRouteName;
  final double fontSize;
  const MainButton({
    super.key,
    required this.title,
    required this.image,
    required this.pageRouteName,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, pageRouteName);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: ConstColors.mainColor, width: 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Image.asset(image),
              ),
            ),
            Expanded(
              flex: (280 / 71).toInt(),

              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                clipBehavior: Clip.antiAlias,
                height: double.infinity,
                decoration: BoxDecoration(
                  // border: Border.all(color: ConstColors.mainColor, width: 1),
                  gradient: ConstColors.mainGradientColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),

                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  alignment: Alignment.center,
                  children: [
                    AutoSizeText(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontSize: fontSize),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Image.asset(ConstIcons.leaf, width: 60),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondMainButton extends StatelessWidget {
  final String title;
  final String image;
  final String pageRouteName;
  const SecondMainButton({
    super.key,
    required this.title,
    required this.image,
    required this.pageRouteName,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, pageRouteName);
      },

      child: Container(
        height: 60,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: ConstColors.mainGradientColor,
        ),
        child: Row(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white38,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: AutoSizeText(
                title,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                minFontSize: 12,
                maxFontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
