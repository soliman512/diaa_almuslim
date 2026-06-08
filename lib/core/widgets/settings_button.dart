import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
    
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/settings");
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ConstColors.mainColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ConstIcons.settings, width: 32),
            Spacer(),
            AutoSizeText(
              ConstTexts.settings,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: ConstColors.mainColor),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
