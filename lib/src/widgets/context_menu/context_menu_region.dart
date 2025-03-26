import 'package:appkit_ui_elements/appkit_ui_elements.dart';

/// A widget that defines a region where an AppKit-style context menu can be shown.
///
/// The [AppKitContextMenuRegion] widget is used to wrap a part of the widget tree
/// where a context menu should be displayed when the user performs a right-click
/// or long-press gesture.
///
/// The type parameter [T] represents the type of the value that will be passed
/// to the context menu actions.
///
/// This widget is a part of the `appkit_ui_elements` package.
///
/// Example usage:
///
/// ```dart
///   AppKitContextMenuRegion(
///     onItemSelected: (value) {
///       debugPrint('Selected: $value');
///     },
///     menuBuilder: (context) => AppKitContextMenu<String>(
///       entries: [
///         const AppKitContextMenuItem(
///             value: 'cut',
///             child: Row(children: [
///               AppKitIcon(
///                 Icons.cut,
///                 size: 12,
///               ),
///               SizedBox(width: 6),
///               Text('Cut'),
///             ])),
///         const AppKitContextMenuItem(
///             value: 'copy',
///             child: Row(children: [
///               AppKitIcon(Icons.copy, size: 12),
///               SizedBox(width: 6),
///               Text('Copy'),
///             ])),
///         const AppKitContextMenuItem(
///           value: 'paste',
///           child: Row(
///             children: [
///               AppKitIcon(Icons.paste, size: 12),
///               SizedBox(width: 6),
///               Text('Paste'),
///             ],
///           ),
///         ),
///         const AppKitContextMenuDivider(),
///         const AppKitContextMenuItem(
///             child: Text('Select All'), value: 'select_all'),
///       ],
///       maxHeight: 300,
///       minWidth: 200,
///     ),
///     child: const SizedBox.expand(
///       child: Center(
///           child: AppKitLabel(
///               text: Text(
///                   'Rich click anywhere to open the context menu'))),
///     ),
///   );
/// ```
class AppKitContextMenuRegion<T> extends StatelessWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final Widget child;
  final ValueChanged<T?>? onItemSelected;
  final bool enableWallpaperTinting;

  const AppKitContextMenuRegion({
    super.key,
    required this.menuBuilder,
    required this.child,
    this.onItemSelected,
    this.enableWallpaperTinting = true,
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
      enableWallpaperTinting: enableWallpaperTinting,
      opaque: false,
    );

    if (value != null) {
      onItemSelected?.call(value.value);
    }
  }
}
