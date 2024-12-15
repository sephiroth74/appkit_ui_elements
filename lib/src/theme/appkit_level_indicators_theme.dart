import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitLevelIndicatorsTheme extends InheritedTheme {
  final AppKitLevelIndicatorsThemeData data;

  const AppKitLevelIndicatorsTheme(
      {super.key, required super.child, required this.data});

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitLevelIndicatorsTheme(data: data, child: child);
  }

  static AppKitLevelIndicatorsThemeData of(BuildContext context) {
    final AppKitLevelIndicatorsTheme? theme = context
        .dependOnInheritedWidgetOfExactType<AppKitLevelIndicatorsTheme>();
    return theme?.data ?? AppKitTheme.of(context).levelIndicatorsTheme;
  }

  @override
  bool updateShouldNotify(covariant AppKitLevelIndicatorsTheme oldWidget) {
    return oldWidget.data != data;
  }
}

class AppKitLevelIndicatorsThemeData with Diagnosticable {
  final Color normalColor;
  final Color warningColor;
  final Color criticalColor;
  final Color strokeColor;
  final Color backgroundColor;
  final double borderRadius;

  AppKitLevelIndicatorsThemeData({
    required this.normalColor,
    required this.warningColor,
    required this.criticalColor,
    required this.strokeColor,
    required this.backgroundColor,
    required this.borderRadius,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('normalColor', normalColor));
    properties.add(ColorProperty('warningColor', warningColor));
    properties.add(ColorProperty('criticalColor', criticalColor));
    properties.add(ColorProperty('strokeColor', strokeColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('borderRadius', borderRadius));
  }

  AppKitLevelIndicatorsThemeData copyWith({
    Color? normalColor,
    Color? warningColor,
    Color? criticalColor,
    Color? strokeColor,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    return AppKitLevelIndicatorsThemeData(
      normalColor: normalColor ?? this.normalColor,
      warningColor: warningColor ?? this.warningColor,
      criticalColor: criticalColor ?? this.criticalColor,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  static AppKitLevelIndicatorsThemeData lerp(AppKitLevelIndicatorsThemeData? a,
      AppKitLevelIndicatorsThemeData? b, double t) {
    return AppKitLevelIndicatorsThemeData(
      normalColor: Color.lerp(a?.normalColor, b?.normalColor, t)!,
      warningColor: Color.lerp(a?.warningColor, b?.warningColor, t)!,
      criticalColor: Color.lerp(a?.criticalColor, b?.criticalColor, t)!,
      strokeColor: Color.lerp(a?.strokeColor, b?.strokeColor, t)!,
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t)!,
      borderRadius: lerpDouble(a?.borderRadius, b?.borderRadius, t)!,
    );
  }
}
