import 'dart:io';

import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/constants/textes.dart';
import 'package:diaa_almuslim/core/services/app_actions_service.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';

class NearestMosque extends StatefulWidget {
  final double fontSizeFactor;
  const NearestMosque({super.key, this.fontSizeFactor = 1.0});

  @override
  State<NearestMosque> createState() => _NearestMosqueState();
}

class _NearestMosqueState extends State<NearestMosque> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        pageName: ConstTexts.nearestMosque,
        showSettingsButton: true,
      ),
      body: SpecialBody(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            Image.asset(ConstIcons.nearestMosqueMain, fit: BoxFit.contain),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  MapHelper.searchNearby(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: context.isDarkMode
                      ? ConstColors.goldAccent
                      : ConstColors.primaryTeal,
                  foregroundColor: context.isDarkMode
                      ? ConstColors.primaryTeal
                      : ConstColors.goldAccent,
                ),

                child: Text(
                  "البحث عن ${ConstTexts.nearestMosque}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            infoSection(
              Icons.location_on_outlined,
              "تأكد من تفعيل خيرا تحديد الموقع",
              context,
            ),
            infoSection(
              Icons.info_outline_rounded,
              "سيؤدي هذا الى فتح الخريطة والخروج من التطبيق مؤقتا",
              context,
            ),

            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MapHelper {
  static Future<void> searchNearby(BuildContext context) async {
    const String placeCategory = 'mosque';
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse('geo:0,0?q=$placeCategory');
    } else if (Platform.isIOS) {
      uri = Uri.parse('maps://?q=$placeCategory');
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$placeCategory',
      );
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        final fallbackUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$placeCategory',
        );
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      AppActionsService.showErrorSnackBar(context, e.toString());
    }
  }
}

ListTile infoSection(IconData icon, String title, BuildContext context) {
  return ListTile(
    // contentPadding: EdgeInsets.only(left: 140),
    leading: Icon(
      icon,
      color: context.isDarkMode
          ? ConstColors.goldAccent
          : ConstColors.primaryTeal,
    ),
    title: Opacity(
      opacity: .6,
      child: Text(title, style: Theme.of(context).textTheme.bodySmall),
    ),
  );
}
