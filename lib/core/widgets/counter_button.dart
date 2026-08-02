import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/utils/numbers_to_ar_format.dart';

class CounterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CounterButton({
    super.key,
    required this.onPressed,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          label.toArabicFormat(),
          key: ValueKey(label),
          style: TextStyle(
            color: context.isDarkMode
                ? ConstColors.goldAccent
                : ConstColors.primaryTeal,
            fontSize: 48,
            fontWeight: FontWeight.w600,
            // fontFamily: 'arsura',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
