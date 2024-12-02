import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppKitPushButtonTheme extends InheritedTheme {
  const AppKitPushButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AppKitPushButtonThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitPushButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(covariant AppKitPushButtonTheme oldWidget) {
    return data != oldWidget.data;
  }

  static AppKitPushButtonThemeData of(BuildContext context) {
    final AppKitPushButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitPushButtonTheme>();
    return buttonTheme?.data ?? AppKitTheme.of(context).pushButtonTheme;
  }
}

class AppKitPushButtonThemeData with Diagnosticable {
  final CupertinoDynamicColor destructiveTextColor;
  final Map<AppKitControlSize, double> buttonRadius;
  final Map<AppKitControlSize, EdgeInsets> buttonPadding;
  final Map<AppKitControlSize, double> fontSize;
  final Map<AppKitControlSize, Size> buttonSize;
  final CupertinoDynamicColor overlayPressedColor;

  const AppKitPushButtonThemeData({
    required this.destructiveTextColor,
    required this.buttonRadius,
    required this.buttonPadding,
    required this.fontSize,
    required this.buttonSize,
    required this.overlayPressedColor,
  });

  AppKitPushButtonThemeData copyWith({
    BoxBorder? secondaryBorder,
    Map<AppKitControlSize, double>? buttonRadius,
    Map<AppKitControlSize, EdgeInsets>? buttonPadding,
    Map<AppKitControlSize, double>? fontSize,
    Map<AppKitControlSize, Size>? buttonSize,
    CupertinoDynamicColor? textColor,
    CupertinoDynamicColor? destructiveTextColor,
    CupertinoDynamicColor? overlayPressedColor,
  }) {
    return AppKitPushButtonThemeData(
      destructiveTextColor: destructiveTextColor ?? this.destructiveTextColor,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      fontSize: fontSize ?? this.fontSize,
      buttonSize: buttonSize ?? this.buttonSize,
      overlayPressedColor: overlayPressedColor ?? this.overlayPressedColor,
    );
  }

  AppKitPushButtonThemeData merge(AppKitPushButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      buttonRadius: other.buttonRadius,
      buttonPadding: other.buttonPadding,
      fontSize: other.fontSize,
      buttonSize: other.buttonSize,
      overlayPressedColor: other.overlayPressedColor,
    );
  }

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
    properties.add(DiagnosticsProperty<CupertinoDynamicColor>(
        'destructiveTextColor', destructiveTextColor));
    properties.add(ColorProperty('overlayPressedColor', overlayPressedColor));
  }

  static AppKitPushButtonThemeData lerp(
      AppKitPushButtonThemeData a, AppKitPushButtonThemeData b, double t) {
    return AppKitPushButtonThemeData(
      destructiveTextColor: CupertinoDynamicColor.withBrightness(
        color: Color.lerp(
            a.destructiveTextColor.color, b.destructiveTextColor.color, t)!,
        darkColor: Color.lerp(a.destructiveTextColor.darkColor,
            b.destructiveTextColor.darkColor, t)!,
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
