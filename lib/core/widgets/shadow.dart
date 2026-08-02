import 'package:flutter/material.dart';


class AdaptiveShadow {
 static BoxShadow adaptiveShadow(BuildContext context) {
  return BoxShadow(
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white24
        : Colors.black12,
    blurRadius: 20,
    offset: const Offset(0, 0),
  );
}

}