import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';

class Porgress extends StatelessWidget {
  const Porgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: context.screenSize.width * .3,
        height: context.screenSize.width * .3,
        child: CircularProgressIndicator(
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
