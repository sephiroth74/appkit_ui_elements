import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/controls/popup_button.dart';
import 'package:flutter/material.dart';

class AppKitMeasureSingleChildWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onLayout;

  const AppKitMeasureSingleChildWidget({
    super.key,
    super.child,
    required this.onLayout,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}
