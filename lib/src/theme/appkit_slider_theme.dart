import 'dart:ui';

import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';

class AppKitSliderTheme extends InheritedTheme {
  final AppKitSliderThemeData data;

  const AppKitSliderTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitSliderTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitSliderTheme(data: data, child: child);
  }

  static AppKitSliderThemeData of(BuildContext context) {
    final AppKitSliderTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitSliderTheme>();
    return theme?.data ?? AppKitTheme.of(context).sliderTheme;
  }
}

class AppKitSliderThemeData with Diagnosticable {
  // The color of the track that the thumb can slide along.
  final Color trackColor;

  // The color of the thumb.
  final Color thumbColor;

  // The color of the slider (the one below the slider current value).
  final Color? sliderColor;

  // The color of the tick marks.
  final Color? tickColor;

  // The threshold at which the slider will snap to a discrete value.
  final double discreteAnchorThreshold;

  // The duration of the animation when the slider value changes.
  final int? animationDuration;

  AppKitSliderThemeData({
    required this.trackColor,
    required this.thumbColor,
    required this.discreteAnchorThreshold,
    this.sliderColor,
    this.tickColor,
    this.animationDuration,
  });

  AppKitSliderThemeData copyWith({
    Color? thumbColor,
    Color? trackColor,
    Color? sliderColor,
    Color? tickColor,
    double? discreteAnchorThreshold,
    int? animationDuration,
  }) {
    return AppKitSliderThemeData(
      thumbColor: thumbColor ?? this.thumbColor,
      trackColor: trackColor ?? this.trackColor,
      tickColor: tickColor ?? this.tickColor,
      sliderColor: sliderColor ?? this.sliderColor,
      discreteAnchorThreshold:
          discreteAnchorThreshold ?? this.discreteAnchorThreshold,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  AppKitSliderThemeData merge(AppKitSliderThemeData? other) {
    if (other == null) return this;
    return copyWith(
      thumbColor: other.thumbColor,
      trackColor: other.trackColor,
      tickColor: other.tickColor,
      sliderColor: other.sliderColor,
      discreteAnchorThreshold: other.discreteAnchorThreshold,
      animationDuration: other.animationDuration,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(ColorProperty('tickColor', tickColor));
    properties.add(ColorProperty('sliderColor', sliderColor));
    properties.add(
        DoubleProperty('discreteAnchorThreshold', discreteAnchorThreshold));
    properties.add(IntProperty('animationDuration', animationDuration));
  }

  static AppKitSliderThemeData lerp(
      AppKitSliderThemeData a, AppKitSliderThemeData b, double t) {
    return AppKitSliderThemeData(
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t)!,
      trackColor: Color.lerp(a.trackColor, b.trackColor, t)!,
      tickColor: Color.lerp(a.tickColor, b.tickColor, t),
      sliderColor: Color.lerp(a.sliderColor, b.sliderColor, t)!,
      discreteAnchorThreshold:
          lerpDouble(a.discreteAnchorThreshold, b.discreteAnchorThreshold, t)!,
      animationDuration:
          a.animationDuration != null && b.animationDuration != null
              ? lerpInt(a.animationDuration!, b.animationDuration!, t)
              : b.animationDuration,
    );
  }
}
