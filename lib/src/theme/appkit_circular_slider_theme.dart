import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';

class AppKitCircularSliderTheme extends InheritedTheme {
  final AppKitCircularSliderThemeData data;

  const AppKitCircularSliderTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitCircularSliderTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitCircularSliderTheme(data: data, child: child);
  }

  static AppKitCircularSliderThemeData of(BuildContext context) {
    final AppKitCircularSliderTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitCircularSliderTheme>();
    return theme?.data ?? AppKitTheme.of(context).circularSliderTheme;
  }
}

class AppKitCircularSliderThemeData with Diagnosticable {
  final Color backgroundColor;
  final Color thumbColor;
  final Color thumbColorUnfocused;

  AppKitCircularSliderThemeData({
    required this.backgroundColor,
    required this.thumbColor,
    required this.thumbColorUnfocused,
  });

  AppKitCircularSliderThemeData copyWith({
    Color? backgroundColor,
    Color? thumbColor,
    Color? thumbColorUnfocused,
    double? thumbPadding,
    double? thumbSize,
    double? thumbSizeUnfocused,
  }) {
    return AppKitCircularSliderThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbColorUnfocused: thumbColorUnfocused ?? this.thumbColorUnfocused,
    );
  }

  AppKitCircularSliderThemeData merge(AppKitCircularSliderThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      thumbColor: other.thumbColor,
      thumbColorUnfocused: other.thumbColorUnfocused,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(ColorProperty('thumbColorUnfocused', thumbColorUnfocused));
  }

  static AppKitCircularSliderThemeData lerp(AppKitCircularSliderThemeData a,
      AppKitCircularSliderThemeData b, double t) {
    return AppKitCircularSliderThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t)!,
      thumbColorUnfocused:
          Color.lerp(a.thumbColorUnfocused, b.thumbColorUnfocused, t)!,
    );
  }
}
