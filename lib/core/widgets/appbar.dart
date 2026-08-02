import 'package:diaa_almuslim/core/constants/routes.dart';
import 'package:diaa_almuslim/core/utils/theme_mode_extension.dart';
import 'package:flutter/material.dart';
import 'package:diaa_almuslim/core/constants/colors.dart';
import 'package:diaa_almuslim/core/constants/icons.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  // final VoidCallback? onPressDrawer;
  final String pageName;
  final bool? showSettingsButton;
  final Color? backgroundColor;
  const MyAppbar({
    super.key,
    // this.onPressDrawer,
    required this.pageName,
    this.backgroundColor =const Color(0x00000000),
    this.showSettingsButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      // surfaceTintColor: Colors.white,
      leading: showSettingsButton == true
          ? IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ConstRoutes.settings);
              },
              icon: Image.asset(
                ConstIcons.settings,
                width: 26,
                color: context.isDarkMode
                    ? ConstColors.goldAccent
                    : ConstColors.primaryTeal,
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Text(
        pageName,
        style: TextStyle(
          fontSize: 20,
          color: context.isDarkMode
              ? ConstColors.goldAccent
              : ConstColors.primaryTeal,
        ),
      ),
      centerTitle: showSettingsButton == true ? true : false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            ConstIcons.back,
            width: 26,
            color: context.isDarkMode
                ? ConstColors.goldAccent
                : ConstColors.primaryTeal,
          ),
        ),
      ],
    );
  }
}
