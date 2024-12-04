import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitComboButtonTheme extends InheritedTheme {
  final AppKitComboButtonThemeData data;

  const AppKitComboButtonTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppKitComboButtonTheme && data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitComboButtonTheme(data: data, child: child);
  }

  static AppKitComboButtonThemeData of(BuildContext context) {
    final AppKitComboButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitComboButtonTheme>();
    return buttonTheme?.data ?? AppKitTheme.of(context).comboButtonTheme;
  }
}

class AppKitComboButtonThemeData with Diagnosticable {
  final Map<AppKitControlSize, AppKitComboButtonThemeDataSize> dataMap;

  AppKitComboButtonThemeData({
    required this.dataMap,
  });

  AppKitComboButtonThemeDataSize get(AppKitControlSize size) {
    return dataMap[size]!;
  }

  static AppKitComboButtonThemeData fallback(
      {required Brightness brightness, required AppKitTypography typography}) {
    return AppKitComboButtonThemeData(
      dataMap: {
        AppKitControlSize.mini: AppKitComboButtonThemeDataSize(
          buttonSize: const Size(29.0, 15.0),
          borderRadius: 3.0,
          padding: const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 0.0),
          fontSize: 9.0,
        ),
        AppKitControlSize.small: AppKitComboButtonThemeDataSize(
          buttonSize: const Size(46.0, 18.0),
          borderRadius: 4.0,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0),
          fontSize: 10.0,
        ),
        AppKitControlSize.regular: AppKitComboButtonThemeDataSize(
          buttonSize: const Size(48, 22),
          borderRadius: 6.0,
          padding: const EdgeInsets.only(left: 9.0, right: 9.0, bottom: 2.0),
          fontSize: 13,
        ),
        AppKitControlSize.large: AppKitComboButtonThemeDataSize(
          buttonSize: const Size(58.0, 30.0),
          borderRadius: 7.0,
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 4.0, top: 2.0),
          fontSize: 14.0,
        ),
      },
    );
  }

  AppKitComboButtonThemeData copyWith({
    Map<AppKitControlSize, AppKitComboButtonThemeDataSize>? dataMap,
  }) {
    return AppKitComboButtonThemeData(
      dataMap: dataMap ?? this.dataMap,
    );
  }

  AppKitComboButtonThemeData merge(AppKitComboButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      dataMap: Map.of(dataMap)
        ..addAll(other.dataMap)
        ..removeWhere((key, value) => other.dataMap[key] == null),
    );
  }

  static AppKitComboButtonThemeData lerp(
    AppKitComboButtonThemeData? a,
    AppKitComboButtonThemeData? b,
    double t,
  ) {
    return AppKitComboButtonThemeData(
      dataMap: Map.fromEntries(
        a!.dataMap.entries.map(
          (entry) {
            return MapEntry(
              entry.key,
              AppKitComboButtonThemeDataSize.lerp(
                  entry.value, b!.dataMap[entry.key], t),
            );
          },
        ),
      ),
    );
  }
}

class AppKitComboButtonThemeDataSize with Diagnosticable {
  final Size buttonSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  AppKitComboButtonThemeDataSize({
    required this.buttonSize,
    required this.borderRadius,
    required this.padding,
    required this.fontSize,
  });

  AppKitComboButtonThemeDataSize copyWith({
    Size? buttonSize,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
  }) {
    return AppKitComboButtonThemeDataSize(
      buttonSize: buttonSize ?? this.buttonSize,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  AppKitComboButtonThemeDataSize merge(AppKitComboButtonThemeDataSize? other) {
    if (other == null) return this;
    return copyWith(
      buttonSize: other.buttonSize,
      borderRadius: other.borderRadius,
      padding: other.padding,
      fontSize: other.fontSize,
    );
  }

  static AppKitComboButtonThemeDataSize lerp(
    AppKitComboButtonThemeDataSize? a,
    AppKitComboButtonThemeDataSize? b,
    double t,
  ) {
    return AppKitComboButtonThemeDataSize(
      buttonSize: Size.lerp(a?.buttonSize, b?.buttonSize, t)!,
      borderRadius: lerpDouble(a?.borderRadius, b?.borderRadius, t)!,
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t)!,
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('buttonSize', buttonSize));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DoubleProperty('fontSize', fontSize));
  }
}
