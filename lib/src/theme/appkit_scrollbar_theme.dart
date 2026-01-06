import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitScrollbarTheme extends InheritedWidget {
  const AppKitScrollbarTheme({super.key, required this.data, required super.child});

  final AppKitScrollbarThemeData data;

  static AppKitScrollbarThemeData of(BuildContext context) {
    final AppKitScrollbarTheme? scrollbarTheme = context.dependOnInheritedWidgetOfExactType<AppKitScrollbarTheme>();
    return scrollbarTheme?.data ?? AppKitTheme.of(context).scrollbarTheme;
  }

  @override
  bool updateShouldNotify(AppKitScrollbarTheme oldWidget) => data != oldWidget.data;
}

class AppKitScrollbarThemeData with Diagnosticable {
  const AppKitScrollbarThemeData({
    this.thickness,
    this.thicknessWhileHovering,
    this.thumbVisibility,
    this.radius,
    this.thumbColor,
  });

  final double? thickness;

  final double? thicknessWhileHovering;

  final bool? thumbVisibility;

  final Radius? radius;

  final Color? thumbColor;

  AppKitScrollbarThemeData copyWith({
    double? thickness,
    double? thicknessWhileHovering,
    bool? showTrackOnHover,
    bool? thumbVisibility,
    Radius? radius,
    Color? thumbColor,
  }) {
    return AppKitScrollbarThemeData(
      thickness: thickness ?? this.thickness,
      thicknessWhileHovering: thicknessWhileHovering ?? this.thicknessWhileHovering,
      thumbVisibility: thumbVisibility ?? this.thumbVisibility,
      radius: radius ?? this.radius,
      thumbColor: thumbColor ?? this.thumbColor,
    );
  }

  static AppKitScrollbarThemeData lerp(AppKitScrollbarThemeData? a, AppKitScrollbarThemeData? b, double t) {
    return AppKitScrollbarThemeData(
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      thicknessWhileHovering: lerpDouble(a?.thicknessWhileHovering, b?.thicknessWhileHovering, t),
      thumbVisibility: t < 0.5 ? a?.thumbVisibility : b?.thumbVisibility,
      radius: Radius.lerp(a?.radius, b?.radius, t),
      thumbColor: Color.lerp(a?.thumbColor, b?.thumbColor, t),
    );
  }

  /// Merges this [AppKitScrollbarThemeData] with another.
  AppKitScrollbarThemeData merge(AppKitScrollbarThemeData? other) {
    if (other == null) return this;
    return copyWith(
      thickness: other.thickness,
      thumbVisibility: other.thumbVisibility,
      radius: other.radius,
      thumbColor: other.thumbColor,
    );
  }

  @override
  int get hashCode {
    return Object.hash(thickness, thicknessWhileHovering, thumbVisibility, radius, thumbColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AppKitScrollbarThemeData &&
        other.thickness == thickness &&
        other.thicknessWhileHovering == thicknessWhileHovering &&
        other.thumbVisibility == thumbVisibility &&
        other.radius == radius &&
        other.thumbColor == thumbColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double?>('thickness', thickness, defaultValue: null));
    properties.add(DiagnosticsProperty<double?>('thicknessWhileHovering', thicknessWhileHovering, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('thumbVisibility', thumbVisibility, defaultValue: null));
    properties.add(DiagnosticsProperty<Radius>('radius', radius, defaultValue: null));
    properties.add(ColorProperty('thumbColor', thumbColor, defaultValue: null));
  }
}
