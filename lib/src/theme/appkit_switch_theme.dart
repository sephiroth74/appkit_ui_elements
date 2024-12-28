import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitSwitchTheme extends InheritedTheme {
  final AppKitSwitchThemeData data;

  const AppKitSwitchTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitSwitchTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitSwitchTheme(data: data, child: child);
  }

  static AppKitSwitchThemeData of(BuildContext context) {
    final AppKitSwitchTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitSwitchTheme>();
    return theme?.data ?? AppKitTheme.of(context).switchTheme;
  }
}

class AppKitSwitchThemeData with Diagnosticable {
  final Color uncheckedColor;
  final Color uncheckedColorDisabled;
  final Color checkedColor;

  AppKitSwitchThemeData({
    required this.uncheckedColor,
    required this.uncheckedColorDisabled,
    required this.checkedColor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('uncheckedColor', uncheckedColor));
    properties
        .add(ColorProperty('uncheckedColorDisabled', uncheckedColorDisabled));
    properties.add(ColorProperty('checkedColor', checkedColor));
  }

  AppKitSwitchThemeData copyWith({
    Color? uncheckedColor,
    Color? uncheckedColorDisabled,
    Color? checkedColor,
  }) {
    return AppKitSwitchThemeData(
      uncheckedColor: uncheckedColor ?? this.uncheckedColor,
      uncheckedColorDisabled:
          uncheckedColorDisabled ?? this.uncheckedColorDisabled,
      checkedColor: checkedColor ?? this.checkedColor,
    );
  }

  AppKitSwitchThemeData merge(AppKitSwitchThemeData? other) {
    if (other == null) return this;
    return copyWith(
      uncheckedColor: other.uncheckedColor,
      uncheckedColorDisabled: other.uncheckedColorDisabled,
      checkedColor: other.checkedColor,
    );
  }

  static AppKitSwitchThemeData lerp(
      AppKitSwitchThemeData a, AppKitSwitchThemeData b, double t) {
    return AppKitSwitchThemeData(
      uncheckedColor: Color.lerp(a.uncheckedColor, b.uncheckedColor, t)!,
      uncheckedColorDisabled:
          Color.lerp(a.uncheckedColorDisabled, b.uncheckedColorDisabled, t)!,
      checkedColor: Color.lerp(a.checkedColor, b.checkedColor, t)!,
    );
  }
}
