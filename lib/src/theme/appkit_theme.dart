import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AppKitTheme extends StatelessWidget {
  final AppKitThemeData data;
  final Widget child;

  const AppKitTheme({
    super.key,
    required this.data,
    required this.child,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppKitThemeData>('data', data));
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedUiKitTheme(
      theme: this,
      child: child,
    );
  }

  static AppKitThemeData of(BuildContext context) {
    final _InheritedUiKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedUiKitTheme>();
    return (inheritedTheme?.theme.data ??
        AppKitThemeData.fromMacosTheme(MacosTheme.of(context)));
  }

  static AppKitThemeData? maybeOf(BuildContext context) {
    final _InheritedUiKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedUiKitTheme>();
    if (inheritedTheme != null) {
      return inheritedTheme.theme.data;
    } else {
      final parentTheme = MacosTheme.maybeOf(context);
      if (parentTheme != null) {
        return AppKitThemeData.fromMacosTheme(parentTheme);
      }
    }
    return null;
  }

  static Brightness brightnessOf(BuildContext context) {
    final _InheritedUiKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedUiKitTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  static Brightness? maybeBrightnessOf(BuildContext context) {
    final _InheritedUiKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedUiKitTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }
}

class _InheritedUiKitTheme extends InheritedWidget {
  const _InheritedUiKitTheme({
    required this.theme,
    required super.child,
  });

  final AppKitTheme theme;

  @override
  bool updateShouldNotify(_InheritedUiKitTheme oldWidget) =>
      theme.data != oldWidget.theme.data;
}

class AppKitThemeData extends Equatable with Diagnosticable {
  final Brightness brightness;
  final Color? accentColor;
  final bool isMainWindow;
  final VisualDensity visualDensity;
  final Color canvasColor;
  final Color controlBackgroundColor;
  final Color controlBackgroundColorDisabled;
  final MacosTypography typography;
  final AppKitPushButtonThemeData pushButtonTheme;
  final AppKitToggleButtonThemeData toggleButtonTheme;
  final AppKitHelpButtonThemeData helpButtonTheme;

  factory AppKitThemeData({
    Brightness brightness = Brightness.light,
    VisualDensity? visualDensity,
    MacosTypography? typography,
    AppKitPushButtonThemeData? pushButtonTheme,
    AppKitToggleButtonThemeData? toggleButtonTheme,
    AppKitHelpButtonThemeData? helpButtonTheme,
    Color? canvasColor,
    Color? accentColor,
    bool? isMainWindow,
    Color? controlBackgroundColor,
    Color? controlBackgroundColorDisabled,
  }) {
    final bool isDark = brightness == Brightness.dark;

    visualDensity ??= VisualDensity.adaptivePlatformDensity;
    isMainWindow ??= true;
    typography ??=
        isDark ? MacosTypography.lightOpaque() : MacosTypography.darkOpaque();
    canvasColor ??= isDark
        ? const Color.fromRGBO(40, 40, 40, 1.0)
        : const Color.fromRGBO(246, 246, 246, 1.0);

    final controlBackgroundColor = isDark
        ? MacosColors.controlBackgroundColor.darkColor
        : MacosColors.controlBackgroundColor.color;
    final controlBackgroundColorDisabled = isDark
        ? MacosColors.controlBackgroundColor.darkColor.withOpacity(0.5)
        : MacosColors.controlBackgroundColor.color.withOpacity(0.5);

    pushButtonTheme ??= const AppKitPushButtonThemeData(
      buttonRadius: {
        AppKitControlSize.mini: 2.0,
        AppKitControlSize.small: 3.0,
        AppKitControlSize.regular: 6.0,
        AppKitControlSize.large: 7.0,
      },
      buttonPadding: {
        AppKitControlSize.mini:
            EdgeInsets.only(left: 6.0, right: 6.0, bottom: 0.5),
        AppKitControlSize.small:
            EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.0),
        AppKitControlSize.regular:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 3.0),
        AppKitControlSize.large:
            EdgeInsets.only(right: 20.0, left: 20.0, bottom: 1.0),
      },
      fontSize: {
        AppKitControlSize.mini: 9.0,
        AppKitControlSize.small: 10.0,
        AppKitControlSize.regular: 13.0,
        AppKitControlSize.large: 15.0,
      },
      buttonSize: {
        AppKitControlSize.mini: Size(26.0, 12.0),
        AppKitControlSize.small: Size(42.0, 14.0),
        AppKitControlSize.regular: Size(48.0, 22.0),
        AppKitControlSize.large: Size(54.0, 26.0),
      },
      destructiveTextColor: MacosColors.systemRedColor,
      textColor: CupertinoDynamicColor.withBrightness(
          color: MacosColors.white, darkColor: MacosColors.black),
      overlayPressedColor: CupertinoDynamicColor.withBrightness(
        color: MacosColor.fromRGBO(0, 0, 0, 0.06),
        darkColor: MacosColor.fromRGBO(255, 255, 255, 0.15),
      ),
    );

    toggleButtonTheme ??= AppKitToggleButtonThemeData.copyFrom(pushButtonTheme);

    helpButtonTheme ??= AppKitHelpButtonThemeData(
      color: isDark ? MacosColors.textBackgroundColor : MacosColors.textColor,
      disabledColor: isDark
          ? MacosColors.textBackgroundColor.withOpacity(0.5)
          : MacosColors.textColor.withOpacity(0.5),
    );

    final defaultData = AppKitThemeData.raw(
      brightness: brightness,
      accentColor: accentColor,
      isMainWindow: isMainWindow,
      visualDensity: visualDensity,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      toggleButtonTheme: toggleButtonTheme,
      helpButtonTheme: helpButtonTheme,
      canvasColor: canvasColor,
      controlBackgroundColor: controlBackgroundColor,
      controlBackgroundColorDisabled: controlBackgroundColorDisabled,
    );

    final customData = defaultData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      isMainWindow: isMainWindow,
      visualDensity: visualDensity,
      canvasColor: canvasColor,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      toggleButtonTheme: toggleButtonTheme,
      helpButtonTheme: helpButtonTheme,
    );

    return defaultData.merge(customData);
  }

  factory AppKitThemeData.light({
    Color? accentColor,
    bool isMainWindow = true,
  }) =>
      AppKitThemeData(
        brightness: Brightness.light,
        accentColor: accentColor,
        isMainWindow: isMainWindow,
      );

  factory AppKitThemeData.dark({
    Color? accentColor,
    bool isMainWindow = true,
  }) =>
      AppKitThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
        isMainWindow: isMainWindow,
      );

  factory AppKitThemeData.fallback() => AppKitThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  factory AppKitThemeData.fromMacosTheme(MacosThemeData themeData) {
    final brightness = themeData.brightness;
    final themeAccentColor = _getMacOsThemeAccentColor(themeData.accentColor);
    final accentColor = themeAccentColor != null
        ? brightness.resolve(themeAccentColor.color, themeAccentColor.darkColor)
        : null;

    return AppKitThemeData(
      brightness: themeData.brightness,
      accentColor: accentColor,
      isMainWindow: themeData.isMainWindow,
      visualDensity: themeData.visualDensity,
      canvasColor: themeData.canvasColor,
      typography: themeData.typography,
    );
  }

  static CupertinoDynamicColor? _getMacOsThemeAccentColor(AccentColor? color) {
    if (null == color) return null;
    switch (color) {
      case AccentColor.blue:
        return MacosColors.systemBlueColor;
      case AccentColor.purple:
        return MacosColors.systemPurpleColor;
      case AccentColor.pink:
        return MacosColors.systemPinkColor;
      case AccentColor.red:
        return MacosColors.systemRedColor;
      case AccentColor.orange:
        return MacosColors.systemOrangeColor;
      case AccentColor.yellow:
        return MacosColors.systemYellowColor;
      case AccentColor.green:
        return MacosColors.systemGreenColor;
      case AccentColor.graphite:
        return MacosColors.systemGrayColor;
    }
  }

  const AppKitThemeData.raw({
    required this.brightness,
    required this.accentColor,
    required this.isMainWindow,
    required this.visualDensity,
    required this.typography,
    required this.pushButtonTheme,
    required this.toggleButtonTheme,
    required this.helpButtonTheme,
    required this.canvasColor,
    required this.controlBackgroundColor,
    required this.controlBackgroundColorDisabled,
  });

  @override
  List<Object?> get props => [
        brightness,
        accentColor,
        isMainWindow,
        visualDensity,
        canvasColor,
        typography,
        pushButtonTheme,
        toggleButtonTheme,
        helpButtonTheme,
        controlBackgroundColor,
        controlBackgroundColorDisabled,
      ];

  AppKitThemeData copyWith({
    Brightness? brightness,
    Color? accentColor,
    bool? isMainWindow,
    VisualDensity? visualDensity,
    MacosTypography? typography,
    Color? canvasColor,
    Color? controlBackgroundColor,
    Color? controlBackgroundColorDisabled,
    AppKitPushButtonThemeData? pushButtonTheme,
    AppKitToggleButtonThemeData? toggleButtonTheme,
    AppKitHelpButtonThemeData? helpButtonTheme,
  }) {
    return AppKitThemeData.raw(
      brightness: brightness ?? this.brightness,
      accentColor: accentColor ?? this.accentColor,
      isMainWindow: isMainWindow ?? this.isMainWindow,
      visualDensity: visualDensity ?? this.visualDensity,
      typography: typography ?? this.typography,
      pushButtonTheme: pushButtonTheme ?? this.pushButtonTheme,
      toggleButtonTheme: toggleButtonTheme ?? this.toggleButtonTheme,
      helpButtonTheme: helpButtonTheme ?? this.helpButtonTheme,
      canvasColor: canvasColor ?? this.canvasColor,
      controlBackgroundColor:
          controlBackgroundColor ?? this.controlBackgroundColor,
      controlBackgroundColorDisabled:
          controlBackgroundColorDisabled ?? this.controlBackgroundColorDisabled,
    );
  }

  AppKitThemeData merge(AppKitThemeData? other) {
    if (other == null) return this;
    return copyWith(
      brightness: other.brightness,
      accentColor: other.accentColor,
      isMainWindow: other.isMainWindow,
      visualDensity: other.visualDensity,
      typography: other.typography,
      canvasColor: other.canvasColor,
      pushButtonTheme: other.pushButtonTheme,
      toggleButtonTheme: other.toggleButtonTheme,
      controlBackgroundColor: other.controlBackgroundColor,
      controlBackgroundColorDisabled: other.controlBackgroundColorDisabled,
      helpButtonTheme: other.helpButtonTheme,
    );
  }

  AppKitThemeData lerp(AppKitThemeData a, AppKitThemeData b, double t) {
    return AppKitThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      isMainWindow: t < 0.5 ? a.isMainWindow : b.isMainWindow,
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      typography: MacosTypography.lerp(a.typography, b.typography, t),
      pushButtonTheme: AppKitPushButtonThemeData.lerp(
          a.pushButtonTheme, b.pushButtonTheme, t),
      toggleButtonTheme: AppKitToggleButtonThemeData.lerp(
          a.toggleButtonTheme, b.toggleButtonTheme, t),
      helpButtonTheme: AppKitHelpButtonThemeData.lerp(
          a.helpButtonTheme, b.helpButtonTheme, t),
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t)!,
      controlBackgroundColor:
          Color.lerp(a.controlBackgroundColor, b.controlBackgroundColor, t)!,
      controlBackgroundColorDisabled: Color.lerp(
          a.controlBackgroundColorDisabled,
          b.controlBackgroundColorDisabled,
          t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Brightness>('brightness', brightness));
    properties.add(ColorProperty('accentColor', accentColor));
    properties.add(FlagProperty('isMainWindow',
        value: isMainWindow, ifTrue: 'main window'));
    properties.add(
        DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity));
    properties.add(ColorProperty('canvasColor', canvasColor));
    properties
        .add(DiagnosticsProperty<MacosTypography>('typography', typography));
    properties.add(DiagnosticsProperty<AppKitPushButtonThemeData>(
        'pushButtonTheme', pushButtonTheme));
    properties.add(DiagnosticsProperty<AppKitToggleButtonThemeData>(
        'toggleButtonTheme', toggleButtonTheme));
    properties
        .add(ColorProperty('controlBackgroundColor', controlBackgroundColor));
    properties.add(ColorProperty(
        'controlBackgroundColorDisabled', controlBackgroundColorDisabled));
    properties.add(DiagnosticsProperty<AppKitHelpButtonThemeData>(
        'helpButtonTheme', helpButtonTheme));
  }
}
