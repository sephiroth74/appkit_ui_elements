import 'package:example/pages/controls_page.dart';
import 'package:provider/provider.dart';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart';

class ThemeSwitcherToolbarItem {
  ThemeSwitcherToolbarItem._();

  static AppKitToolBarPullDownButton build(BuildContext context) {
    return AppKitToolBarPullDownButton(
      width: 90,
      label: 'Theme',
      showLabel: true,
      items: [
        AppKitContextMenuItem(
            onTap: () => context.read<AppTheme>().mode = ThemeMode.light,
            child: titleWithIconMenuItem('Light theme', Icons.light_mode),
            value: 'light',
            itemState: context.watch<AppTheme>().mode == ThemeMode.light
                ? AppKitItemState.on
                : AppKitItemState.off),
        AppKitContextMenuItem(
            onTap: () => context.read<AppTheme>().mode = ThemeMode.dark,
            child: titleWithIconMenuItem('Dark theme', Icons.dark_mode),
            value: 'dark',
            itemState: context.watch<AppTheme>().mode == ThemeMode.dark
                ? AppKitItemState.on
                : AppKitItemState.off),
        const AppKitContextMenuDivider(),
        AppKitContextMenuItem(
            onTap: () => context.read<AppTheme>().mode = ThemeMode.system,
            child:
                titleWithIconMenuItem('System theme', Icons.mode_night_rounded),
            value: 'system',
            itemState: context.watch<AppTheme>().mode == ThemeMode.system
                ? AppKitItemState.on
                : AppKitItemState.off),
      ],
    );
  }
}
