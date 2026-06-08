import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPressDrawer;
  final String pageName;
  final bool? showDrawer;
  const MyAppbar({
    super.key,
    this.onPressDrawer,
    required this.pageName,
    this.showDrawer = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
      leading: showDrawer == true
          ? IconButton(
              onPressed: onPressDrawer,
              icon: Image.asset(ConstIcons.drawer, width: 26),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Text(
        pageName,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
      ),
      centerTitle: showDrawer == true ? true : false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(ConstIcons.back, width: 26),
        ),
      ],
    );
  }
}
