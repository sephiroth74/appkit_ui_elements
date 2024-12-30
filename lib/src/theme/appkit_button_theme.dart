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
  final AppKitInlineButtonThemeData inline;
  final AppKitFlatButtonThemeData flat;

  AppKitButtonThemeData({
    required this.inline,
    required this.flat,
  });

  AppKitButtonThemeData copyWith({
    AppKitInlineButtonThemeData? inline,
    AppKitFlatButtonThemeData? flat,
  }) {
    return AppKitButtonThemeData(
      inline: inline ?? this.inline,
      flat: flat ?? this.flat,
    );
  }

  AppKitButtonThemeData merge(AppKitButtonThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      inline: other.inline,
      flat: other.flat,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<AppKitInlineButtonThemeData>('inline', inline));
    properties
        .add(DiagnosticsProperty<AppKitFlatButtonThemeData>('flat', flat));
  }

  static AppKitButtonThemeData lerp(
      AppKitButtonThemeData? a, AppKitButtonThemeData? b, double t) {
    return AppKitButtonThemeData(
      inline: AppKitInlineButtonThemeData.lerp(a?.inline, b?.inline, t),
      flat: AppKitFlatButtonThemeData.lerp(a?.flat, b?.flat, t),
    );
  }
}

abstract class AppKitButtonThemeBaseData with Diagnosticable {
  final Color? accentColor;
  final Color? secondaryColor;
  final Color? destructiveColor;
  final Color backgroundColorDisabled;

  AppKitButtonThemeBaseData({
    required this.backgroundColorDisabled,
    this.accentColor,
    this.secondaryColor,
    this.destructiveColor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('accentColor', accentColor));
    properties
        .add(ColorProperty('backgroundColorDisabled', backgroundColorDisabled));
    properties.add(ColorProperty('secondaryColor', secondaryColor));
    properties.add(ColorProperty('destructiveColor', destructiveColor));
  }
}

class AppKitInlineButtonThemeData extends AppKitButtonThemeBaseData {
  AppKitInlineButtonThemeData({
    required super.backgroundColorDisabled,
    super.accentColor,
    super.secondaryColor,
    super.destructiveColor,
  });

  static AppKitInlineButtonThemeData lerp(AppKitInlineButtonThemeData? a,
      AppKitInlineButtonThemeData? b, double t) {
    return AppKitInlineButtonThemeData(
      accentColor: Color.lerp(a?.accentColor, b?.accentColor, t),
      backgroundColorDisabled: Color.lerp(
          a?.backgroundColorDisabled, b?.backgroundColorDisabled, t)!,
      secondaryColor: Color.lerp(a?.secondaryColor, b?.secondaryColor, t),
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
    );
  }
}

class AppKitFlatButtonThemeData extends AppKitButtonThemeBaseData {
  AppKitFlatButtonThemeData({
    required super.backgroundColorDisabled,
    super.accentColor,
    super.secondaryColor,
    super.destructiveColor,
  });

  static AppKitFlatButtonThemeData lerp(
      AppKitFlatButtonThemeData? a, AppKitFlatButtonThemeData? b, double t) {
    return AppKitFlatButtonThemeData(
      accentColor: Color.lerp(a?.accentColor, b?.accentColor, t),
      backgroundColorDisabled: Color.lerp(
          a?.backgroundColorDisabled, b?.backgroundColorDisabled, t)!,
      secondaryColor: Color.lerp(a?.secondaryColor, b?.secondaryColor, t),
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
    );
  }
}
