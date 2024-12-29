import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitButtonTheme extends InheritedTheme {
  final AppKitButtonThemeData data;

  const AppKitButtonTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppKitButtonTheme && data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitButtonTheme(data: data, child: child);
  }

  static AppKitButtonThemeData of(BuildContext context) {
    final AppKitButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitButtonTheme>();
    return buttonTheme?.data ?? AppKitTheme.of(context).buttonTheme;
  }
}

class AppKitButtonThemeData with Diagnosticable {
  final AppKitMaterialButtonThemeData material;

  AppKitButtonThemeData({required this.material});

  AppKitButtonThemeData copyWith({AppKitMaterialButtonThemeData? material}) {
    return AppKitButtonThemeData(material: material ?? this.material);
  }

  AppKitButtonThemeData merge(AppKitButtonThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(material: other.material);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppKitMaterialButtonThemeData>(
        'material', material));
  }

  static AppKitButtonThemeData lerp(
      AppKitButtonThemeData? a, AppKitButtonThemeData? b, double t) {
    return AppKitButtonThemeData(
      material: AppKitMaterialButtonThemeData.lerp(a?.material, b?.material, t),
    );
  }
}

abstract class AppKitButtonThemeBaseData with Diagnosticable {
  final Color? accentColor;
  final Color controlBackgroundColorDisabled;

  AppKitButtonThemeBaseData({
    required this.controlBackgroundColorDisabled,
    this.accentColor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('accentColor', accentColor));
    properties.add(ColorProperty(
        'controlBackgroundColorDisabled', controlBackgroundColorDisabled));
  }
}

class AppKitMaterialButtonThemeData extends AppKitButtonThemeBaseData {
  AppKitMaterialButtonThemeData({
    required super.controlBackgroundColorDisabled,
    super.accentColor,
  });

  static AppKitMaterialButtonThemeData lerp(AppKitMaterialButtonThemeData? a,
      AppKitMaterialButtonThemeData? b, double t) {
    return AppKitMaterialButtonThemeData(
      accentColor: Color.lerp(a?.accentColor, b?.accentColor, t),
      controlBackgroundColorDisabled: Color.lerp(
          a?.controlBackgroundColorDisabled,
          b?.controlBackgroundColorDisabled,
          t)!,
    );
  }
}
