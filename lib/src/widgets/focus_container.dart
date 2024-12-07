import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/semantics.dart';

const _kFocusRingSize = 15.0;
const _kFocusRingSizeEnd = 3.0;
const _kFocusAnimationDuration = 150;

final _logger = newLogger('AppKitFocusContainer');

class AppKitFocusContainer extends StatefulWidget {
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final double focusRingSize;
  final bool enabled;
  final SemanticsProperties semanticsProperties;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;

  AppKitFocusContainer({
    super.key,
    required this.child,
    required this.borderRadius,
    this.focusNode,
    this.focusRingSize = _kFocusRingSizeEnd,
    this.canRequestFocus = true,
    this.enabled = true,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    String? label,
    bool? checked,
    bool? mixed,
    bool? selected,
    bool? toggled,
    bool? button,
    bool? slider,
    bool? textField,
    bool? readOnly,
  }) : semanticsProperties = SemanticsProperties(
          label: label,
          enabled: enabled,
          checked: checked,
          mixed: mixed,
          selected: selected,
          toggled: toggled,
          button: button,
          slider: slider,
          textField: textField,
          readOnly: readOnly,
        );

  @override
  State<AppKitFocusContainer> createState() => _AppKitFocusContainerState();
}

class _AppKitFocusContainerState extends State<AppKitFocusContainer>
    with SingleTickerProviderStateMixin {
  FocusNode? _focusNode;

  late bool _isMainWindow;

  late bool _isFocused;

  late AnimationController _animationController;

  late Tween<double> _sizeTween;

  late Tween<double> _alphaTween;

  late Animation<double> _sizeAnimation;

  late Animation<double> _alphaAnimation;

  late StreamSubscription<bool> _mainWindowListener;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ??
      (_focusNode ??= FocusNode()..canRequestFocus = widget.canRequestFocus);

  bool get enabled => _effectiveFocusNode.canRequestFocus && widget.enabled;

  @override
  void initState() {
    super.initState();

    // _effectiveFocusNode.canRequestFocus = widget.canRequestFocus;
    if (enabled) {
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }

    _mainWindowListener = MainWindowStateListener.instance.isMainWindow
        .listen((value) => _handleFocusChanged());
    _isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
    _isFocused = _effectiveFocusNode.hasPrimaryFocus;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: _kFocusAnimationDuration),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _sizeTween = Tween<double>(begin: 0.0, end: 0.0);
    _alphaTween = Tween<double>(begin: 0.0, end: 0.0);

    _sizeAnimation = _sizeTween.animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic)));

    _alphaAnimation = _alphaTween.animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    _mainWindowListener.cancel();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitFocusContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      // (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      // (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);

      _effectiveFocusNode.removeListener(_handleFocusChanged);
      if (enabled) _effectiveFocusNode.addListener(_handleFocusChanged);
    }
    // _effectiveFocusNode.canRequestFocus = widget.canRequestFocus;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = widget.canRequestFocus;
  }

  void _handleFocusChanged() {
    if (!mounted) return;

    final bool isFocused =
        _effectiveFocusNode.hasFocus && _effectiveFocusNode.hasPrimaryFocus;

    final bool isMainWindow =
        MainWindowStateListener.instance.isMainWindow.value;

    // _logger.d(
    // 'isFocused: $isFocused, isMainWindow: $isMainWindow, wasFocused: $_isFocused, wasMainWindow: $_isMainWindow');

    if (isFocused != _isFocused || isMainWindow != _isMainWindow) {
      final bool mainWindowChanged = isMainWindow != _isMainWindow;

      _isFocused = isFocused;
      _isMainWindow = isMainWindow;

      _animationController.reset();

      _alphaTween.begin = isFocused ? 0.0 : 1.0;
      _alphaTween.end = 1.0;

      _sizeTween.begin =
          isFocused ? widget.focusRingSize + _kFocusRingSize : 0.0;
      _sizeTween.end = isFocused ? widget.focusRingSize : 0.0;

      if (mainWindowChanged) _animationController.value = 1.0;

      _animationController.forward();
      setState(() {});
    }
  }

  void _handleDidGainAccessibilityFocus() {
    if (!_effectiveFocusNode.hasFocus && _effectiveFocusNode.canRequestFocus) {
      _effectiveFocusNode.requestFocus();
    }
  }

  void _handleDidLoseAccessibilityFocus() {
    _effectiveFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsProperties.label,
      enabled: widget.enabled,
      button: widget.semanticsProperties.button,
      textField: widget.semanticsProperties.textField,
      slider: widget.semanticsProperties.slider,
      value: widget.semanticsProperties.value,
      checked: widget.semanticsProperties.checked,
      toggled: widget.semanticsProperties.toggled,
      selected: widget.semanticsProperties.selected,
      readOnly: widget.semanticsProperties.readOnly,
      mixed: widget.semanticsProperties.mixed,
      onFocus: enabled
          ? () {
              if (_effectiveFocusNode.canRequestFocus &&
                  !_effectiveFocusNode.hasFocus) {
                _effectiveFocusNode.requestFocus();
              }
            }
          : () {},
      onDidGainAccessibilityFocus:
          enabled ? _handleDidGainAccessibilityFocus : null,
      onDidLoseAccessibilityFocus:
          enabled ? _handleDidLoseAccessibilityFocus : null,
      child: Builder(builder: (context) {
        if (!enabled) {
          return widget.child;
        }

        final focusRingColor = AppKitColors.focusRingColor
            .resolveFrom(context)
            .multiplyOpacity(_alphaAnimation.value);

        return CustomPaint(
            isComplex: true,
            painter: _FocusRingPainter(
              textDirection: Directionality.of(context),
              focused: _isFocused && _isMainWindow && enabled,
              color: focusRingColor,
              delta: _sizeAnimation.value,
              // radius: widget.borderRadius,
              borderRadius: widget.borderRadius,
            ),
            child: widget.child);
      }),
    );
  }
}

class _FocusRingPainter extends CustomPainter {
  final bool focused;
  final Color color;
  // final double radius;
  final double delta;
  final Paint _paint;
  final BorderRadiusGeometry? borderRadius;
  final TextDirection textDirection;
  final Paint _clearPaint = Paint()..blendMode = BlendMode.clear;

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  _FocusRingPainter({
    required this.focused,
    required this.color,
    required this.delta,
    required this.borderRadius,
    required this.textDirection,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (!focused) {
      return;
    }

    // create the rect with the border radius
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius?.resolve(textDirection).toRRect(rect) ??
        RRect.fromRectAndRadius(rect, Radius.zero);

    final inflatedRect = rrect.inflate(delta);

    final saveCount = canvas.getSaveCount();
    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawRRect(inflatedRect, _paint);
    canvas.drawRRect(rrect, _clearPaint);
    canvas.restoreToCount(saveCount);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _FocusRingPainter &&
        (oldDelegate.focused != focused ||
            oldDelegate.color != color ||
            oldDelegate.delta != delta ||
            oldDelegate.borderRadius != borderRadius ||
            oldDelegate.textDirection != textDirection);
  }
}
