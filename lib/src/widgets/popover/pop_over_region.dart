import 'package:appkit_ui_elements/src/enums/enums.dart';
import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:appkit_ui_elements/src/widgets/popover/helpers.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

typedef AppKitPopoverBuilder = Widget Function(BuildContext context);

class AppKitPopoverRegion extends StatelessWidget {
  final Widget child;
  final AppKitPopoverDirection direction;
  final Alignment alignment;
  final AppKitPopoverBuilder builder;
  final String _uuid = const Uuid().v4();

  AppKitPopoverRegion({
    super.key,
    required this.child,
    required this.direction,
    required this.alignment,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    Offset mousePosition = Offset.zero;

    return Listener(
      onPointerDown: (event) {
        mousePosition = event.position;
      },
      child: GestureDetector(
        onTap: () => _showPopover(context, mousePosition),
        child: child,
      ),
    );
  }

  void _showPopover(BuildContext context, Offset mousePosition) async {
    final buttonRect = context.getWidgetBounds() ?? Rect.zero;

    await context.showPopover(
      transitionDuration: const Duration(milliseconds: 200),
      itemRect: buttonRect,
      targetAnchor: alignment,
      direction: direction,
      showArrow: true,
      child: builder(context),
      uuid: _uuid,
    );
  }
}
