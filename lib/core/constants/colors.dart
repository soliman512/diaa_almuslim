import 'package:flutter/material.dart';

class ConstColors {
  // static const LinearGradient mainGradientColor =  LinearGradient(
  //   begin: Alignment.centerRight,
  //   end: Alignment.centerLeft,
  //   colors: [Color(0xff0F2442), Color(0xff1B426E), Color(0xFF29609E)],
  // );
  static const LinearGradient mainGradientColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0F3943), Color(0xFF1E656B)],
  );
  static const LinearGradient lightenBlueGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xff1B426E), Color(0xFF29609E), Color(0xFF3E7DC5)],
  );
  static const LinearGradient specialLightBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 224, 243, 255),
      Color.fromARGB(255, 251, 245, 243),
      Color.fromARGB(255, 251, 245, 243),
      Color(0xFFFBF5F3),
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  );
  static const LinearGradient specialDarkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 5, 12, 22),
      Color.fromARGB(255, 3, 7, 12),
      Color(0xFF0D0D0E),
    ],
  );
  static const Color specialLightAppbarBackground = Color.fromARGB(
    255,
    224,
    243,
    255,
  );
  static const Color specialDarkAppbarBackground = Color.fromARGB(
    255,
    5,
    12,
    22,
  );

  static const Color mainColor = Color(0xff1B426E);
  static const Color deepYellow = Color(0xffFFAA00);
  static const Color input = Color(0xffD8D8D8);
  static const Color secondMainColor = Color(0xffe7d091);
  static const Color lightMode = Color(0xFFFBF5F3);
  static const Color darkMode = Color(0xFF0D0D0E);
  static const Color deepOrange = Color(0xFFFF5722);

  static const Color primaryTeal = Color(0xFF164E56);
  static const Color goldAccent = Color(0xFFDFAC6B);
  static const Color darkBackAppBar = Color(0xff060606);
  static const Color lightBackAppBar = Color(0xfff1debf);
  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0F3943), Color(0xFF1E656B)],
  );
}
