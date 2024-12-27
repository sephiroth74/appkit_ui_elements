import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppKitGroupBox extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final bool enabled;
  final AppKitGroupBoxStyle style;

  const AppKitGroupBox({
    super.key,
    this.alignment,
    this.padding = const EdgeInsets.all(12.0),
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.enabled = true,
    this.style = AppKitGroupBoxStyle.defaultScrollBox,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      color: _getBackgroundColor(context).multiplyOpacity(enabled ? 1.0 : 0.5),
      padding: padding,
      foregroundDecoration: _getForegroundDecoration(context),
      child: child,
    );
  }

  Decoration? _getForegroundDecoration(BuildContext context) {
    switch (style) {
      default:
        return BoxDecoration(
            borderRadius: _getBorderRadius(), border: _getBorder(context));
    }
  }

  BoxBorder? _getBorder(BuildContext context) {
    switch (style) {
      default:
        return Border.all(
          color: AppKitColors.separatorColor
              .resolveFrom(context)
              .multiplyOpacity(enabled ? 1.0 : 0.5),
          width: 1.0,
        );
    }
  }

  BorderRadiusGeometry? _getBorderRadius() {
    switch (style) {
      case AppKitGroupBoxStyle.defaultScrollBox:
        return BorderRadius.circular(6.0);
      case AppKitGroupBoxStyle.roundedScrollBox:
        return BorderRadius.circular(10.0);
      case AppKitGroupBoxStyle.standardScrollBox:
        return BorderRadius.zero;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (style) {
      case AppKitGroupBoxStyle.defaultScrollBox:
        return AppKitColors.fills.opaque.quaternary.resolveFrom(context);
      case AppKitGroupBoxStyle.roundedScrollBox:
        return Colors.transparent;
      case AppKitGroupBoxStyle.standardScrollBox:
        return Colors.transparent;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitGroupBoxStyle>('style', style));
  }
}
