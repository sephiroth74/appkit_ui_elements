import 'dart:ui';

import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitRatingIndicatorTheme extends InheritedTheme {
  final AppKitRatingIndicatorThemeData data;

  const AppKitRatingIndicatorTheme({super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitRatingIndicatorTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitRatingIndicatorTheme(data: data, child: child);
  }

  static AppKitRatingIndicatorThemeData of(BuildContext context) {
    final AppKitRatingIndicatorTheme? theme = context.dependOnInheritedWidgetOfExactType<AppKitRatingIndicatorTheme>();
    return theme?.data ?? AppKitTheme.of(context).ratingIndicatorTheme;
  }
}

class AppKitRatingIndicatorThemeData with Diagnosticable {
  final Color imageColor;
  final double placeholderOpacity;
  final IconData? icon;
  final double iconsPadding;

  AppKitRatingIndicatorThemeData({
    required this.imageColor,
    required this.placeholderOpacity,
    required this.iconsPadding,
    this.icon,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('imageColor', imageColor));
    properties.add(DoubleProperty('placeholderOpacity', placeholderOpacity));
    properties.add(DiagnosticsProperty('icon', icon));
    properties.add(DoubleProperty('iconsPadding', iconsPadding));
  }

  AppKitRatingIndicatorThemeData copyWith({
    Color? imageColor,
    double? placeholderOpacity,
    IconData? icon,
    double? iconsPadding,
  }) {
    return AppKitRatingIndicatorThemeData(
      imageColor: imageColor ?? this.imageColor,
      placeholderOpacity: placeholderOpacity ?? this.placeholderOpacity,
      icon: icon ?? this.icon,
      iconsPadding: iconsPadding ?? this.iconsPadding,
    );
  }

  AppKitRatingIndicatorThemeData merge(AppKitRatingIndicatorThemeData? other) {
    if (other == null) return this;
    return copyWith(
      imageColor: other.imageColor,
      placeholderOpacity: other.placeholderOpacity,
      icon: other.icon,
      iconsPadding: other.iconsPadding,
    );
  }

  static AppKitRatingIndicatorThemeData lerp(
    AppKitRatingIndicatorThemeData? a,
    AppKitRatingIndicatorThemeData? b,
    double t,
  ) {
    return AppKitRatingIndicatorThemeData(
      imageColor: Color.lerp(a?.imageColor, b?.imageColor, t)!,
      placeholderOpacity: lerpDouble(a?.placeholderOpacity, b?.placeholderOpacity, t)!,
      icon: t < 0.5 ? a?.icon : b?.icon,
      iconsPadding: lerpDouble(a?.iconsPadding, b?.iconsPadding, t)!,
    );
  }
}
