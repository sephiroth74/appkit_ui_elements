import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitHelpButtonTheme extends InheritedTheme {
  final AppKitHelpButtonThemeData data;

  const AppKitHelpButtonTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitHelpButtonTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitHelpButtonTheme(data: data, child: child);
  }

  static AppKitHelpButtonThemeData of(BuildContext context) {
    final AppKitHelpButtonTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitHelpButtonTheme>();
    return theme?.data ?? AppKitTheme.of(context).helpButtonTheme;
  }
}

class AppKitHelpButtonThemeData with Diagnosticable {
  final Color? color;
  final Color? disabledColor;

  AppKitHelpButtonThemeData({required this.color, required this.disabledColor});

  AppKitHelpButtonThemeData copyWith({Color? color, Color? disabledColor}) {
    return AppKitHelpButtonThemeData(
      color: color ?? this.color,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  AppKitHelpButtonThemeData merge(AppKitHelpButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      disabledColor: other.disabledColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
  }

  static AppKitHelpButtonThemeData lerp(
      AppKitHelpButtonThemeData? a, AppKitHelpButtonThemeData? b, double t) {
    return AppKitHelpButtonThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      disabledColor: Color.lerp(a?.disabledColor, b?.disabledColor, t),
    );
  }
}
