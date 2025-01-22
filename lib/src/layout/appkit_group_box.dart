import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that represents a group box in the AppKit UI framework.
///
/// This widget is used to group together other widgets and provide a visual
/// boundary around them. It is typically used to organize related content
/// in a visually distinct manner.
///
/// The [AppKitGroupBox] extends [StatelessWidget], meaning it does not
/// maintain any state of its own.
///
/// Example usage:
///
/// ```dart
/// AppKitGroupBox(
///   child: Column(
///     children: [
///       Text('Item 1'),
///       Text('Item 2'),
///     ],
///   ),
/// )
/// ```
///
/// See also:
///
///  * [Container], which can also be used to group widgets together.
class AppKitGroupBox extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;

  /// The alignment of the transform origin relative to the size of the box.
  ///
  /// This property is used to define how the transformation should be aligned
  /// within the box. If null, the default alignment is used.
  final AlignmentGeometry? transformAlignment;

  /// Defines how the content should be clipped (or not clipped) when it
  /// overflows the container.
  ///
  /// This property controls the clipping behavior of the widget. It can
  /// be set to one of the values from the [Clip] enum, such as [Clip.none],
  /// [Clip.hardEdge], [Clip.antiAlias], or [Clip.antiAliasWithSaveLayer].
  ///
  /// Example usage:
  /// ```dart
  /// AppKitGroupBox(
  ///   clipBehavior: Clip.hardEdge,
  ///   // other properties
  /// )
  /// ```
  ///
  /// Defaults to [Clip.none] if not specified.
  final Clip clipBehavior;

  /// Indicates whether the group box is enabled or not.
  ///
  /// When set to `true`, the group box is enabled and can interact with the user.
  /// When set to `false`, the group box is disabled and cannot be interacted with.
  final bool enabled;

  /// The style of the AppKitGroupBox.
  ///
  /// This determines the visual appearance of the group box, such as its
  /// border, background, and other stylistic elements.
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
          color:
              AppKitDynamicColor.resolve(context, AppKitColors.separatorColor)
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
        return AppKitDynamicColor.resolve(
            context, AppKitColors.fills.opaque.quaternary);
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
