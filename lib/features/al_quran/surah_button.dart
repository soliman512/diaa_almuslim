import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';
import 'package:flutter/material.dart';

enum SurahType { madinah, makkah }

// ignore: must_be_immutable
class SurahButton extends StatelessWidget {
  final String surhaName;
  final VoidCallback? onTap;
  int surahId;
  SurahType surahType;
  final String versesCount;

  SurahButton({
    super.key,
    required this.surhaName,
    required this.surahId,
    this.onTap,
    required this.surahType,
    required this.versesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            gradient: ConstColors.mainGradientColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              const Positioned(
                bottom: -12,
                top: -12,
                right: -12,
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(19, 255, 255, 255),
                  radius: 60,
                ),
              ),
              Positioned(
                bottom: -10,
                left: -10,
                child: Image.asset(
                  ConstIcons.mainButtonShape,
                  color: ConstColors.primaryTeal,
                  width: 80,
                  height: 80,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          ConstIcons.surahNumBox,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          color: ConstColors.primaryTeal,
                        ),
                        Text(
                          surahId.toString().toArabicFormat(),
                          style: const TextStyle(
                            color: ConstColors.goldAccent,
                            fontSize: 22,
                            fontFamily: 'arsura',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 8),
                    const Spacer(),
                    // surah name & surah verses count
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 2,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "$surahId",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "arsura",
                            ),
                          ),
                        ),

                        Text(
                          versesCount.toArabicFormat(),
                          style: const TextStyle(
                            color: Color.fromARGB(136, 255, 255, 255),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Image.asset(
                      surahType == SurahType.makkah
                          ? ConstIcons.makkah
                          : ConstIcons.madinah,
                      fit: BoxFit.contain,
                      width: 36,
                      height: 36,
                      color: ConstColors.goldAccent,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
