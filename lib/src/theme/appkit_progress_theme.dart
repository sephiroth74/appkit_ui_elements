import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitProgressTheme extends InheritedTheme {
  final AppKitProgressThemeData data;

  const AppKitProgressTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitProgressTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitProgressTheme(data: data, child: child);
  }

  static AppKitProgressThemeData of(BuildContext context) {
    final AppKitProgressTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitProgressTheme>();
    return theme?.data ?? AppKitTheme.of(context).progressTheme;
  }
}

class AppKitProgressThemeData with Diagnosticable {
  final Color? color;
  final Color? accentColorUnfocused;
  final Color trackColor;

  AppKitProgressThemeData({
    required this.trackColor,
    this.accentColorUnfocused,
    this.color,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('accentColorUnfocused', accentColorUnfocused));
  }

  AppKitProgressThemeData copyWith({
    Color? trackColor,
    Color? color,
    Color? accentColorUnfocused,
  }) {
    return AppKitProgressThemeData(
      trackColor: trackColor ?? this.trackColor,
      color: color,
      accentColorUnfocused: accentColorUnfocused ?? this.accentColorUnfocused,
    );
  }

  AppKitProgressThemeData merge(AppKitProgressThemeData? other) {
    if (other == null) return this;
    return copyWith(
      trackColor: other.trackColor,
      color: other.color,
      accentColorUnfocused: other.accentColorUnfocused,
    );
  }

  static AppKitProgressThemeData lerp(
      AppKitProgressThemeData a, AppKitProgressThemeData b, double t) {
    return AppKitProgressThemeData(
      trackColor: Color.lerp(a.trackColor, b.trackColor, t)!,
      color: Color.lerp(a.color, b.color, t),
      accentColorUnfocused:
          Color.lerp(a.accentColorUnfocused, b.accentColorUnfocused, t)!,
    );
  }
}
