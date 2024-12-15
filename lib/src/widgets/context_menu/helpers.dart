import 'package:appkit_ui_elements/appkit_ui_elements.dart';

/// Shows the root context menu popup.
Future<AppKitContextMenuItem<T>?> showContextMenu<T>(
  BuildContext context, {
  required AppKitContextMenu<T> contextMenu,
  RouteSettings? routeSettings,
  bool? opaque,
  bool? barrierDismissible,
  Color? barrierColor,
  String? barrierLabel,
  Duration? transitionDuration,
  Duration? reverseTransitionDuration,
  RouteTransitionsBuilder? transitionsBuilder,
  bool allowSnapshotting = true,
  bool maintainState = false,
  AppKitContextMenuItem<T>? selectedItem,
  AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
}) async {
  final menuState = AppKitContextMenuState<T>(
      menu: contextMenu, focusedEntry: selectedItem, menuEdge: menuEdge);
  return await Navigator.push<AppKitContextMenuItem<T>>(
    context,
    PageRouteBuilder<AppKitContextMenuItem<T>>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            AppKitContextMenuWidget(
              menuState: menuState,
              transitionDuration: transitionDuration,
            )
          ],
        );
      },
      settings: routeSettings ?? const RouteSettings(name: "context-menu"),
      fullscreenDialog: true,
      barrierDismissible: barrierDismissible ?? true,
      opaque: opaque ?? false,
      transitionDuration: transitionDuration ?? Duration.zero,
      reverseTransitionDuration: reverseTransitionDuration ?? Duration.zero,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      transitionsBuilder: transitionsBuilder ?? _defaultTransitionsBuilder,
      allowSnapshotting: allowSnapshotting,
      maintainState: maintainState,
    ),
  );
}

Widget _defaultTransitionsBuilder(
    context, animation, secondaryAnimation, child) {
  return child;
}
