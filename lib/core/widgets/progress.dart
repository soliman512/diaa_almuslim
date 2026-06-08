import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';

class Porgress extends StatelessWidget {
  const Porgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * .3,
        height: MediaQuery.sizeOf(context).width * .3,
        child: CircularProgressIndicator(
          color: ConstColors.mainColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
