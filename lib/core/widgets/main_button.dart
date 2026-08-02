import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';

// class MainButton extends StatelessWidget {
//   final String title;
//   final String image;
//   final String pageRouteName;
//   final double fontSize;
//   const MainButton({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.pageRouteName,
//     this.fontSize = 22,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.pushNamed(context, pageRouteName);
//         },
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(0),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//         ),
//         child: Row(
//           spacing: 8,
//           children: [
//             Expanded(
//               child: Container(
//                 height: double.infinity,
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   border: Border.all(color: ConstColors.mainColor, width: 1),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                     topRight: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Image.asset(image),
//               ),
//             ),
//             Expanded(
//               flex: (280 / 71).toInt(),

//               child: Container(
//                 // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
//                 clipBehavior: Clip.antiAlias,
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   // border: Border.all(color: ConstColors.mainColor, width: 1),
//                   gradient: ConstColors.mainGradientColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     bottomLeft: Radius.circular(30),
//                     topRight: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                 ),

//                 child: Stack(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   alignment: Alignment.center,
//                   children: [
//                     AutoSizeText(
//                       title,
//                       style: Theme.of(
//                         context,
//                       ).textTheme.titleMedium!.copyWith(fontSize: fontSize),
//                     ),
//                     Positioned(
//                       left: 0,
//                       bottom: 0,
//                       child: Image.asset(ConstIcons.leaf, width: 60),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SecondaryButton extends StatelessWidget {
//   final String title;
//   final String image;
//   final String pageRouteName;
//   const SecondaryButton({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.pageRouteName,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, pageRouteName);
//       },

//       child: Container(
//         height: 60,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           gradient: ConstColors.mainGradientColor,
//         ),
//         child: Row(
//           spacing: 6,
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white38,
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Image.asset(image, fit: BoxFit.contain),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.tight,
//               child: AutoSizeText(
//                 title,
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//                 minFontSize: 12,
//                 maxFontSize: 22,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MainButtonVTwo extends StatelessWidget {
  final String routeName, icon, title;
  final String? descrption;
  final bool? noRotate;
  const MainButtonVTwo({
    super.key,
    required this.title,
    required this.icon,
    required this.routeName,
    this.descrption,
    this.noRotate = false,
  });

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          gradient: ConstColors.mainGradientColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            const Positioned(
              bottom: -12,
              top: -12,
              right: -12,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(19, 255, 255, 255),
                radius: 60,
              ),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: Image.asset(
                ConstIcons.mainButtonShape,
                color: Colors.white12,
                width: 80,
                height: 80,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Transform.rotate(
                    angle: noRotate == true ? 0 : .4,
                    child: Image.asset(icon, width: 60),
                  ),
                  const SizedBox(width: 8),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      AutoSizeText(
                        title,
                        maxFontSize: 22,
                        minFontSize: 18,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (descrption != null)
                        Text(
                          descrption ?? 'aa',
                          style: const TextStyle(
                            color: Color.fromARGB(136, 255, 255, 255),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButtonVTwo extends StatelessWidget {
  final String routeName, icon, title;
  final bool? noRotate;
  const SecondaryButtonVTwo({
    super.key,
    required this.title,
    required this.icon,
    required this.routeName,
    this.noRotate = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          gradient: ConstColors.tealGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            // top shape
            Positioned(
              top: -10,
              // left: 0,
              right: 0,
              child: Image.asset(
                ConstIcons.mainButtonShape,
                color: Colors.white12,
                width: 40,
                height: 40,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints.expand(),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: ConstColors.specialDarkBackground.withOpacity(.3),
                    // shape: BoxShape.circle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: AutoSizeText(
                    title,
                    // maxFontSize: ,
                    style: const TextStyle(
                      color: Colors.white,
                      // fontSize: 22,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        // Shadow(
                        //   color: const Color.fromARGB(
                        //     139,
                        //     255,
                        //     255,
                        //     255,
                        //   ),
                        //   blurRadius: 4,
                        //   // offset: Offset(0, 0),
                        // ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 2,
              bottom: 2,
              top: 2,
              child: Transform.rotate(
                angle: noRotate == true ? 0 : .3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(icon, width: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
