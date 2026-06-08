import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/utils/numbers_to_ar_format.dart';

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
        side: BorderSide(color: ConstColors.mainColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      label: Text(
        label.toArabicFormat(),
        style: TextStyle(
          color: ConstColors.mainColor,
          fontSize: 42,
          fontFamily: 'cairo',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
