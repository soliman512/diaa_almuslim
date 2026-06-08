import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

class AllahNameInfoBottomSheet extends StatelessWidget {
  final String name_param;
  final String meaning_param;
  final double fontSizeFactor;
  const AllahNameInfoBottomSheet({
    super.key,
    required this.name_param,
    required this.meaning_param,
    this.fontSizeFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(
        8,
        MediaQuery.sizeOf(context).height * 0.2,
        8,
        20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -10,
              right: -10,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  ConstIcons.islamicMandala,
                  width: 80,
                  height: 80,
                ),
              ),
            ),

            Positioned(
              bottom: -10,
              left: -10,
              child: Opacity(
                opacity: 0.08,

                child: Image.asset(
                  ConstIcons.islamicMandala,
                  width: 80,
                  height: 80,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: bottomPadding + 24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey[300],
                        size: 40,
                      ),
                    ),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(ConstIcons.allahNameTitleBox),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: name_param.split(' ').length > 1
                                ? 10.0
                                : 50.0,
                          ),
                          child: StrokeText(
                            text: name_param,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: name_param.split(' ').length > 1
                                  ? 30
                                  : 65,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'el-messiri',
                              shadows: const [
                                Shadow(
                                  color: Color.fromARGB(255, 0, 100, 67),
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            strokeColor: ConstColors.secondMainColor,
                            strokeWidth: 6,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40.0,
                        horizontal: 12,
                      ),
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(fontSizeFactor),
                        ),
                        child: Text(
                          meaning_param,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
