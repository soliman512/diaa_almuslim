import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';

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
          side:const BorderSide(color: ConstColors.primaryTeal, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(ConstIcons.settings, width: 32),
            // Spacer(),
            AutoSizeText(
              ConstTexts.settings,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: ConstColors.primaryTeal),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
