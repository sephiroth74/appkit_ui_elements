import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppKitToggleButtonTheme extends InheritedTheme {
  const AppKitToggleButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AppKitToggleButtonThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitToggleButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(covariant AppKitToggleButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  static AppKitToggleButtonThemeData of(BuildContext context) {
    final AppKitToggleButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitToggleButtonTheme>();
    return buttonTheme?.data ?? AppKitTheme.of(context).toggleButtonTheme;
  }
}

class AppKitToggleButtonThemeData with Diagnosticable {
  final CupertinoDynamicColor textColor;
  final Map<AppKitControlSize, double> buttonRadius;
  final Map<AppKitControlSize, EdgeInsets> buttonPadding;
  final Map<AppKitControlSize, double> fontSize;
  final Map<AppKitControlSize, Size> buttonSize;
  final CupertinoDynamicColor overlayPressedColor;

  const AppKitToggleButtonThemeData({
    required this.textColor,
    required this.buttonRadius,
    required this.buttonPadding,
    required this.fontSize,
    required this.buttonSize,
    required this.overlayPressedColor,
  });

  AppKitToggleButtonThemeData copyWith({
    BoxBorder? secondaryBorder,
    Map<AppKitControlSize, double>? buttonRadius,
    Map<AppKitControlSize, EdgeInsets>? buttonPadding,
    Map<AppKitControlSize, double>? fontSize,
    Map<AppKitControlSize, Size>? buttonSize,
    CupertinoDynamicColor? textColor,
    CupertinoDynamicColor? overlayPressedColor,
  }) {
    return AppKitToggleButtonThemeData(
      textColor: textColor ?? this.textColor,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      fontSize: fontSize ?? this.fontSize,
      buttonSize: buttonSize ?? this.buttonSize,
      overlayPressedColor: overlayPressedColor ?? this.overlayPressedColor,
    );
  }

  AppKitToggleButtonThemeData merge(AppKitToggleButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      textColor: other.textColor,
      buttonRadius: other.buttonRadius,
      buttonPadding: other.buttonPadding,
      fontSize: other.fontSize,
      buttonSize: other.buttonSize,
      overlayPressedColor: other.overlayPressedColor,
    );
  }

  AppKitToggleButtonThemeData.copyFrom(AppKitPushButtonThemeData other)
      : textColor = other.textColor,
        buttonRadius = other.buttonRadius,
        buttonPadding = other.buttonPadding,
        fontSize = other.fontSize,
        buttonSize = other.buttonSize,
        overlayPressedColor = other.overlayPressedColor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<AppKitControlSize, double>>(
        'buttonRadius', buttonRadius));
    properties.add(DiagnosticsProperty<Map<AppKitControlSize, EdgeInsets>>(
        'buttonPadding', buttonPadding));
    properties.add(DiagnosticsProperty<Map<AppKitControlSize, double>>(
        'fontSize', fontSize));
    properties.add(DiagnosticsProperty<Map<AppKitControlSize, Size>>(
        'buttonSize', buttonSize));
    properties.add(
        DiagnosticsProperty<CupertinoDynamicColor>('textColor', textColor));
    properties.add(ColorProperty('overlayPressedColor', overlayPressedColor));
  }

  static AppKitToggleButtonThemeData lerp(
      AppKitToggleButtonThemeData a, AppKitToggleButtonThemeData b, double t) {
    return AppKitToggleButtonThemeData(
      textColor: CupertinoDynamicColor.withBrightness(
        color: Color.lerp(a.textColor.color, b.textColor.color, t)!,
        darkColor: Color.lerp(a.textColor.darkColor, b.textColor.darkColor, t)!,
      ),
      buttonRadius: Map.fromEntries(
        a.buttonRadius.entries.map((entry) {
          return MapEntry(entry.key,
              lerpDouble(entry.value, b.buttonRadius[entry.key], t)!);
        }),
      ),
      buttonPadding: Map.fromEntries(
        a.buttonPadding.entries.map((entry) {
          return MapEntry(entry.key,
              EdgeInsets.lerp(entry.value, b.buttonPadding[entry.key], t)!);
        }),
      ),
      fontSize: Map.fromEntries(
        a.fontSize.entries.map((entry) {
          return MapEntry(
              entry.key, lerpDouble(entry.value, b.fontSize[entry.key], t)!);
        }),
      ),
      buttonSize: Map.fromEntries(
        a.buttonSize.entries.map((entry) {
          return MapEntry(
              entry.key, Size.lerp(entry.value, b.buttonSize[entry.key], t)!);
        }),
      ),
      overlayPressedColor: CupertinoDynamicColor.withBrightness(
        color: Color.lerp(
            a.overlayPressedColor.color, b.overlayPressedColor.color, t)!,
        darkColor: Color.lerp(a.overlayPressedColor.darkColor,
            b.overlayPressedColor.darkColor, t)!,
      ),
    );
  }
}
