import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AppActionsService {
  static String? globalCurrentVersion;
  static String? globalAppSharingLink;
  static bool? globalCheckCurrentVersion;

  static const String appName = "ضياء المسلم";

  // static Future<void> fetchLatestReleaseInfo() async {
  //   final url = Uri.parse(
  //     "https://api.github.com/repos/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases/latest",
  //   );
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       globalAppSharingLink =
  //           (data['assets'] != null && data['assets'].isNotEmpty)
  //           ? data['assets'][0]['browser_download_url']
  //           : data['html_url'];

  //       String latestVersion = data['tag_name']
  //           .toString()
  //           .replaceAll('v', '')
  //           .trim();

  //       PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //       globalCurrentVersion = "1.0.0";

  //       globalCheckCurrentVersion = (globalCurrentVersion == latestVersion);
  //     }
  //   } catch (e) {
  //     debugPrint("Fetch Release Info Error: $e");
  //   }
  // }

  // static Future<void> checkAppUpdate(BuildContext context) async {
  //   await fetchLatestReleaseInfo();

  //   if (!context.mounted) return;

  //   if (globalCheckCurrentVersion == false && globalAppSharingLink != null) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => AlertDialog(
  //         elevation: 30,
  //         title: const Text(
  //           "تحديث جديد متاح",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: ConstColors.mainColor,
  //           ),
  //         ),
  //         content: const Text(
  //           "يتوفر إصدار جديد من التطبيق \nيرجى التحديث الآن للحصول على آخر الميزات والتحسينات واستقرار الاتصال.",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 15, height: 1.5),
  //         ),
  //         actionsAlignment: MainAxisAlignment.center,
  //         actions: [
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: ConstColors.mainColor,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             onPressed: () async {
  //               Navigator.pop(context);
  //               final Uri uri = Uri.parse(globalAppSharingLink!);
  //               if (!await launchUrl(uri)) {
  //                 if (context.mounted)
  //                   showErrorSnackBar(context, "هناك مشكلة ، حاول لاحقا");
  //               }
  //             },
  //             child: const Text(
  //               "تحديث الآن",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("لاحقاً", style: TextStyle(color: Colors.grey)),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if (globalCheckCurrentVersion == null) {
  //     showErrorSnackBar(context, "تعذر التحقق من وجود تحديثات حالياً");
  //   }
  // }

  static void openBasaerOnTiktok(BuildContext context) async {
    final url = Uri.parse(ConstTexts.basaerChannelUrl);
    if (!await launchUrl(url)) {
      if (context.mounted) {
        showErrorSnackBar(context, "يبدو ان هنالك مشكلة ، حاول لاحقا");
      }
    }
  }

  static void shareApp(BuildContext context) async {
    String fallbackLink =
        "https://github.com/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases";
    String finalLink = globalAppSharingLink ?? fallbackLink;

    // استخدام الاسم الصحيح هنا
    String message =
        "【 $appName 】\n\n"
        "تطبيق إسلامي — صدقة جارية، أذكار، وأدعية شاملة، بمميزات وبدون أي إعلانات لتوفير تجربة هادئة ومريحة.\n\n"
        "ساهم في نشر الخير فالدّال على الخير كفاعله، يمكنك تحميل التطبيق مباشرة عبر الرابط التالي:\n"
        "$finalLink\n\n"
        "ــــــــــــــــــــــــــــــــــــــــ\n"
        "تطبيق $appName | ونيس المسلم اليومي";

    if (context.mounted) {
      await SharePlus.instance.share(ShareParams(text: message));
    }
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: "تم",
          message: message,
          color: ConstColors.primaryTeal,
          contentType: ContentType.success,
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: "فشل",
          message: message,
          color: ConstColors.primaryTeal,
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  static Future<void> sendEmail(BuildContext context, String message) async {
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': 'service_p6uvup9',
          'template_id': 'template_qtfr8c4',
          'user_id': 'W0ctHE3uYiqHe98Rl',
          'accessToken': 'fX2do_IcXEuk9kIMc512o',
          'template_params': {'message': message},
        }),
      );
      if (response.statusCode != 200) {
        debugPrint("EmailJS Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("SendEmail Exception: $e");
    }
  }

  static Future<void> sendRating(BuildContext context, int rate) async {
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': 'service_p6uvup9',
          'template_id': 'template_z1b9iw6',
          'user_id': 'W0ctHE3uYiqHe98Rl',
          'accessToken': 'fX2do_IcXEuk9kIMc512o',
          'template_params': {'stars': rate},
        }),
      );
      if (response.statusCode != 200) {
        debugPrint("EmailJS Rating Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("SendRating Exception: $e");
    }
  }

  // ====================== إظهار النوافذ المنبثقة ======================
  static void showRatingDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const RateDialog());
  }

  static void showNoteDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const NoteDialog());
  }
}



class RateDialog extends StatefulWidget {
  const RateDialog({super.key});
  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  double userRating = 3.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "قم بتقييمنا لمساعدتنا في تطوير ${AppActionsService.appName}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          RatingBar.builder(
            initialRating: userRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star_rounded,
              color: Color.fromARGB(255, 240, 139, 7),
            ),
            onRatingUpdate: (rating) {
              setState(() => userRating = rating);
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstColors.primaryTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final stars = userRating.toInt();
            Navigator.pop(context);
            AppActionsService.sendRating(context, stars);
            AppActionsService.showSuccessSnackBar(
              context,
              "تم ارسال تقييمك ، شكرا لتفاعلك",
            );
          },
          child: const Text(
            "إرسال التقييم",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({super.key});
  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: noteController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 3,
            autofocus: true,
            cursorColor: ConstColors.primaryTeal,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: "ما الملاحظة ؟ ...",
              hintStyle: const TextStyle(color: Colors.black26),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : ConstColors.input,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (noteController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("الحقل فارغ !"),
                    backgroundColor: Colors.deepOrange,
                  ),
                );
                return;
              }

              AppActionsService.sendEmail(context, noteController.text);
              Navigator.pop(context);
              AppActionsService.showSuccessSnackBar( 
                context,
                "تم ارسال ملاحظتك عبر الأيميل ، شكرا لاهتمامك",
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: ConstColors.mainGradientColor,
              ),
              child: Image.asset(ConstIcons.confirmSendNotes, width: 22),
            ),
          ),
        ],
      ),
    );
  }
}
