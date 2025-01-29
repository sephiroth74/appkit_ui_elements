import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  static AppKitIconButtonThemeData lightOpaque() {
    return AppKitIconButtonThemeData(
        outlined: AppKitIconButtonOutlinedThemeData(
          backgroundColor: Colors.transparent,
          disabledColor: const Color(0xffE5E5E5),
          hoverColor: Colors.black.withValues(alpha: 0.05),
          pressedColor: Colors.black.withValues(alpha: 0.2),
          shape: BoxShape.rectangle,
          boxConstraints: const BoxConstraints(
            minHeight: 22,
            minWidth: 22,
            maxWidth: 30,
            maxHeight: 30,
          ),
        ),
        flat: AppKitIconButtonFlatThemeData(
          disabledColor: AppKitColors.disabledControlTextColor.color,
          hoverColor: AppKitColors.white.withValues(alpha: 0.4),
          pressedColor: AppKitColors.labelColor.color,
          boxConstraints: const BoxConstraints(
            minHeight: 22,
            minWidth: 22,
            maxWidth: 30,
            maxHeight: 30,
          ),
        ));
  }

  static AppKitIconButtonThemeData darkOpaque() {
    return AppKitIconButtonThemeData(
        outlined: AppKitIconButtonOutlinedThemeData(
          backgroundColor: Colors.transparent,
          disabledColor: const Color(0xff353535),
          hoverColor: Colors.white.withValues(alpha: 0.06),
          pressedColor: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.rectangle,
          boxConstraints: const BoxConstraints(
            minHeight: 22,
            minWidth: 22,
            maxWidth: 30,
            maxHeight: 30,
          ),
        ),
        flat: AppKitIconButtonFlatThemeData(
          disabledColor: AppKitColors.disabledControlTextColor.darkColor,
          hoverColor: AppKitColors.black.withValues(alpha: 0.2),
          pressedColor:
              AppKitColors.labelColor.darkColor.withValues(alpha: 0.5),
          boxConstraints: const BoxConstraints(
            minHeight: 22,
            minWidth: 22,
            maxWidth: 30,
            maxHeight: 30,
          ),
        ));
  }

  static AppKitIconButtonThemeData fallback(Brightness brightness) {
    return brightness == Brightness.light ? lightOpaque() : darkOpaque();
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
  final AppKitIconButtonOutlinedThemeData outlined;
  final AppKitIconButtonFlatThemeData flat;

  AppKitIconButtonThemeData({required this.outlined, required this.flat});

  AppKitIconButtonThemeData copyWith({
    AppKitIconButtonOutlinedThemeData? outlined,
    AppKitIconButtonFlatThemeData? flat,
  }) {
    return AppKitIconButtonThemeData(
      outlined: outlined ?? this.outlined,
      flat: flat ?? this.flat,
    );
  }

  static AppKitIconButtonThemeData lerp(
    AppKitIconButtonThemeData a,
    AppKitIconButtonThemeData b,
    double t,
  ) {
    return AppKitIconButtonThemeData(
      outlined:
          AppKitIconButtonOutlinedThemeData.lerp(a.outlined, b.outlined, t),
      flat: AppKitIconButtonFlatThemeData.lerp(a.flat, b.flat, t),
    );
  }

  AppKitIconButtonThemeData merge(AppKitIconButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      outlined: other.outlined,
      flat: other.flat,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppKitIconButtonThemeData &&
          runtimeType == other.runtimeType &&
          outlined == other.outlined &&
          flat == other.flat;

  @override
  int get hashCode => outlined.hashCode ^ flat.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppKitIconButtonOutlinedThemeData>(
        'outlined', outlined));
    properties
        .add(DiagnosticsProperty<AppKitIconButtonFlatThemeData>('flat', flat));
  }
}

class AppKitIconButtonFlatThemeData with Diagnosticable {
  const AppKitIconButtonFlatThemeData({
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.borderRadius,
    this.boxConstraints,
    this.padding,
  });

  final Color? hoverColor;

  final Color? pressedColor;

  final Color? disabledColor;

  final BorderRadius? borderRadius;

  final BoxConstraints? boxConstraints;

  final EdgeInsetsGeometry? padding;

  AppKitIconButtonFlatThemeData copyWith({
    Color? backgroundColor,
    Color? disabledColor,
    Color? hoverColor,
    Color? pressedColor,
    BoxShape? shape,
    BorderRadius? borderRadius,
    BoxConstraints? boxConstraints,
    EdgeInsetsGeometry? padding,
  }) {
    return AppKitIconButtonFlatThemeData(
      disabledColor: disabledColor ?? this.disabledColor,
      hoverColor: hoverColor ?? this.hoverColor,
      borderRadius: borderRadius ?? this.borderRadius,
      boxConstraints: boxConstraints ?? this.boxConstraints,
      padding: padding ?? this.padding,
      pressedColor: pressedColor ?? this.pressedColor,
    );
  }

  static AppKitIconButtonFlatThemeData lerp(
    AppKitIconButtonFlatThemeData a,
    AppKitIconButtonFlatThemeData b,
    double t,
  ) {
    return AppKitIconButtonFlatThemeData(
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      boxConstraints:
          BoxConstraints.lerp(a.boxConstraints, b.boxConstraints, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      pressedColor: Color.lerp(a.pressedColor, b.pressedColor, t),
    );
  }

  AppKitIconButtonFlatThemeData merge(AppKitIconButtonFlatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      disabledColor: other.disabledColor,
      hoverColor: other.hoverColor,
      borderRadius: other.borderRadius,
      boxConstraints: other.boxConstraints,
      padding: other.padding,
      pressedColor: other.pressedColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppKitIconButtonFlatThemeData &&
          runtimeType == other.runtimeType &&
          disabledColor == other.disabledColor &&
          hoverColor == other.hoverColor &&
          borderRadius == other.borderRadius &&
          boxConstraints == other.boxConstraints &&
          padding == other.padding &&
          pressedColor == other.pressedColor;

  @override
  int get hashCode =>
      disabledColor.hashCode ^
      hoverColor.hashCode ^
      borderRadius.hashCode ^
      boxConstraints.hashCode ^
      padding.hashCode ^
      pressedColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
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

class AppKitIconButtonOutlinedThemeData with Diagnosticable {
  const AppKitIconButtonOutlinedThemeData({
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

  AppKitIconButtonOutlinedThemeData copyWith({
    Color? backgroundColor,
    Color? disabledColor,
    Color? hoverColor,
    Color? pressedColor,
    BoxShape? shape,
    BorderRadius? borderRadius,
    BoxConstraints? boxConstraints,
    EdgeInsetsGeometry? padding,
  }) {
    return AppKitIconButtonOutlinedThemeData(
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

  static AppKitIconButtonOutlinedThemeData lerp(
    AppKitIconButtonOutlinedThemeData a,
    AppKitIconButtonOutlinedThemeData b,
    double t,
  ) {
    return AppKitIconButtonOutlinedThemeData(
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

  AppKitIconButtonOutlinedThemeData merge(
      AppKitIconButtonOutlinedThemeData? other) {
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
      other is AppKitIconButtonOutlinedThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          disabledColor == other.disabledColor &&
          hoverColor == other.hoverColor &&
          shape == other.shape &&
          borderRadius == other.borderRadius &&
          boxConstraints == other.boxConstraints &&
          padding == other.padding &&
          pressedColor == other.pressedColor;

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
