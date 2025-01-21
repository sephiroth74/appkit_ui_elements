import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/scheduler.dart';

extension PopoverX on BuildContext {
  Future<dynamic> showPopover(
    BuildContext context, {
    required Widget child,
    LayerLink? link,
    Rect? itemRect,
    Offset? position,
    Alignment? targetAnchor,
    AppKitMenuEdge direction = AppKitMenuEdge.bottom,
    bool showArrow = true,
    Duration? transitionDuration = const Duration(milliseconds: 200),
    required String uuid,
  }) async {
    // link, itemRect or position must be provided
    assert(link != null || itemRect != null || position != null);

    // link and itemRect cannot be provided at the same time
    assert(link == null || itemRect == null);

    final state = AppKitPopoverState(
        itemRect: itemRect,
        link: link,
        child: child,
        targetAnchor: targetAnchor,
        direction: direction,
        position: position,
        showArrow: showArrow);

    final navigator = Navigator.of(this);
    return await Navigator.push<dynamic>(
      this,
      _AppKitPopOverPageRoute<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            children: [
              AppKitPopoverWidget(
                popoverState: state,
                transitionDuration: transitionDuration,
              )
            ],
          );
        },
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        settings: RouteSettings(name: "popover-menu", arguments: uuid),
        fullscreenDialog: true,
        barrierDismissible: true,
        opaque: false,
        transitionDuration: transitionDuration ?? Duration.zero,
        reverseTransitionDuration: Duration.zero,
        barrierColor: null,
        barrierLabel: null,
      ),
    );
  }

  bool isPopoverVisible(String uuid) {
    return ModalRoute.of(this)!.settings.name == "popover-menu" &&
        ModalRoute.of(this)!.settings.arguments == uuid;
  }
}

Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return child;
}

class _AppKitPopOverPageRoute<T> extends PageRoute<T> {
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

  _AppKitPopOverPageRoute({
    super.settings,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
    this.transitionsBuilder = _defaultTransitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.maintainState = true,
    required this.barrierColor,
    required this.barrierLabel,
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
        return MainWindowBuilder(builder: (context, isMainWindow) {
          if (!isMainWindow) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              // remove the navigator overlay, if it's a AppKitPopOverPageRoute
              final navigator = Navigator.of(context);
              if(navigator.canPop()) {
                Navigator.of(context).popUntil((route) => route is! _AppKitPopOverPageRoute);
              }
            });
          }
          return pageBuilder(context, animation, secondaryAnimation);
        });
      })),
    );
  }
}
