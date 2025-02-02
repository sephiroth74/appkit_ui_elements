import 'package:appkit_ui_elements/appkit_ui_elements.dart';

@protected
const kCornerRadius = 6.0;

@protected
const kAnchorHeight = 10.0;

@protected
const kAnchorWidth = 20.0;

class AppKitPopoverProvider extends InheritedNotifier<AppKitPopoverState> {
  const AppKitPopoverProvider({
    super.key,
    required super.child,
    required AppKitPopoverState state,
  }) : super(notifier: state);
}

class AppKitPopoverState extends ChangeNotifier {
  static const EdgeInsets _kPadding = EdgeInsets.all(8.0);

  final Rect? itemRect;

  final Widget child;

  final LayerLink? link;

  Alignment? targetAnchor;

  AppKitMenuEdge direction;

  final bool showArrow;

  Offset? _position;

  bool _isPositionVerified = false;

  bool get isPositionVerified => _isPositionVerified;

  Offset get position => _position ?? Offset.zero;

  Offset? get anchorOffset => (link != null) ? position : null;

  EdgeInsetsGeometry get paddings {
    if (showArrow) {
      switch (direction) {
        case AppKitMenuEdge.top:
          return _kPadding.copyWith(bottom: kAnchorHeight + _kPadding.bottom);
        case AppKitMenuEdge.auto:
        case AppKitMenuEdge.bottom:
          return _kPadding.copyWith(top: kAnchorHeight + _kPadding.top);
        case AppKitMenuEdge.left:
          return _kPadding.copyWith(right: kAnchorHeight + _kPadding.right);
        case AppKitMenuEdge.right:
          return _kPadding.copyWith(left: kAnchorHeight + _kPadding.left);
      }
    } else {
      return const EdgeInsets.all(8.0);
    }
  }

  AppKitPopoverState({
    required this.child,
    required this.direction,
    required this.showArrow,
    this.itemRect,
    this.targetAnchor,
    this.link,
    Offset? position,
  }) : _position = position;

  static AppKitPopoverState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppKitPopoverProvider>()!
            as AppKitPopoverProvider?;

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
        Offset finalPosition = Offset.zero;

        if (itemRect != null) {
          finalPosition = itemRect!.getAnchorOffset(targetAnchor);

          switch (direction) {
            case AppKitMenuEdge.top:
              finalPosition += Offset(-childRect.width / 2, -childRect.height);
            case AppKitMenuEdge.auto:
            case AppKitMenuEdge.bottom:
              finalPosition += Offset(-childRect.width / 2, 0);
            case AppKitMenuEdge.left:
              finalPosition += Offset(-childRect.width, -childRect.height / 2);
            case AppKitMenuEdge.right:
              finalPosition += Offset(0, -childRect.height / 2);
          }

          if (direction == AppKitMenuEdge.bottom ||
              direction == AppKitMenuEdge.auto) {
            if (itemRect!.bottom + childRect.height > safeScreenRect.bottom) {
              finalPosition =
                  Offset(finalPosition.dx, itemRect!.top - childRect.height);
              direction = AppKitMenuEdge.top;
              targetAnchor = Alignment.topCenter;
            }
          } else if (direction == AppKitMenuEdge.top) {
            if (itemRect!.top - childRect.height < safeScreenRect.top) {
              finalPosition = Offset(finalPosition.dx, 0);
              direction = AppKitMenuEdge.bottom;
              targetAnchor = Alignment.bottomCenter;
            }
          } else if (direction == AppKitMenuEdge.right) {
            if (itemRect!.right + childRect.width > safeScreenRect.width) {
              finalPosition = Offset(-childRect.width, finalPosition.dy);
              direction = AppKitMenuEdge.left;
              targetAnchor = Alignment.centerLeft;
            }
          } else if (direction == AppKitMenuEdge.left) {
            if (itemRect!.left - childRect.width < safeScreenRect.left) {
              finalPosition = Offset(0, finalPosition.dy);
              direction = AppKitMenuEdge.right;
              targetAnchor = Alignment.centerRight;
            }
          }
        } else if (link != null) {
          // link is not null
          switch (direction) {
            case AppKitMenuEdge.top:
              finalPosition += Offset(-childRect.width / 2, -childRect.height);
            case AppKitMenuEdge.auto:
            case AppKitMenuEdge.bottom:
              finalPosition += Offset(-childRect.width / 2, 0);
            case AppKitMenuEdge.left:
              finalPosition += Offset(-childRect.width, -childRect.height / 2);
            case AppKitMenuEdge.right:
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
        return Offset(this.left, top);
      case Alignment.topCenter:
        return Offset(this.left + width / 2, top);
      case Alignment.topRight:
        return Offset(this.right, top);
      case Alignment.centerLeft:
        return Offset(this.left, top + height / 2);
      case Alignment.center:
        return Offset(this.left + width / 2, top + height / 2);
      case Alignment.centerRight:
        return Offset(this.right, top + height / 2);
      case Alignment.bottomLeft:
        return Offset(this.left, bottom);
      case Alignment.bottomCenter:
        return Offset(this.left + width / 2, bottom);
      case Alignment.bottomRight:
        return Offset(this.right, bottom);
      default:
        return center;
    }
  }
}
