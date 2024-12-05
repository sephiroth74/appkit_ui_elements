import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

class PopoverWidget extends StatelessWidget {
  final PopoverState popoverState;
  final Duration transitionDuration;
  const PopoverWidget({
    super.key,
    required this.popoverState,
    Duration? transitionDuration,
  }) : transitionDuration =
            transitionDuration ?? const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return PopoverProvider(
      state: popoverState,
      child: Builder(
        builder: (context) {
          final state = PopoverState.of(context);
          state.verifyPosition(context);

          final child = Opacity(
            opacity: state.isPositionVerified ? 1.0 : 0.0,
            child: _buildPopover(
              context,
              state,
            ),
          );

          if (state.link == null) {
            return Positioned(
                left: state.position.dx, top: state.position.dy, child: child);
          }

          return CompositedTransformFollower(
            link: state.link!,
            targetAnchor: state.targetAnchor!,
            offset: state.position,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildPopover(BuildContext context, PopoverState state) {
    return TweenAnimationBuilder(
        curve: Curves.easeOutBack,
        duration: transitionDuration,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: value,
                alignment: Alignment.center,
                child:
                    UiElementColorBuilder(builder: (context, colorContainer) {
                  return CustomPaint(
                      painter: _PopoverBackgroundPainter(
                        cornerRadius: kCornerRadius,
                        anchorHeight: kAnchorHeight,
                        anchorWidth: kAnchorWidth,
                        color: colorContainer.windowBackgroundColor,
                        anchorOffset: state.anchorOffset,
                        anchorDirection:
                            state.showArrow ? state.direction : null,
                      ),
                      child: Padding(
                        padding: state.paddings,
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 50,
                              minHeight: 50,
                            ),
                            child: state.child),
                      ));
                }),
              ));
        });
  }
}

class _PopoverBackgroundPainter extends CustomPainter {
  final Color color;
  final Offset? anchorOffset;
  final AppKitPopoverDirection? anchorDirection;
  final double cornerRadius;
  final double anchorHeight;
  final double anchorWidth;

  _PopoverBackgroundPainter(
      {required this.color,
      required this.anchorOffset,
      required this.anchorDirection,
      required this.cornerRadius,
      required this.anchorHeight,
      required this.anchorWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();

    // debugPrint('anchorOffset: $anchorOffset, anchorDirection: $anchorDirection');

    // draw a rounded rectangle with an arrow pointing to the direciton of the anchor

    final double offsetDx, offsetDy;

    final Rect rect;
    if (anchorDirection == null) {
      rect = Rect.fromLTRB(0, 0, size.width, size.height);
    } else {
      switch (anchorDirection!) {
        case AppKitPopoverDirection.top:
          rect = Rect.fromLTRB(0, anchorHeight, size.width, size.height);
        case AppKitPopoverDirection.bottom:
          rect = Rect.fromLTRB(0, anchorHeight, size.width, size.height);
        case AppKitPopoverDirection.left:
          rect = Rect.fromLTRB(anchorHeight, 0, size.width, size.height);
        case AppKitPopoverDirection.right:
          rect = Rect.fromLTRB(0, 0, size.width - anchorHeight, size.height);
      }
    }

    if (null == anchorOffset) {
      offsetDx = (anchorDirection == AppKitPopoverDirection.top ||
              anchorDirection == AppKitPopoverDirection.bottom)
          ? rect.topCenter.dx
          : 0;
      offsetDy = (anchorDirection == AppKitPopoverDirection.left ||
              anchorDirection == AppKitPopoverDirection.right)
          ? rect.centerLeft.dy
          : 0;
    } else {
      offsetDx = -anchorOffset!.dx;
      offsetDy = -anchorOffset!.dy;
    }

    path.moveTo(rect.left + cornerRadius, rect.top);

    if (anchorDirection == AppKitPopoverDirection.bottom) {
      path.lineTo(rect.left + offsetDx - anchorWidth / 2, rect.top);
      path.lineTo(rect.left + offsetDx, rect.top - anchorHeight);
      path.lineTo(rect.left + offsetDx + anchorWidth / 2, rect.top);
    }

    path.lineTo(rect.right - cornerRadius, rect.top);
    path.arcToPoint(Offset(rect.right, cornerRadius + rect.top),
        radius: Radius.circular(cornerRadius));

    // right
    if (anchorDirection == AppKitPopoverDirection.left) {
      path.lineTo(rect.right, rect.top + offsetDy - anchorWidth / 2);
      path.lineTo(rect.right + anchorHeight, rect.top + offsetDy);
      path.lineTo(rect.right, rect.top + offsetDy + anchorWidth / 2);
    }

    path.lineTo(rect.right, rect.bottom - cornerRadius);
    path.arcToPoint(Offset(rect.right - cornerRadius, rect.bottom),
        radius: Radius.circular(cornerRadius));

    // bottom
    if (anchorDirection == AppKitPopoverDirection.top) {
      path.lineTo(rect.left + offsetDx + anchorWidth / 2, rect.bottom);
      path.lineTo(rect.left + offsetDx, rect.bottom + anchorHeight);
      path.lineTo(rect.left + offsetDx - anchorWidth / 2, rect.bottom);
    }

    path.lineTo(rect.left + cornerRadius, rect.bottom);
    path.arcToPoint(Offset(rect.left, rect.bottom - cornerRadius),
        radius: Radius.circular(cornerRadius));

    // left

    if (anchorDirection == AppKitPopoverDirection.right) {
      path.lineTo(rect.left, rect.top + offsetDy + anchorWidth / 2);
      path.lineTo(rect.left - anchorHeight, rect.top + offsetDy);
      path.lineTo(rect.left, rect.top + offsetDy - anchorWidth / 2);
    }

    path.lineTo(rect.left, rect.top + cornerRadius);
    path.arcToPoint(Offset(rect.left + cornerRadius, rect.top),
        radius: Radius.circular(cornerRadius));
    path.close();

    canvas.drawShadow(path, Colors.grey.shade700, 6.0, true);
    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.black26
      ..strokeWidth = 0.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this ||
        (oldDelegate as _PopoverBackgroundPainter).color != color;
  }
}
