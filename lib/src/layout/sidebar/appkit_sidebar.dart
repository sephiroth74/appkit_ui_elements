import 'package:flutter/widgets.dart';

class AppKitSidebar {
  const AppKitSidebar({
    required this.builder,
    required this.minWidth,
    this.key,
    this.decoration,
    this.isResizable = true,
    this.dragClosed = true,
    double? dragClosedBuffer,
    this.snapToStartBuffer,
    this.maxWidth = 400.0,
    this.startWidth,
    this.padding = EdgeInsets.zero,
    this.windowBreakpoint = 556.0,
    this.top,
    this.bottom,
    this.topOffset = 51.0,
    this.shownByDefault = true,
  }) : dragClosedBuffer = dragClosedBuffer ?? minWidth / 2;

  final ScrollableWidgetBuilder builder;
  final BoxDecoration? decoration;
  final bool? isResizable;
  final bool dragClosed;
  final double dragClosedBuffer;
  final double? snapToStartBuffer;
  final Key? key;
  final double? maxWidth;
  final double minWidth;
  final double? startWidth;
  final EdgeInsets padding;
  final double windowBreakpoint;
  final Widget? top;
  final Widget? bottom;
  final double topOffset;
  final bool shownByDefault;
}
