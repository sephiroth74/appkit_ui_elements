import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

const Duration _fadeInDuration = Duration(milliseconds: 150);
const Duration _fadeOutDuration = Duration(milliseconds: 75);

/// A custom tooltip widget for the AppKit UI elements library.
///
/// This widget displays a tooltip with custom styling and behavior.
/// It extends the [StatefulWidget] to maintain its state.
///
/// Usage:
/// ```dart
/// AppKitTooltip.plain(
///   message: 'This is a tooltip message',
///   child: Icon(Icons.info),
/// )
/// ```
///
/// You can customize the tooltip by providing various parameters.
///
/// See also:
///
///  * [Tooltip], which is the standard Flutter tooltip widget.
class AppKitTooltip extends StatefulWidget {
  /// A text span that represents the message to be displayed in the tooltip.
  final TextSpan message;

  /// Whether the message should be soft-wrapped if it exceeds the width of the tooltip.
  final bool softWrap;

  /// The widget that will trigger the tooltip when interacted with.
  final Widget child;

  /// Whether to use the mouse position to determine the tooltip's position.
  final bool useMousePosition;

  /// The padding around the tooltip's content.
  final EdgeInsetsGeometry? padding;

  const AppKitTooltip({
    super.key,
    required this.message,
    required this.child,
    this.softWrap = true,
    this.useMousePosition = true,
    this.padding,
  });

  /// Creates a plain AppKitTooltip.
  ///
  /// This factory constructor allows you to create a tooltip with default settings.
  ///
  /// Example usage:
  /// ```dart
  /// AppKitTooltip.plain(
  ///   message: 'This is a tooltip',
  ///   child: Text('Hover over me'),
  /// );
  /// ```
  ///
  /// - `message`: The text to display in the tooltip.
  /// - `child`: The widget that will trigger the tooltip when hovered over.
  factory AppKitTooltip.plain({
    required String message,
    required Widget child,
    bool useMousePosition = true,
    bool softWrap = true,
    EdgeInsetsGeometry? padding,
  }) {
    return AppKitTooltip(
      message: TextSpan(text: message, style: null),
      useMousePosition: useMousePosition,
      softWrap: softWrap,
      padding: padding,
      child: child,
    );
  }

  /// Creates a rich tooltip with the given properties.
  ///
  /// The [rich] constructor allows you to create a tooltip with more complex
  /// content, such as multiple lines of text, images, or other widgets.
  ///
  /// The [AppKitTooltip.rich] constructor takes the following parameters:
  ///
  /// - `key`: An optional key for the widget.
  /// - `message`: The primary message to be displayed in the tooltip.
  /// - `child`: The widget that will trigger the tooltip when hovered over or
  ///   long-pressed.
  ///
  /// Example usage:
  /// ```dart
  /// AppKitTooltip.rich(
  ///   message: TestSpan(
  ///     text: 'This is a tooltip message',
  ///     style: TextStyle(color: Colors.white),
  ///     children: [
  ///       TextSpan(text: ' with multiple lines of text.'),
  ///       TextSpan(text: '\n\nThis is a new paragraph.'),
  ///       WidgetSpan(child: Icon(Icons.info)),
  ///    ],
  ///   ),
  ///   child: Icon(Icons.info),
  /// );
  /// ```
  factory AppKitTooltip.rich({
    required TextSpan message,
    required Widget child,
    bool useMousePosition = true,
    bool softWrap = true,
    EdgeInsetsGeometry? padding,
  }) {
    return AppKitTooltip(
      message: message,
      useMousePosition: useMousePosition,
      softWrap: softWrap,
      padding: padding,
      child: child,
    );
  }

  @override
  State<AppKitTooltip> createState() => _AppKitTooltipState();
}

class _AppKitTooltipState extends State<AppKitTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AppKitTooltipThemeData themeData = AppKitTooltipTheme.of(context);

  bool _mouseIsConnected = false;
  Offset? mousePosition;
  OverlayEntry? _entry;
  Timer? _hideTimer;
  Timer? _showTimer;

  EdgeInsetsGeometry get padding => widget.padding ?? themeData.padding;
  EdgeInsetsGeometry get margin => themeData.margin;
  Decoration get decoration => themeData.decoration;
  Duration get waitDuration => themeData.waitDuration;
  Duration get showDuration => themeData.showDuration;
  TextStyle get textStyle => themeData.textStyle;
  bool get preferBelow => themeData.preferBelow;
  double get verticalOffset => themeData.verticalOffset;
  double get minHeight => themeData.minHeight;

  @override
  void initState() {
    super.initState();

    _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;

    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

    RendererBinding.instance.mouseTracker
        .addListener(_handleMouseTrackerChange);

    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void _show({bool showImmediately = false}) {
    _hideTimer?.cancel();
    _hideTimer = null;
    if (showImmediately) {
      ensureTooltipVisible();
      return;
    }
    _showTimer ??= Timer(waitDuration, ensureTooltipVisible);
  }

  void _hide({bool hideImmediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;
    if (hideImmediately) {
      _removeEntry();
      return;
    }
    _controller.reverse();
  }

  bool ensureTooltipVisible() {
    _showTimer?.cancel();
    _showTimer = null;
    if (_entry != null) {
      // Stop trying to hide, if we were.
      _hideTimer?.cancel();
      _hideTimer = null;
      _controller.forward();
      return false; // Already visible.
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  void _createNewEntry() {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final RenderBox box = context.findRenderObject()! as RenderBox;
    Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );
    if (_mouseIsConnected && widget.useMousePosition && mousePosition != null) {
      target = mousePosition!;
    }

    final message = DefaultTextStyle(
      style: textStyle,
      child: Text.rich(
        widget.message,
        overflow: TextOverflow.ellipsis,
        softWrap: widget.softWrap,
      ),
    );

    final Widget overlay = Directionality(
      textDirection: Directionality.of(context),
      child: _TooltipOverlay(
        message: message,
        height: minHeight,
        padding: padding,
        margin: margin,
        decoration: decoration,
        textStyle: textStyle,
        animation: CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
        ),
        target: target,
        verticalOffset: verticalOffset,
        preferBelow: preferBelow,
      ),
    );
    _entry = OverlayEntry(builder: (BuildContext context) => overlay);
    overlayState.insert(_entry!);
  }

  void _removeEntry() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    _entry?.remove();
    _entry = null;
  }

  // Forces a rebuild if a mouse has been added or removed.
  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }
    final bool mouseIsConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;

    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status.isDismissed) {
      _hide(hideImmediately: true);
    }
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) {
      return;
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _hide();
    } else if (event is PointerDownEvent) {
      _hide(hideImmediately: true);
    }
  }

  @override
  void deactivate() {
    if (_entry != null) {
      _hide(hideImmediately: true);
    }
    _showTimer?.cancel();
    super.deactivate();
    super.deactivate();
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
    RendererBinding.instance.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    if (_entry != null) _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    Widget result =
        Consumer<MainWindowModel>(builder: (context, isMainWindow, _) {
      return widget.child;
    });

    if (_mouseIsConnected) {
      result = MouseRegion(
        onEnter: (PointerEnterEvent event) => _show(),
        onExit: (PointerExitEvent event) => _hide(),
        onHover: (PointerHoverEvent event) {
          mousePosition = event.position;
        },
        child: result,
      );
    }

    return result;
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.message,
    required this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.textStyle,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  final DefaultTextStyle message;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Animation<double> animation;
  final Offset target;
  final double verticalOffset;
  final bool preferBelow;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _TooltipPositionDelegate(
            target: target,
            verticalOffset: verticalOffset,
            preferBelow: preferBelow,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Container(
                decoration: decoration,
                padding: padding,
                margin: margin,
                child: Center(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: message,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  const _TooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  final Offset target;
  final double verticalOffset;
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: Offset(target.dx + childSize.width / 2, target.dy),
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}
