import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/services/app_actions_service.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';

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

  void isThereUpdate() async {
    await AppActionsService.checkAppUpdate(context);
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    isThereUpdate();
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppbar(pageName: "الإعدادات", showDrawer: false),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            //bottom shape
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Opacity(
            //     opacity: 0.2,
            //     child: Image.asset(ConstIcons.backgroundShape),
            //   ),
            // ),
            SpecialBody(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                        activeThumbColor: ConstColors.mainColor,
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
                          dropdownColor: isDark ? Colors.black : Colors.white,
                          style: Theme.of(context).textTheme.bodySmall,
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
                          backgroundColor: ConstColors.mainColor,
                          foregroundColor: Colors.white,

                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 36,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
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
                          backgroundColor: ConstColors.mainColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
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
                    _buildSettingTile(
                      isDark: isDark,
                      title:
                          "الإصدار: ${AppActionsService.globalCurrentVersoin}",
                      trailing:
                          AppActionsService.globalCheckCurrentVersion ?? true
                          ? Text("أنت على احدث إصدار")
                          : FilledButton(
                              onPressed: () async {
                                await AppActionsService.checkAppUpdate(context);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: ConstColors.mainColor,
                                foregroundColor: Colors.white,

                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "تحديث الإصدار",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
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
            // لا تنسونا من صالح دعائكم box
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: ConstColors.mainGradientColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Text(
                  "لا تنسونا من صالح دعائكم",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
    return Card(
      color: isDark ? Colors.black : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: (iconPath == null || iconPath.isEmpty)
            ? null
            : Image.asset(
                iconPath,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.settings,
                  color: ConstColors.mainColor,
                  size: 32,
                ),
              ),
        title: Text(
          title,
          style: TextStyle(
            color: ConstColors.mainColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
