import 'dart:math' as math show max, min;

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/services.dart' show SystemMouseCursor;

const EdgeInsets kResizablePaneSafeArea = EdgeInsets.only(top: 52);
const double _kResizeThresholdSize = 6.0;

class AppKitResizablePane extends StatefulWidget {
  const AppKitResizablePane({
    super.key,
    required ScrollableWidgetBuilder this.builder,
    this.decoration,
    this.maxSize = 500.0,
    required this.minSize,
    this.isResizable = true,
    required this.resizableSide,
    this.windowBreakpoint,
    required this.startSize,
  })  : child = null,
        useScrollBar = true,
        assert(
          maxSize >= minSize,
          'minSize should not be more than maxSize.',
        ),
        assert(
          (startSize >= minSize) && (startSize <= maxSize),
          'startSize must not be less than minSize or more than maxWidth',
        );

  const AppKitResizablePane.noScrollBar({
    super.key,
    required Widget this.child,
    this.decoration,
    this.maxSize = 500.0,
    required this.minSize,
    this.isResizable = true,
    required this.resizableSide,
    this.windowBreakpoint,
    required this.startSize,
  })  : builder = null,
        useScrollBar = false,
        assert(
          maxSize >= minSize,
          'minSize should not be more than maxSize.',
        ),
        assert(
          (startSize >= minSize) && (startSize <= maxSize),
          'startSize must not be less than minSize or more than maxWidth',
        );

  final ScrollableWidgetBuilder? builder;

  final Widget? child;

  final bool useScrollBar;

  final BoxDecoration? decoration;

  final bool isResizable;

  final double maxSize;

  final double minSize;

  final double startSize;

  final AppKitResizableSide resizableSide;

  final double? windowBreakpoint;

  @override
  State<AppKitResizablePane> createState() => _AppKitResizablePaneState();
}

class _AppKitResizablePaneState extends State<AppKitResizablePane> {
  late SystemMouseCursor _cursor;
  final _scrollController = ScrollController();
  late double _size;
  late double _dragStartSize;
  late double _dragStartPosition;

  Color get _dividerColor => AppKitTheme.of(context).dividerColor;

  bool get _resizeOnRight => widget.resizableSide == AppKitResizableSide.right;

  bool get _resizeOnTop => widget.resizableSide == AppKitResizableSide.top;

  BoxDecoration get _decoration {
    final borderSide = BorderSide(color: _dividerColor);
    final right = Border(right: borderSide);
    final left = Border(left: borderSide);
    final top = Border(top: borderSide);
    return BoxDecoration(
      border: _resizeOnTop ? top : (_resizeOnRight ? right : left),
    ).copyWith(
      color: widget.decoration?.color,
      border: widget.decoration?.border,
      borderRadius: widget.decoration?.borderRadius,
      boxShadow: widget.decoration?.boxShadow,
      backgroundBlendMode: widget.decoration?.backgroundBlendMode,
      gradient: widget.decoration?.gradient,
      image: widget.decoration?.image,
      shape: widget.decoration?.shape,
    );
  }

  BoxConstraints get _boxConstraint {
    if (_resizeOnTop) {
      return BoxConstraints(
        maxHeight: widget.maxSize,
        minHeight: widget.minSize,
      ).normalize();
    }
    return BoxConstraints(
      maxWidth: widget.maxSize,
      minWidth: widget.minSize,
    ).normalize();
  }

  Widget get _resizeArea {
    return _resizeOnTop
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: _cursor,
              child: const SizedBox(width: _kResizeThresholdSize),
            ),
            onVerticalDragStart: (details) {
              _dragStartSize = _size;
              _dragStartPosition = details.globalPosition.dy;
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                final newHeight = _dragStartSize +
                    (_dragStartPosition - details.globalPosition.dy);
                _size = math.max(
                  widget.minSize,
                  math.min(
                    widget.maxSize,
                    newHeight,
                  ),
                );
                if (_size == widget.minSize) {
                  _cursor = SystemMouseCursors.resizeUp;
                } else if (_size == widget.maxSize) {
                  _cursor = SystemMouseCursors.resizeDown;
                } else {
                  _cursor = SystemMouseCursors.resizeRow;
                }
              });
            },
          )
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: _cursor,
              child: const SizedBox(width: _kResizeThresholdSize),
            ),
            onHorizontalDragStart: (details) {
              _dragStartSize = _size;
              _dragStartPosition = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                final newWidth = _resizeOnRight
                    ? _dragStartSize -
                        (_dragStartPosition - details.globalPosition.dx)
                    : _dragStartSize +
                        (_dragStartPosition - details.globalPosition.dx);
                _size = math.max(
                  widget.minSize,
                  math.min(
                    widget.maxSize,
                    newWidth,
                  ),
                );
                if (_size == widget.minSize) {
                  _cursor = _resizeOnRight
                      ? SystemMouseCursors.resizeRight
                      : SystemMouseCursors.resizeLeft;
                } else if (_size == widget.maxSize) {
                  _cursor = _resizeOnRight
                      ? SystemMouseCursors.resizeLeft
                      : SystemMouseCursors.resizeRight;
                } else {
                  _cursor = SystemMouseCursors.resizeColumn;
                }
              });
            },
          );
  }

  @override
  void initState() {
    super.initState();
    _cursor = _resizeOnTop
        ? SystemMouseCursors.resizeRow
        : SystemMouseCursors.resizeColumn;
    _size = widget.startSize;
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant AppKitResizablePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.windowBreakpoint != widget.windowBreakpoint ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize ||
        oldWidget.resizableSide != widget.resizableSide) {
      if (widget.minSize > _size) _size = widget.minSize;
      if (widget.maxSize < _size) _size = widget.maxSize;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height;
    final maxWidth = media.size.width;

    if (_resizeOnTop) {
      if (widget.windowBreakpoint != null &&
          maxHeight <= widget.windowBreakpoint!) {
        return const SizedBox.shrink();
      }
    } else {
      if (widget.windowBreakpoint != null &&
          maxWidth <= widget.windowBreakpoint!) {
        return const SizedBox.shrink();
      }
    }

    return Container(
      width: _resizeOnTop ? maxWidth : _size,
      height: _resizeOnTop ? _size : maxHeight,
      decoration: _decoration,
      constraints: _boxConstraint,
      child: Stack(
        children: [
          SafeArea(
            left: false,
            right: false,
            child: widget.useScrollBar
                ? AppKitScrollbar(
                    controller: _scrollController,
                    child: widget.builder!(context, _scrollController),
                  )
                : widget.child!,
          ),
          if (widget.isResizable && !_resizeOnRight && !_resizeOnTop)
            Positioned(
              left: 0,
              width: _kResizeThresholdSize,
              height: maxHeight,
              child: _resizeArea,
            ),
          if (widget.isResizable && _resizeOnRight)
            Positioned(
              right: 0,
              width: _kResizeThresholdSize,
              height: maxHeight,
              child: _resizeArea,
            ),
          if (widget.isResizable && _resizeOnTop)
            Positioned(
              top: 0,
              width: maxWidth,
              height: _kResizeThresholdSize,
              child: _resizeArea,
            ),
        ],
      ),
    );
  }
}
