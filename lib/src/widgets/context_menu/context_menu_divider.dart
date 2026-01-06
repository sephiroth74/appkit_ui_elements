import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_entry.dart';
import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_state.dart';
import 'package:flutter/material.dart';

final class AppKitContextMenuDivider<T> extends AppKitContextMenuEntry<T> {
  const AppKitContextMenuDivider() : super(enabled: false);

  @override
  Widget builder(BuildContext context, AppKitContextMenuState menuState) {
    return const Divider(thickness: 0.5, indent: 6, endIndent: 6);
  }
}
