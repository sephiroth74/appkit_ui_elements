import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitIconButtonTheme extends InheritedTheme {
  const AppKitIconButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AppKitIconButtonThemeData data;

  static AppKitIconButtonThemeData of(BuildContext context) {
    final AppKitIconButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitIconButtonTheme>();
    return buttonTheme?.data ?? AppKitTheme.of(context).iconButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitIconButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(AppKitIconButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class AppKitIconButtonThemeData with Diagnosticable {
  const AppKitIconButtonThemeData({
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.shape,
    this.borderRadius,
    this.boxConstraints,
    this.padding,
  });

  final Color? backgroundColor;

  final Color? hoverColor;

  final Color? pressedColor;

  final Color? disabledColor;

  final BoxShape? shape;

  final BorderRadius? borderRadius;

  final BoxConstraints? boxConstraints;

  final EdgeInsetsGeometry? padding;

  AppKitIconButtonThemeData copyWith({
    Color? backgroundColor,
    Color? disabledColor,
    Color? hoverColor,
    Color? pressedColor,
    BoxShape? shape,
    BorderRadius? borderRadius,
    BoxConstraints? boxConstraints,
    EdgeInsetsGeometry? padding,
  }) {
    return AppKitIconButtonThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      hoverColor: hoverColor ?? this.hoverColor,
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      boxConstraints: boxConstraints ?? this.boxConstraints,
      padding: padding ?? this.padding,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }

  static AppKitIconButtonThemeData lerp(
    AppKitIconButtonThemeData a,
    AppKitIconButtonThemeData b,
    double t,
  ) {
    return AppKitIconButtonThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      shape: b.shape,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      boxConstraints:
          BoxConstraints.lerp(a.boxConstraints, b.boxConstraints, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      pressedColor: Color.lerp(a.pressedColor, b.pressedColor, t),
    );
  }

  AppKitIconButtonThemeData merge(AppKitIconButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      disabledColor: other.disabledColor,
      hoverColor: other.hoverColor,
      shape: other.shape,
      borderRadius: other.borderRadius,
      boxConstraints: other.boxConstraints,
      padding: other.padding,
      pressedColor: other.pressedColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppKitIconButtonThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor?.value == other.backgroundColor?.value &&
          disabledColor?.value == other.disabledColor?.value &&
          hoverColor?.value == other.hoverColor?.value &&
          shape == other.shape &&
          borderRadius == other.borderRadius &&
          boxConstraints == other.boxConstraints &&
          padding == other.padding &&
          pressedColor?.value == other.pressedColor?.value;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      disabledColor.hashCode ^
      hoverColor.hashCode ^
      shape.hashCode ^
      borderRadius.hashCode ^
      boxConstraints.hashCode ^
      padding.hashCode ^
      pressedColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(EnumProperty<BoxShape?>('shape', shape));
    properties
        .add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(
      DiagnosticsProperty<BoxConstraints?>('boxConstraints', boxConstraints),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding),
    );
    properties.add(ColorProperty('pressedColor', pressedColor));
  }
}
