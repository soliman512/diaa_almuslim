// import 'package:flutter/material.dart';
// import 'package:diaa_almuslim/core/constants/colors.dart';
// import 'package:diaa_almuslim/core/constants/icons.dart';
// import 'package:diaa_almuslim/core/constants/textes.dart';
// import 'package:diaa_almuslim/core/services/app_actions_service.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       clipBehavior: Clip.antiAlias,
//       margin: const EdgeInsets.only(top: 40, bottom: 20, left: 93),
//       decoration: BoxDecoration(
//         gradient: ConstColors.mainGradientColor,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(40),
//           bottomLeft: Radius.circular(40),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Image.asset(ConstIcons.drawerBackgroundBottomShape),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Opacity(
//               opacity: 0.2,
//               child: Image.asset(ConstIcons.splashScreenBackgroundTopShape),
//             ),
//           ),

//           Column(
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 50),
//                     // Image.asset(ConstIcons.splashLogoName, width: 100),
//                     // const SizedBox(height: 10),
//                     // Text(
//                     //   ConstTexts.appName,
//                     //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                     //     color: Colors.white,
//                     //     fontSize: 22,
//                     //     shadows: const [
//                     //       Shadow(
//                     //         color: Colors.black38,
//                     //         offset: Offset(0, 4),
//                     //         blurRadius: 6,
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 60),

//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   children: [
//                     _buildDrawerItem(
//                       context,
//                       icon: ConstIcons.settings,
//                       title: ConstTexts.settings,
//                       onTap: () {
//                         Navigator.pushNamed(context, "/settings");
//                       },
//                     ),

//                     const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 12,
//                       ),
//                       child: Divider(color: Colors.white24, thickness: 1),
//                     ),

//                     _buildDrawerItem(
//                       context,
//                       icon: ConstIcons.rateUs,
//                       title: "تقييم التطبيق",
//                       onTap: () {
//                         AppActionsService.showRatingDialog(context);
//                       },
//                     ),
//                     _buildDrawerItem(
//                       context,
//                       icon: ConstIcons.sendNotes,
//                       title: "أرسل مقترحاً",
//                       onTap: () {
//                         AppActionsService.showNoteDialog(context);
//                       },
//                     ),
//                     _buildDrawerItem(
//                       context,
//                       icon: ConstIcons.share,
//                       title: "مشاركة التطبيق",
//                       onTap: () {
//                         AppActionsService.shareApp(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: ConstColors.secondMainColor,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                         "الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ \nأَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                           color: Colors.black,
//                           fontSize: 12,
//                           height: 1.6,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Text(
//                       "الإصدار\t${AppActionsService.globalCurrentVersion}",
//                       style: const TextStyle(
//                         color: Colors.white38,
//                         fontSize: 12,
//                         fontFamily: 'exo',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // دالة مساعدة (Helper Widget) لبناء عناصر القائمة بشكل موحد، نظيف، وبلمسة زجاجية خفيفة
//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required String icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: ListTile(
//         onTap: onTap,
//         dense: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         hoverColor: Colors.white10,
//         leading: Image.asset(icon, width: 24, color: Colors.white),
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
