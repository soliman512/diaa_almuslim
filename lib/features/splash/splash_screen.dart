import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _isVisible = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, "/home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool context.isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // _isVisible = true;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(ConstIcons.realMosque, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 13, 46, 51).withValues(alpha: .94),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            color: _isVisible
                ? Colors.transparent
                : context.isDarkMode
                ? const Color(0xff0D0D0E)
                : const Color(0xffFBF5F3),
          ),

          Center(
            child: SizedBox(
              width: screenWidth * .8,
              child: Image.asset(
                ConstIcons.splashLightLogo,
                color: ConstColors.goldAccent,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),

            bottom: _isVisible ? 18 : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),

              opacity: _isVisible ? 1 : 0,
              child: Text(
                "${ConstTexts.appName} المـسـلــم",
                style:const TextStyle(
                  color: ConstColors.goldAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: screenHeight * .05),

          // Container(
          //   // alignment: Alignment.center,
          //   width: double.infinity,
          //   height: MediaQuery.sizeOf(context).height,
          //   decoration: BoxDecoration(gradient: ConstColors.mainGradientColor),
          //   child: SizedBox(

          //     child: Image.asset(ConstIcons.appLogo, width: 60)),
          // ),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 1500),
          //   curve: Curves.easeOut,
          //   bottom: _isVisible ? -40 : -200,
          //   right: _isVisible ? -40 : -200,
          //   child: AnimatedOpacity(
          //     duration: Duration(milliseconds: 1500),
          //     opacity: _isVisible ? 1 : 0.2,
          //     child: Image.asset(ConstIcons.splashScreenBackgroundBottomShape),
          //   ),
          // ),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 1500),
          //   curve: Curves.easeOut,
          //   top: _isVisible ? -40 : -200,
          //   left: _isVisible ? -40 : -200,
          //   child: AnimatedOpacity(
          //     duration: Duration(milliseconds: 1500),
          //     opacity: _isVisible ? 0.5 : 0.2,
          //     child: Image.asset(
          //       ConstIcons.splashScreenBackgroundTopShape,
          //       width: 240,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
