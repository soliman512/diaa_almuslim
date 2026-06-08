import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String content;
  Header({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(ConstIcons.homeHeader2),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Text(
            content,
            style: TextStyle(
              color: ConstColors.secondMainColor,
              fontFamily: "uthman",
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
