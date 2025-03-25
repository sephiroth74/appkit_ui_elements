import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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
  T? selectedItem,
  AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
  bool enableWallpaperTinting = true,
}) async {
  final menuState = AppKitContextMenuState<T>(
    menu: contextMenu,
    focusedEntry: selectedItem,
    menuEdge: menuEdge,
    enableWallpaperTinting: enableWallpaperTinting,
  );

  final NavigatorState navigator = Navigator.of(context);

  return await Navigator.push<AppKitContextMenuItem<T>>(
    context,
    _AppKitContextMenuPageRoute<AppKitContextMenuItem<T>>(
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
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
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

class _AppKitContextMenuPageRoute<T> extends PageRoute<T> {
  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  final RouteTransitionsBuilder? transitionsBuilder;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool opaque;

  @override
  final bool maintainState;

  final RoutePageBuilder pageBuilder;

  final CapturedThemes capturedThemes;

  _AppKitContextMenuPageRoute({
    super.settings,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
    required this.barrierColor,
    required this.barrierLabel,
    required this.transitionsBuilder,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    required this.opaque,
    required this.maintainState,
    required this.pageBuilder,
    required this.capturedThemes,
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: capturedThemes.wrap(LayoutBuilder(builder: (context, constraints) {
        return Consumer<MainWindowModel>(builder: (context, model, _) {
          if (!model.isMainWindow) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.removeRoute(context, this);
            });
          }
          return pageBuilder(context, animation, secondaryAnimation);
        });
      })),
    );
  }
}
