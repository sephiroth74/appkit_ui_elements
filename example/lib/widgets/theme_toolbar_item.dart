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
            onPressed: (value) =>
                context.read<AppTheme>().mode = ThemeMode.light,
            title: 'Light theme',
            value: 'light',
            image: Icons.light_mode,
            itemState: context.watch<AppTheme>().mode == ThemeMode.light
                ? AppKitItemState.on
                : AppKitItemState.off),
        AppKitContextMenuItem(
            onPressed: (value) =>
                context.read<AppTheme>().mode = ThemeMode.dark,
            title: 'Dark theme',
            value: 'dark',
            image: Icons.dark_mode,
            itemState: context.watch<AppTheme>().mode == ThemeMode.dark
                ? AppKitItemState.on
                : AppKitItemState.off),
        AppKitContextMenuItem(
            onPressed: (value) =>
                context.read<AppTheme>().mode = ThemeMode.system,
            title: 'System theme',
            value: 'system',
            image: Icons.mode_night_rounded,
            itemState: context.watch<AppTheme>().mode == ThemeMode.system
                ? AppKitItemState.on
                : AppKitItemState.off),
      ],
    );
  }
}
