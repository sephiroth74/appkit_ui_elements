import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/widgets.dart';

extension PopoverX on BuildContext {
  Future<dynamic> showPopover({
    required Widget child,
    LayerLink? link,
    Rect? itemRect,
    Offset? position,
    Alignment? targetAnchor,
    AppKitPopoverDirection direction = AppKitPopoverDirection.bottom,
    bool showArrow = true,
    Duration? transitionDuration = const Duration(milliseconds: 200),
    required String uuid,
  }) async {
    // link, itemRect or position must be provided
    assert(link != null || itemRect != null || position != null);

    // link and itemRect cannot be provided at the same time
    assert(link == null || itemRect == null);

    final state = PopoverState(
        itemRect: itemRect,
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
