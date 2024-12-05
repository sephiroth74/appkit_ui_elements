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

  final Widget child;

  final LayerLink? link;

  final Alignment? targetAnchor;

  final AppKitPopoverDirection direction;

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

        debugPrint('childRect: $childRect, direction: $direction');

        // add the padding to the childRect, if the arrow is shown
        // if (showArrow) {
        //   switch (direction) {
        //     case AppKitPopoverDirection.top:
        //     // childRect = childRect.copyWith(top: childRect.top - _PopoverBackgroundPainter.anchorHeight);
        //     case AppKitPopoverDirection.bottom:
        //     childRect = childRect.copyWith(bottom: childRect.bottom + _PopoverBackgroundPainter.anchorHeight);
        //     case AppKitPopoverDirection.left:
        //     case AppKitPopoverDirection.right:
        //   }
        // }

        // final screenSize = MediaQuery.of(context).size;
        // final safeScreenSize = (Offset.zero & screenSize).deflate(8.0);

        switch (direction) {
          case AppKitPopoverDirection.top:
            _position ??= Offset(-childRect.width / 2, -childRect.height);
          case AppKitPopoverDirection.bottom:
            _position ??= Offset(-childRect.width / 2, 0);
          case AppKitPopoverDirection.left:
            _position ??= Offset(-childRect.width, -childRect.height / 2);
          case AppKitPopoverDirection.right:
            _position ??= Offset(0, -childRect.height / 2);
        }
      }

      _isPositionVerified = true;
      notifyListeners();
    });
  }
}
