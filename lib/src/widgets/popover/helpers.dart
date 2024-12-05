import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/widgets.dart';

extension PopoverX on BuildContext {
  Future<dynamic> showPopover({
    required Widget child,
    LayerLink? link,
    Offset? position,
    Alignment? targetAnchor,
    AppKitPopoverDirection direction = AppKitPopoverDirection.bottom,
    bool showArrow = true,
    Duration? transitionDuration = const Duration(milliseconds: 200),
  }) async {
    final state = PopoverState(
        link: link,
        child: child,
        targetAnchor: targetAnchor,
        direction: direction,
        position: position,
        showArrow: showArrow);
    return await Navigator.push<dynamic>(
      this,
      PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            children: [
              PopoverWidget(
                popoverState: state,
                transitionDuration: transitionDuration,
              )
            ],
          );
        },
        settings: const RouteSettings(name: "popover-menu"),
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
}
