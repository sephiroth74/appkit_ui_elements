import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitContextMenuRegion<T> extends StatelessWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final Widget child;
  final ValueChanged<T?>? onItemSelected;

  const AppKitContextMenuRegion({
    super.key,
    required this.menuBuilder,
    required this.child,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (menuBuilder == null) {
      return child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) {
        _showMenu(context, details.globalPosition);
      },
      onLongPressStart: (details) {
        _showMenu(context, details.globalPosition);
      },
      child: child,
    );
  }

  void _showMenu(BuildContext context, Offset mousePosition) async {
    var menu = menuBuilder!.call(context);
    menu = menu.copyWith(position: menu.position ?? mousePosition);
    final value = await showContextMenu<T>(
      context,
      contextMenu: menu,
      enableWallpaperTinting: true,
    );

    if (value != null) {
      onItemSelected?.call(value.value);
    }
  }
}
