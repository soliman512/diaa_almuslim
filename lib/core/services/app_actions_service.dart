import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AppActionsService {
  // static List<String> fontSizes = ["صغير", "متوسط", "كبير"];
  // static String selectedSize = "متوسط";
  static String? globalCurrentVersoin;
  static String? globalAppSharingLink;
  static bool? globalCheckCurrentVersion;
  static Future<void> checkAppUpdate(BuildContext context) async {
    final url = Uri.parse(
      "https://api.github.com/repos/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases/latest",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String latestVersion = data['tag_name'];
        String downloadUrl =
            (data['assets'] != null && data['assets'].isNotEmpty)
            ? data['assets'][0]['browser_download_url']
            : data['html_url'];
        globalAppSharingLink = downloadUrl;
        latestVersion = latestVersion.replaceAll('v', '').trim();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;
        globalCurrentVersoin = currentVersion;
        globalCheckCurrentVersion = currentVersion == latestVersion;
        if (currentVersion != latestVersion) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              elevation: 30,
              title: Text(
                "تحديث جديد متاح",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ConstColors.mainColor,
                ),
              ),
              content: const Text(
                "يتوفر إصدار جديد من التطبيق \nيرجى التحديث الآن للحصول على آخر الميزات والتحسينات واستقرار الاتصال.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstColors.mainColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final Uri uri = Uri.parse(downloadUrl);
                    if (!await launchUrl(uri)) {
                      showErrorSnackBar(context, "هناك مشكلة ، حاول لاحقا");
                    }
                  },
                  child: const Text(
                    "تحديث الآن",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("لاحقاً", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception("Failed to load release info");
      }
    } catch (e) {
      debugPrint("Update Check Error: $e");
      if (context.mounted) {
        showErrorSnackBar(context, "تعذر التحقق من وجود تحديثات حالياً");
      }
    }
  }

  static Future<bool> hasNewUpdate() async {
    final url = Uri.parse(
      "https://api.github.com/repos/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases/latest",
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String latestVersion = data['tag_name'];

        globalAppSharingLink =
            (data['assets'] != null && data['assets'].isNotEmpty)
            ? data['assets'][0]['browser_download_url']
            : data['html_url'];

        latestVersion = latestVersion.replaceAll('v', '').trim();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version.trim();

        globalCurrentVersoin = currentVersion;

        if (currentVersion != latestVersion) {
          globalCheckCurrentVersion = false;
          return true;
        }
        debugPrint("--- [DEBUG] Server Version: '$latestVersion'");
        debugPrint("--- [DEBUG] Local Version: '$currentVersion'");
        globalCheckCurrentVersion = true;
        return false;
      }
    } catch (e) {
      debugPrint("Silent Update Check Error: $e");
    }
    return false;
  }

  static Future<void> fetchLatestReleaseInfo() async {
    final url = Uri.parse(
      "https://api.github.com/repos/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases/latest",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String latestVersion = data['tag_name'];
        String downloadUrl =
            (data['assets'] != null && data['assets'].isNotEmpty)
            ? data['assets'][0]['browser_download_url']
            : data['html_url'];

        globalAppSharingLink = downloadUrl;
        latestVersion = latestVersion.replaceAll('v', '').trim();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;
        globalCurrentVersoin = currentVersion;
        globalCheckCurrentVersion = currentVersion == latestVersion;
      }
    } catch (e) {
      debugPrint("Fetch Release Info Error: $e");
    }
  }

  static void openBasaerOnTiktok(BuildContext context) async {
    final url = Uri.parse(ConstTexts.basaerChannelUrl);
    if (!await launchUrl(url)) {
      showErrorSnackBar(context, "يبدو ان هنالك مشكلة ، حاول لاحقا");
    }
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: "تم",
          message: message,
          color: ConstColors.mainColor,
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
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: "فشل",
          message: message,
          color: ConstColors.mainColor,
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  // ====================== Send Email ======================
  static Future<void> sendEmail(BuildContext context, String message) async {
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': 'service_p6uvup9',
          'template_id': 'template_qtfr8c4',
          'user_id': 'W0ctHE3uYiqHe98Rl',
          'accessToken': 'fX2do_IcXEuk9kIMc512o',
          'template_params': {'message': message},
        }),
      );

      if (response.statusCode == 200) {
        print("تم إرسال الملاحظة بنجاح");
      } else {
        debugPrint("EmailJS Error: ${response.body}");
        print("هناك مشكلة في الاتصال");
      }
    } catch (e) {
      debugPrint("SendEmail Exception: $e");
      print("حدث خطأ: $e");
    }
  }

  // ====================== Send Rating ======================
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

      if (response.statusCode == 200) {
        print("شكرا لتقييمك لنا");
      } else {
        debugPrint("EmailJS Rating Error: ${response.body}");
        print("هناك مشكلة في الاتصال");
      }
    } catch (e) {
      debugPrint("SendRating Exception: $e");
      print("حدث خطأ أثناء إرسال التقييم");
    }
  }

  // ====================== Rating Dialog ======================
  static void showRatingDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const RateDialog());
  }

  // ====================== Rating Dialog ======================
  static void showNoteDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const NoteDialog());
  }

  // ====================== share app ======================

  static void shareApp(BuildContext context) async {
    if (globalAppSharingLink == null) {
      await fetchLatestReleaseInfo();
    }

    String fallbackLink =
        "https://github.com/${ConstTexts.githubUsername}/${ConstTexts.repoName}/releases";
    String finalLink = globalAppSharingLink ?? fallbackLink;

    String message =
        "【 ${ConstTexts.appName} 】\n\n"
        "تطبيق إسلامي — صدقة جارية، أذكار، وأدعية شاملة، بمميزات وبدون أي إعلانات لتوفير تجربة هادئة ومريحة.\n\n"
        "ساهم في نشر الخير فالدّال على الخير كفاعله، يمكنك تحميل التطبيق مباشرة عبر الرابط التالي:\n"
        "$finalLink\n\n"
        "ــــــــــــــــــــــــــــــــــــــــ\n"
        "تطبيق ${ConstTexts.appName} | ونيس المسلم اليومي";

    if (context.mounted) {
      await SharePlus.instance.share(ShareParams(text: message));
    }
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
          Text(
            "قم بتقييمنا لمساعدتنا في تطوير ${ConstTexts.appName}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
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
            backgroundColor: ConstColors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            try {
              final stars = userRating.toInt();
              Navigator.pop(context);
              AppActionsService.sendRating(context, stars);

              AppActionsService.showSuccessSnackBar(
                context,
                "تم ارسال تقييمك ، شكرا لتفاعلك",
              );
            } catch (e) {
              AppActionsService.showErrorSnackBar(context, e.toString());
            }
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
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[900],

        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            TextField(
              controller: noteController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              autocorrect: true,
              autofocus: true,
              cursorColor: ConstColors.mainColor,

              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "ما الملاحظة ؟ ...",
                hintStyle: TextStyle(color: Colors.black26),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? ConstColors.input
                    : Colors.grey[800],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!mounted) return;
                if (noteController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("الحقل فارغ !"),
                      backgroundColor: Colors.deepOrange,
                    ),
                  );
                } else {
                  try {
                    AppActionsService.sendEmail(context, noteController.text);
                    Navigator.pop(context);
                    noteController.clear();
                    AppActionsService.showSuccessSnackBar(
                      context,
                      "تم ارسال ملاحظتك عبر الأيميل ، شكرا لاهتمامك",
                    );
                  } catch (e) {
                    AppActionsService.showErrorSnackBar(context, e.toString());
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ConstColors.mainGradientColor,
                ),
                child: Image.asset(ConstIcons.confirmSendNotes, width: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
