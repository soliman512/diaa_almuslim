import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 20), () {
      setState(() {
        _isVisible = true;
      });
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, "/home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // alignment: Alignment.center,
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(gradient: ConstColors.mainGradientColor),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 2000),
              opacity: _isVisible ? 1 : 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  AnimatedRotation(
                    turns: _isVisible ? 0 : .12,
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOut,
                    child: Image.asset(ConstIcons.appLogo, width: 60),
                  ),
                  Image.asset(ConstIcons.splashLogoName, width: 120),
                  // Text(
                  //   ConstTexts.appName,
                  //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //     color: Colors.white,
                  //     shadows: [
                  //       Shadow(
                  //         color: Colors.black38,
                  //         offset: Offset(0, 8),
                  //         blurRadius: 8,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeOut,
            bottom: _isVisible ? -40 : -200,
            right: _isVisible ? -40 : -200,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 1500),
              opacity: _isVisible ? 1 : 0.2,
              child: Image.asset(ConstIcons.splashScreenBackgroundBottomShape),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeOut,
            top: _isVisible ? -40 : -200,
            left: _isVisible ? -40 : -200,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 1500),
              opacity: _isVisible ? 0.5 : 0.2,
              child: Image.asset(
                ConstIcons.splashScreenBackgroundTopShape,
                width: 240,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
