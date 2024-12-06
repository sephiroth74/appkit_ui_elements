import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitColorWellTheme extends InheritedTheme {
  final AppKitColorWellThemeData data;

  const AppKitColorWellTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitColorWellTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitColorWellTheme(data: data, child: child);
  }

  static AppKitColorWellThemeData of(BuildContext context) {
    final AppKitColorWellTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitColorWellTheme>();
    return theme?.data ?? AppKitTheme.of(context).colorWellTheme;
  }
}

class AppKitColorWellThemeData with Diagnosticable {
  final double borderRadiusMinimal;
  final double borderRadiusExpanded;
  final double borderRadiusRegular;
  final double borderRadiusRegularInner;

  AppKitColorWellThemeData({
    required this.borderRadiusMinimal,
    required this.borderRadiusExpanded,
    required this.borderRadiusRegular,
    required this.borderRadiusRegularInner,
  });

  static AppKitColorWellThemeData lerp(
      AppKitColorWellThemeData? a, AppKitColorWellThemeData? b, double t) {
    return AppKitColorWellThemeData(
      borderRadiusMinimal:
          lerpDouble(a?.borderRadiusMinimal, b?.borderRadiusMinimal, t)!,
      borderRadiusExpanded:
          lerpDouble(a?.borderRadiusExpanded, b?.borderRadiusExpanded, t)!,
      borderRadiusRegular:
          lerpDouble(a?.borderRadiusRegular, b?.borderRadiusRegular, t)!,
      borderRadiusRegularInner: lerpDouble(
          a?.borderRadiusRegularInner, b?.borderRadiusRegularInner, t)!,
    );
  }

  AppKitColorWellThemeData merge(AppKitColorWellThemeData? other) {
    if (other == null) return this;
    return copyWith(
      borderRadiusMinimal: other.borderRadiusMinimal,
      borderRadiusExpanded: other.borderRadiusExpanded,
      borderRadiusRegular: other.borderRadiusRegular,
      borderRadiusRegularInner: other.borderRadiusRegularInner,
    );
  }

  AppKitColorWellThemeData copyWith({
    double? borderRadiusMinimal,
    double? borderRadiusExpanded,
    double? borderRadiusRegular,
    double? borderRadiusRegularInner,
  }) {
    return AppKitColorWellThemeData(
      borderRadiusMinimal: borderRadiusMinimal ?? this.borderRadiusMinimal,
      borderRadiusExpanded: borderRadiusExpanded ?? this.borderRadiusExpanded,
      borderRadiusRegular: borderRadiusRegular ?? this.borderRadiusRegular,
      borderRadiusRegularInner:
          borderRadiusRegularInner ?? this.borderRadiusRegularInner,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>(
        'borderRadiusMinimal', borderRadiusMinimal));
    properties.add(DiagnosticsProperty<double>(
        'borderRadiusExpanded', borderRadiusExpanded));
    properties.add(DiagnosticsProperty<double>(
        'borderRadiusRegular', borderRadiusRegular));
    properties.add(DiagnosticsProperty<double>(
        'borderRadiusRegularInner', borderRadiusRegularInner));
  }
}
