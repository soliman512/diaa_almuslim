import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:flutter/material.dart';

class Basmallah extends StatelessWidget {
  int index;
  bool isDark;
  Basmallah({super.key, required this.index, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Padding(
        padding: EdgeInsets.only(
          left: (screenSize.width * .2),
          right: (screenSize.width * .2),
          top: 8,
          bottom: 2,
        ),
        child: Image.asset(
          ConstIcons.blackBasmallah,
          color:isDark ? Colors.white:Colors.black,
          width: MediaQuery.of(context).size.width * .4,
        ),
      ),
    );
  }
}
