import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitContextMenuTheme extends InheritedTheme {
  final AppKitContextMenuThemeData data;

  const AppKitContextMenuTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitContextMenuTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitContextMenuTheme(data: data, child: child);
  }

  static AppKitContextMenuThemeData of(BuildContext context) {
    final appKitContextMenuTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitContextMenuTheme>();
    return appKitContextMenuTheme?.data ??
        AppKitTheme.of(context).contextMenuTheme;
  }
}

class AppKitContextMenuThemeData with Diagnosticable {
  final double backgroundBlur;
  final double borderRadius;
  final Color? backgroundColor;

  AppKitContextMenuThemeData({
    required this.backgroundBlur,
    required this.borderRadius,
    this.backgroundColor,
  });

  AppKitContextMenuThemeData copyWith({
    double? backgroundBlur,
    double? borderRadius,
    Color? backgroundColor,
  }) {
    return AppKitContextMenuThemeData(
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('backgroundBlur', backgroundBlur));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }

  static AppKitContextMenuThemeData lerp(
      AppKitContextMenuThemeData a, AppKitContextMenuThemeData b, double t) {
    return AppKitContextMenuThemeData(
      backgroundBlur: lerpDouble(a.backgroundBlur, b.backgroundBlur, t)!,
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    );
  }

  AppKitContextMenuThemeData merge(AppKitContextMenuThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundBlur: other.backgroundBlur,
      borderRadius: other.borderRadius,
      backgroundColor: other.backgroundColor,
    );
  }
}
