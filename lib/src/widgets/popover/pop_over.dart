import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:flutter/material.dart';

@protected
const kCornerRadius = 6.0;

@protected
const kAnchorHeight = 10.0;

@protected
const kAnchorWidth = 20.0;

class PopoverProvider extends InheritedNotifier<PopoverState> {
  const PopoverProvider({
    super.key,
    required super.child,
    required PopoverState state,
  }) : super(notifier: state);
}

class PopoverState extends ChangeNotifier {
  static const EdgeInsets _kPadding = EdgeInsets.all(8.0);

  final Rect? itemRect;

  final Widget child;

  final LayerLink? link;

  Alignment? targetAnchor;

  AppKitPopoverDirection direction;

  final bool showArrow;

  Offset? _position;

  bool _isPositionVerified = false;

  bool get isPositionVerified => _isPositionVerified;

  Offset get position => _position ?? Offset.zero;

  Offset? get anchorOffset => (link != null) ? position : null;

  EdgeInsetsGeometry get paddings {
    if (showArrow) {
      switch (direction) {
        case AppKitPopoverDirection.top:
          return _kPadding.copyWith(bottom: kAnchorHeight + _kPadding.bottom);
        case AppKitPopoverDirection.bottom:
          return _kPadding.copyWith(top: kAnchorHeight + _kPadding.top);
        case AppKitPopoverDirection.left:
          return _kPadding.copyWith(right: kAnchorHeight + _kPadding.right);
        case AppKitPopoverDirection.right:
          return _kPadding.copyWith(left: kAnchorHeight + _kPadding.left);
      }
    } else {
      return const EdgeInsets.all(8.0);
    }
  }

  PopoverState({
    required this.child,
    required this.direction,
    required this.showArrow,
    this.itemRect,
    this.targetAnchor,
    this.link,
    Offset? position,
  }) : _position = position;

  static PopoverState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<PopoverProvider>()!
            as PopoverProvider?;

    if (provider == null) {
      throw 'No PopoverProvider found in context';
    }
    return provider.notifier!;
  }

  void verifyPosition(BuildContext context) {
    if (_isPositionVerified) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_position == null) {
        Rect childRect = context.getWidgetBounds()!;
        final screenSize = MediaQuery.of(context).size;
        final safeScreenRect = (Offset.zero & screenSize).deflate(8.0);

        debugPrint('safeScreenRect: $safeScreenRect');
        debugPrint('childRect: $childRect');
        debugPrint('itemRect: $itemRect');

        Offset finalPosition = Offset.zero;

        if (itemRect != null) {
          finalPosition = itemRect!.getAnchorOffset(targetAnchor);

          switch (direction) {
            case AppKitPopoverDirection.top:
              finalPosition += Offset(-childRect.width / 2, -childRect.height);
            case AppKitPopoverDirection.bottom:
              finalPosition += Offset(-childRect.width / 2, 0);
            case AppKitPopoverDirection.left:
              finalPosition += Offset(-childRect.width, -childRect.height / 2);
            case AppKitPopoverDirection.right:
              finalPosition += Offset(0, -childRect.height / 2);
          }

          if (direction == AppKitPopoverDirection.bottom) {
            if (itemRect!.bottom + childRect.height > safeScreenRect.bottom) {
              finalPosition =
                  Offset(finalPosition.dx, itemRect!.top - childRect.height);
              direction = AppKitPopoverDirection.top;
              targetAnchor = Alignment.topCenter;
            }
          } else if (direction == AppKitPopoverDirection.top) {
            if (itemRect!.top - childRect.height < safeScreenRect.top) {
              finalPosition = Offset(finalPosition.dx, 0);
              direction = AppKitPopoverDirection.bottom;
              targetAnchor = Alignment.bottomCenter;
            }
          } else if (direction == AppKitPopoverDirection.right) {
            if (itemRect!.right + childRect.width > safeScreenRect.width) {
              finalPosition = Offset(-childRect.width, finalPosition.dy);
              direction = AppKitPopoverDirection.left;
              targetAnchor = Alignment.centerLeft;
            }
          } else if (direction == AppKitPopoverDirection.left) {
            if (itemRect!.left - childRect.width < safeScreenRect.left) {
              finalPosition = Offset(0, finalPosition.dy);
              direction = AppKitPopoverDirection.right;
              targetAnchor = Alignment.centerRight;
            }
          }
        } else if (link != null) {
          // link is not null
          switch (direction) {
            case AppKitPopoverDirection.top:
              finalPosition += Offset(-childRect.width / 2, -childRect.height);
            case AppKitPopoverDirection.bottom:
              finalPosition += Offset(-childRect.width / 2, 0);
            case AppKitPopoverDirection.left:
              finalPosition += Offset(-childRect.width, -childRect.height / 2);
            case AppKitPopoverDirection.right:
              finalPosition += Offset(0, -childRect.height / 2);
          }
        }

        _position = finalPosition;
      }

      _isPositionVerified = true;
      notifyListeners();
    });
  }
}

extension _RectX on Rect {
  Offset getAnchorOffset(Alignment? targetAnchor) {
    switch (targetAnchor) {
      case Alignment.topLeft:
        return Offset(left, top);
      case Alignment.topCenter:
        return Offset(left + width / 2, top);
      case Alignment.topRight:
        return Offset(right, top);
      case Alignment.centerLeft:
        return Offset(left, top + height / 2);
      case Alignment.center:
        return Offset(left + width / 2, top + height / 2);
      case Alignment.centerRight:
        return Offset(right, top + height / 2);
      case Alignment.bottomLeft:
        return Offset(left, bottom);
      case Alignment.bottomCenter:
        return Offset(left + width / 2, bottom);
      case Alignment.bottomRight:
        return Offset(right, bottom);
      default:
        return center;
    }
  }
}
