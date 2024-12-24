import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu.dart';
import 'package:appkit_ui_elements/src/widgets/context_menu/helpers.dart';
import 'package:flutter/material.dart';

class AppKitContextMenuRegion extends StatelessWidget {
  final AppKitContextMenu contextMenu;
  final Widget child;
  final ValueChanged<dynamic>? onItemSelected;

  const AppKitContextMenuRegion({
    super.key,
    required this.contextMenu,
    required this.child,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    Offset mousePosition = Offset.zero;

    return Listener(
      onPointerDown: (event) {
        mousePosition = event.position;
      },
      child: GestureDetector(
        onLongPress: () => _showMenu(context, mousePosition),
        onSecondaryTap: () => _showMenu(context, mousePosition),
        child: child,
      ),
    );
  }

  void _showMenu(BuildContext context, Offset mousePosition) async {
    final menu =
        contextMenu.copyWith(position: contextMenu.position ?? mousePosition);
    final value = await showContextMenu(
      context,
      contextMenu: menu,
      enableWallpaperTinting: true,
    );
    onItemSelected?.call(value);
  }
}
