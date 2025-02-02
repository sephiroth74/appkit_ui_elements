import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
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

  // discrete slider thumb corner radius
  final double discreteThumbCornerRadius;

  // continuous slider track corner radius
  final double continuousTrackCornerRadius;

  // discrete ticks corner radius
  final double discreteTickCornerRadius;

  // The height of the track.
  final double trackHeight;

  // The height of the tick (discrete slider).
  final double tickHeight;

  // The width of the tick (discrete slider).
  final double tickWidth;

  // The size of the thumb (discrete slider).
  final Size discreteThumbSize;

  // The size of the thumb (continuous slider).
  final double continuousThumbSize;

  // The color of the track that the thumb can slide along when the slider is not in the main window.
  final Color? accentColorUnfocused;

  AppKitSliderThemeData({
    required this.trackColor,
    required this.thumbColor,
    required this.discreteAnchorThreshold,
    required this.discreteThumbCornerRadius,
    required this.continuousTrackCornerRadius,
    required this.discreteTickCornerRadius,
    required this.trackHeight,
    required this.tickHeight,
    required this.tickWidth,
    required this.discreteThumbSize,
    required this.continuousThumbSize,
    this.sliderColor,
    this.tickColor,
    this.animationDuration,
    this.accentColorUnfocused,
  })  : assert(discreteAnchorThreshold >= 0.0),
        assert(discreteThumbCornerRadius >= 0.0),
        assert(continuousTrackCornerRadius >= 0.0),
        assert(discreteTickCornerRadius >= 0.0),
        assert(trackHeight >= 0.0),
        assert(tickHeight >= 0.0),
        assert(tickWidth >= 0.0),
        assert(continuousThumbSize > 0.0),
        assert(discreteThumbSize.width > 0.0),
        assert(discreteThumbSize.height > 0.0),
        assert(trackHeight <= discreteThumbSize.height),
        assert(trackHeight <= continuousThumbSize),
        assert(tickHeight <= discreteThumbSize.height),
        assert(tickHeight <= continuousThumbSize);

  AppKitSliderThemeData copyWith({
    Color? thumbColor,
    Color? trackColor,
    Color? sliderColor,
    Color? tickColor,
    int? animationDuration,
    double? discreteAnchorThreshold,
    double? discreteThumbCornerRadius,
    double? continuousTrackCornerRadius,
    double? discreteTickCornerRadius,
    double? trackHeight,
    double? tickHeight,
    double? tickWidth,
    Size? discreteThumbSize,
    double? continuousThumbSize,
    Color? accentColorUnfocused,
  }) {
    return AppKitSliderThemeData(
      thumbColor: thumbColor ?? this.thumbColor,
      trackColor: trackColor ?? this.trackColor,
      tickColor: tickColor ?? this.tickColor,
      sliderColor: sliderColor ?? this.sliderColor,
      discreteAnchorThreshold:
          discreteAnchorThreshold ?? this.discreteAnchorThreshold,
      animationDuration: animationDuration ?? this.animationDuration,
      discreteThumbCornerRadius:
          discreteThumbCornerRadius ?? this.discreteThumbCornerRadius,
      continuousTrackCornerRadius:
          continuousTrackCornerRadius ?? this.continuousTrackCornerRadius,
      discreteTickCornerRadius:
          discreteTickCornerRadius ?? this.discreteTickCornerRadius,
      trackHeight: trackHeight ?? this.trackHeight,
      tickHeight: tickHeight ?? this.tickHeight,
      tickWidth: tickWidth ?? this.tickWidth,
      discreteThumbSize: discreteThumbSize ?? this.discreteThumbSize,
      continuousThumbSize: continuousThumbSize ?? this.continuousThumbSize,
      accentColorUnfocused: accentColorUnfocused ?? this.accentColorUnfocused,
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
      discreteThumbCornerRadius: other.discreteThumbCornerRadius,
      continuousTrackCornerRadius: other.continuousTrackCornerRadius,
      discreteTickCornerRadius: other.discreteTickCornerRadius,
      trackHeight: other.trackHeight,
      tickHeight: other.tickHeight,
      tickWidth: other.tickWidth,
      discreteThumbSize: other.discreteThumbSize,
      continuousThumbSize: other.continuousThumbSize,
      accentColorUnfocused: other.accentColorUnfocused,
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
    properties.add(
        DoubleProperty('discreteThumbCornerRadius', discreteThumbCornerRadius));
    properties.add(DoubleProperty(
        'continuousTrackCornerRadius', continuousTrackCornerRadius));
    properties.add(
        DoubleProperty('discreteTickCornerRadius', discreteTickCornerRadius));
    properties.add(DoubleProperty('trackHeight', trackHeight));
    properties.add(DoubleProperty('tickHeight', tickHeight));
    properties.add(DoubleProperty('tickWidth', tickWidth));
    properties.add(DiagnosticsProperty('discreteThumbSize', discreteThumbSize));
    properties.add(DoubleProperty('continuousThumbSize', continuousThumbSize));
    properties.add(ColorProperty('accentColorUnfocused', accentColorUnfocused));
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
      discreteThumbCornerRadius: lerpDouble(
          a.discreteThumbCornerRadius, b.discreteThumbCornerRadius, t)!,
      continuousTrackCornerRadius: lerpDouble(
          a.continuousTrackCornerRadius, b.continuousTrackCornerRadius, t)!,
      discreteTickCornerRadius: lerpDouble(
          a.discreteTickCornerRadius, b.discreteTickCornerRadius, t)!,
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t)!,
      tickHeight: lerpDouble(a.tickHeight, b.tickHeight, t)!,
      tickWidth: lerpDouble(a.tickWidth, b.tickWidth, t)!,
      discreteThumbSize:
          Size.lerp(a.discreteThumbSize, b.discreteThumbSize, t)!,
      continuousThumbSize:
          lerpDouble(a.continuousThumbSize, b.continuousThumbSize, t)!,
      accentColorUnfocused:
          Color.lerp(a.accentColorUnfocused, b.accentColorUnfocused, t),
    );
  }
}
