import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppKitMeasureSingleChildWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Size>? onSizeChanged;
  final ValueChanged<Rect>? onLayout;

  const AppKitMeasureSingleChildWidget({
    super.key,
    super.child,
    this.onSizeChanged,
    this.onLayout,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout, onSizeChanged);
  }

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _RenderMenuItem renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, this.onSizeChanged, [RenderBox? child])
      : super(child);

  ValueChanged<Rect>? onLayout;
  ValueChanged<Size>? onSizeChanged;

  @override
  void performLayout() {
    super.performLayout();
    onSizeChanged?.call(size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    onLayout?.call(offset & size);
  }
}
