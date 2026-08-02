import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:diaa_almuslim/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';
import 'package:diaa_almuslim/core/services/app_actions_service.dart';
import 'package:diaa_almuslim/core/widgets/appbar.dart';
import 'package:diaa_almuslim/core/widgets/special_body.dart';

class Settings extends StatefulWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onThemeChanged;
  final String currentFontSize;
  final Function(String) onFontSizeChanged;
  const Settings({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.currentFontSize,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> fontSizes = ["صغير", "متوسط", "كبير"];
  String selectedSize = "متوسط";
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = widget.currentMode == ThemeMode.dark;

    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppbar(pageName: "الإعدادات", showSettingsButton: false),
      body: SizedBox(
        height: double.infinity,
        child: SpecialBody(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 80),
                //dark mode
                _buildSettingTile(
                  isDark: isDark,
                  iconPath: ConstIcons.darkMode,
                  title: "الوضع المظلم",
                  subtitle: isDark ? "مفعّل" : "ملغى",
                  trailing: Switch.adaptive(
                    activeThumbColor: ConstColors.goldAccent,
                    value: isDark,
                    onChanged: (bool value) {
                      widget.onThemeChanged(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ),
                //font size
                _buildSettingTile(
                  isDark: isDark,
                  iconPath: ConstIcons.textSize,
                  title: "حجم خط الذكر",
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.currentFontSize,
                      dropdownColor: ConstColors.primaryTeal,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ConstColors.goldAccent,
                      ),
                      items: fontSizes
                          .map(
                            (size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.onFontSizeChanged(newValue!);
                        });
                      },
                    ),
                  ),
                ),
                //notes
                _buildSettingTile(
                  isDark: isDark,
                  iconPath: ConstIcons.rateUs,
                  title: "قم بتقييمنا",
                  trailing: FilledButton(
                    onPressed: () {
                      AppActionsService.showRatingDialog(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: ConstColors.goldAccent,
                      foregroundColor: ConstColors.primaryTeal,

                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 36,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "تقييم",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                //rate us
                _buildSettingTile(
                  isDark: isDark,
                  iconPath: ConstIcons.sendNotes,
                  title: "إرسال ملاحظة",
                  subtitle: "هل هناك مشكلة؟\n أو معلومة خاطئة؟",
                  trailing: FilledButton(
                    onPressed: () {
                      AppActionsService.showNoteDialog(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: ConstColors.goldAccent,
                      foregroundColor: ConstColors.primaryTeal,

                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "كتابة ملاحظة",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                // open basaer page on tiktok
                _buildSettingTile(
                  onTap: () {
                    AppActionsService.openBasaerOnTiktok(context);
                  },
                  isDark: isDark,
                  title: " قناة بصائر على الـ TIKTOK ",
                  iconPath: ConstIcons.tiktok,
                  subtitle: "قناة ناشئة متخصصة في المحتوى الإسلامي",
                ),

                // share
                _buildSettingTile(
                  onTap: () {
                    AppActionsService.shareApp(context);
                  },
                  isDark: isDark,
                  title: "مشاركة التطبيق",
                  iconPath: ConstIcons.share,
                  subtitle: "شاركني الاجر فالدّال على الخير كفاعله",
                ),

                //version
                // _buildSettingTile(
                //   isDark: isDark,
                //   title: "الإصدار: ${AppActionsService.globalCurrentVersion}",
                //   trailing: AppActionsService.globalCheckCurrentVersion ?? true
                //       ? const Text(
                //           "أنت على احدث إصدار",
                //           style: TextStyle(color: ConstColors.goldAccent),
                //         )
                //       : FilledButton(
                //           onPressed: () async {
                //             await AppActionsService.checkAppUpdate(context);
                //           },
                //           style: FilledButton.styleFrom(
                //             backgroundColor: ConstColors.goldAccent,
                //             foregroundColor: ConstColors.primaryTeal,

                //             padding: const EdgeInsets.symmetric(
                //               vertical: 6,
                //               horizontal: 18,
                //             ),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           child: const Text(
                //             "تحديث الإصدار",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(fontSize: 12),
                //           ),
                //         ),
                // ),
                const SizedBox(height: 40),

                Text(
                  "لا تنسونا من صالح دعائكم",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.isDarkMode
                        ? ConstColors.goldAccent
                        : ConstColors.primaryTeal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Opacity(
                //   opacity: 0.6,
                //   child: RichText(
                //     textAlign: TextAlign.center,
                //     text: TextSpan(
                //       style: Theme.of(context).textTheme.bodyMedium,
                //       children: [
                //         TextSpan(
                //           text: "هناك مشكلة؟ ",
                //           style: TextStyle(color: Colors.redAccent),
                //         ),
                //         TextSpan(text: "يسعدنا تواصلكم معنا عبر\n"),
                //         TextSpan(
                //           text: "\"إرسال ملاحظة\"",
                //           style: TextStyle(color: ConstColors.mainColor),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                //   Opacity(
                //     opacity: 0.6,
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 16,
                //         vertical: 16,
                //       ),
                //       child: Text(
                //         "تقبل الله هذا العمل صدقة جارية لي ولكل من ساهم في نشره",
                //         textAlign: TextAlign.center,
                //         style: Theme.of(context).textTheme.bodyMedium,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required bool isDark,
    String? iconPath,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: ConstColors.tealGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: (iconPath == null || iconPath.isEmpty)
            ? null
            : Image.asset(
                iconPath,
                width: 32,
                height: 32,
                color: ConstColors.goldAccent,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.settings,
                  color: ConstColors.goldAccent,
                  size: 32,
                ),
              ),
        title: Text(
          title,
          style: const TextStyle(
            color: ConstColors.goldAccent,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 192, 191, 191),
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
