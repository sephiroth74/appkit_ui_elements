import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

///
/// https://www.figma.com/design/IX6ph2VWrJiRoMTI1Byz0K/Apple-Design-Resources---macOS-(Community)?node-id=0-1745&node-type=frame&t=2SWN7P0O7eB3nXKr-0
///
/// colors:
/// https://developer.apple.com/design/human-interface-guidelines/color#system-colors
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
    return _InheritedAppKitTheme(
      theme: this,
      child: child,
    );
  }

  static AppKitThemeData of(BuildContext context) {
    final _InheritedAppKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAppKitTheme>();
    return (inheritedTheme?.theme.data ??
        AppKitThemeData.fromMacosTheme(MacosTheme.of(context),
            highContrast: MediaQuery.of(context).highContrast));
  }

  static AppKitThemeData? maybeOf(BuildContext context) {
    final _InheritedAppKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAppKitTheme>();
    if (inheritedTheme != null) {
      return inheritedTheme.theme.data;
    } else {
      final parentTheme = MacosTheme.maybeOf(context);
      if (parentTheme != null) {
        return AppKitThemeData.fromMacosTheme(parentTheme,
            highContrast: MediaQuery.maybeOf(context)?.highContrast ?? false);
      }
    }
    return null;
  }

  static Brightness brightnessOf(BuildContext context) {
    final _InheritedAppKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAppKitTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.of(context).platformBrightness;
  }

  static Brightness? maybeBrightnessOf(BuildContext context) {
    final _InheritedAppKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAppKitTheme>();
    return inheritedTheme?.theme.data.brightness ??
        MediaQuery.maybeOf(context)?.platformBrightness;
  }
}

class _InheritedAppKitTheme extends InheritedWidget {
  const _InheritedAppKitTheme({
    required this.theme,
    required super.child,
  });

  final AppKitTheme theme;

  @override
  bool updateShouldNotify(_InheritedAppKitTheme oldWidget) =>
      theme.data != oldWidget.theme.data;
}

class AppKitThemeData extends Equatable with Diagnosticable {
  final Brightness brightness;
  final Color? accentColor;
  final bool isMainWindow;
  final VisualDensity visualDensity;
  final Color canvasColor;
  final CupertinoDynamicColor controlBackgroundPressedColor;
  final Color accentColorUnfocused;
  final AppKitPushButtonThemeData pushButtonTheme;
  final AppKitToggleButtonThemeData toggleButtonTheme;
  final AppKitHelpButtonThemeData helpButtonTheme;
  final AppKitSliderThemeData sliderTheme;
  final AppKitCircularSliderThemeData circularSliderTheme;
  final AppKitSegmentedControlThemeData segmentedControlTheme;
  final AppKitSwitchThemeData switchTheme;
  final AppKitProgressThemeData progressTheme;
  final AppKitColorWellThemeData colorWellTheme;
  final AppKitLevelIndicatorsThemeData levelIndicatorsTheme;
  final AppKitRatingIndicatorThemeData ratingIndicatorTheme;
  final AppKitTooltipThemeData tooltipTheme;
  final AppKitPopupButtonThemeData popupButtonTheme;
  final AppKitContextMenuThemeData contextMenuTheme;
  final AppKitComboButtonThemeData comboButtonTheme;
  final AppKitTypography typography;

  factory AppKitThemeData({
    Brightness brightness = Brightness.light,
    VisualDensity? visualDensity,
    AppKitPushButtonThemeData? pushButtonTheme,
    AppKitToggleButtonThemeData? toggleButtonTheme,
    AppKitHelpButtonThemeData? helpButtonTheme,
    AppKitSliderThemeData? sliderTheme,
    AppKitCircularSliderThemeData? circularSliderTheme,
    AppKitSegmentedControlThemeData? segmentedControlTheme,
    AppKitSwitchThemeData? switchTheme,
    AppKitProgressThemeData? progressTheme,
    AppKitColorWellThemeData? colorWellTheme,
    AppKitLevelIndicatorsThemeData? levelIndicatorsTheme,
    AppKitRatingIndicatorThemeData? ratingIndicatorTheme,
    AppKitTooltipThemeData? tooltipTheme,
    AppKitPopupButtonThemeData? popupButtonTheme,
    AppKitContextMenuThemeData? contextMenuTheme,
    AppKitComboButtonThemeData? comboButtonTheme,
    Color? canvasColor,
    Color? accentColor,
    bool? isMainWindow,
    Color? controlBackgroundColor,
    CupertinoDynamicColor? controlBackgroundPressedColor,
    Color? controlBackgroundColorDisabled,
    Color? accentColorUnfocused,
    AppKitTypography? typography,
  }) {
    final bool isDark = brightness == Brightness.dark;

    visualDensity ??= VisualDensity.adaptivePlatformDensity;
    isMainWindow ??= true;
    canvasColor ??= isDark
        ? const Color.fromRGBO(40, 40, 40, 1.0)
        : const Color.fromRGBO(246, 246, 246, 1.0);
    typography ??=
        isDark ? AppKitTypography.lightOpaque() : AppKitTypography.darkOpaque();

    controlBackgroundColor ??= isDark
        ? MacosColors.controlBackgroundColor.darkColor
        : MacosColors.controlBackgroundColor.color;

    controlBackgroundColorDisabled ??= isDark
        ? MacosColors.controlBackgroundColor.darkColor.withOpacity(0.5)
        : MacosColors.controlBackgroundColor.color.withOpacity(0.5);

    controlBackgroundPressedColor ??=
        const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            darkColor: Color.fromRGBO(255, 255, 255, 0.15));

    accentColorUnfocused ??=
        isDark ? const Color(0xFFbababa) : const Color(0xFFbababa);

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
      destructiveTextColor: AppKitColors.systemRed,
      overlayPressedColor: CupertinoDynamicColor.withBrightness(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        darkColor: Color.fromRGBO(255, 255, 255, 0.15),
      ),
    );

    toggleButtonTheme ??= AppKitToggleButtonThemeData.copyFrom(pushButtonTheme);

    helpButtonTheme ??= AppKitHelpButtonThemeData(
      color: isDark ? MacosColors.textBackgroundColor : MacosColors.textColor,
      disabledColor: isDark
          ? MacosColors.textBackgroundColor.withOpacity(0.5)
          : MacosColors.textColor.withOpacity(0.5),
    );

    sliderTheme ??= AppKitSliderThemeData(
      trackColor: AppKitColors.fills.opaque.primary.resolveWith(brightness),
      thumbColor: controlBackgroundColor,
      sliderColor: accentColor,
      tickColor: const Color(0xFFC9C9C7),
      discreteAnchorThreshold: 0.01,
      animationDuration: 200,
      discreteThumbCornerRadius: 4.0,
      discreteTickCornerRadius: 1.0,
      continuousTrackCornerRadius: 2.0,
      trackHeight: 4.0,
      tickHeight: 8.0,
      tickWidth: 2.0,
      discreteThumbSize: const Size(8.0, 20.0),
      continuousThumbSize: 20.0,
      accentColorUnfocused: accentColorUnfocused,
    );

    levelIndicatorsTheme ??= AppKitLevelIndicatorsThemeData(
      normalColor: AppKitColors.systemGreen,
      warningColor: AppKitColors.systemYellow,
      criticalColor: AppKitColors.systemRed,
      strokeColor: AppKitColors.systemGray.withOpacity(0.5),
      backgroundColor: AppKitColors.fills.opaque.secondary,
      borderRadius: 2.5,
    );

    ratingIndicatorTheme ??= AppKitRatingIndicatorThemeData(
      imageColor: AppKitColors.secondaryLabelColor,
      placeholderOpacity: 0.2,
      icon: Icons.star_sharp,
      iconsPadding: -1.0,
    );

    circularSliderTheme ??= AppKitCircularSliderThemeData(
      backgroundColor:
          isDark ? MacosColors.systemGrayColor.darkColor : Colors.white,
      thumbColor:
          isDark ? const Color(0x7fffffff) : Colors.black.withOpacity(0.5),
      thumbColorUnfocused: accentColorUnfocused,
    );

    segmentedControlTheme ??= AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection: isDark
          ? MacosColors.systemGrayColor.darkColor
          : const Color(0xFFE8E8E8),
      dividerColorSingleSelection: isDark
          ? MacosColors.systemGrayColor.darkColor
          : const Color(0xFFCCCBCB),
    );

    switchTheme ??= AppKitSwitchThemeData(
      uncheckedColor: const Color.fromRGBO(200, 200, 200, 1.0),
      uncheckedColorDisabled: const Color.fromRGBO(200, 200, 200, 0.5),
    );

    progressTheme ??= AppKitProgressThemeData(
      trackColor: isDark ? const Color(0xFFe1e0de) : const Color(0xFFe1e0de),
      color: accentColor,
      accentColorUnfocused: accentColorUnfocused,
    );

    colorWellTheme ??= AppKitColorWellThemeData(
      borderRadiusMinimal: 5.5,
      borderRadiusExpanded: 5.5,
      borderRadiusRegular: 5.5,
      borderRadiusRegularInner: 2.0,
    );

    tooltipTheme ??= AppKitTooltipThemeData(
        verticalOffset: 18.0,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        margin: EdgeInsets.zero,
        preferBelow: true,
        waitDuration: const Duration(seconds: 1),
        showDuration: const Duration(seconds: 10),
        minHeight: 24.0,
        textStyle: typography.callout.copyWith(
          fontSize: 13.0,
          color: const Color(0xFF4D4D4D),
        ),
        decoration: () {
          const radius = BorderRadius.all(Radius.circular(2.0));
          final shadow = [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 0.0,
              spreadRadius: 0.5,
              color: CupertinoColors.black.withOpacity(0.12),
            ),
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              spreadRadius: 0,
              blurRadius: 6,
            ),
          ];
          final border = Border.all(
            width: 0.5,
            color: const Color(0xFF4D4D4D),
          );

          return BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: radius,
            boxShadow: shadow,
            border: border,
          );
        }());

    popupButtonTheme ??= AppKitPopupButtonThemeData.fallback(
      brightness: brightness,
      typography: typography,
      elevatedButtonColor: accentColor,
    );

    comboButtonTheme ??= AppKitComboButtonThemeData.fallback(
      brightness: brightness,
      typography: typography,
    );

    contextMenuTheme ??= AppKitContextMenuThemeData(
      backgroundBlur: 0.4,
      borderRadius: 6.0,
      backgroundColor: isDark
          ? AppKitColors.materials.medium.darkColor.withOpacity(0.59)
          : const Color(0xFFe7e7e7),
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
      sliderTheme: sliderTheme,
      segmentedControlTheme: segmentedControlTheme,
      switchTheme: switchTheme,
      progressTheme: progressTheme,
      colorWellTheme: colorWellTheme,
      circularSliderTheme: circularSliderTheme,
      levelIndicatorsTheme: levelIndicatorsTheme,
      ratingIndicatorTheme: ratingIndicatorTheme,
      canvasColor: canvasColor,
      controlBackgroundPressedColor: controlBackgroundPressedColor,
      accentColorUnfocused: accentColorUnfocused,
      tooltipTheme: tooltipTheme,
      popupButtonTheme: popupButtonTheme,
      contextMenuTheme: contextMenuTheme,
      comboButtonTheme: comboButtonTheme,
    );

    final customData = defaultData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      isMainWindow: isMainWindow,
      visualDensity: visualDensity,
      canvasColor: canvasColor,
      typography: typography,
      controlBackgroundColor: controlBackgroundColor,
      controlBackgroundColorDisabled: controlBackgroundColorDisabled,
      controlBackgroundPressedColor: controlBackgroundPressedColor,
      pushButtonTheme: pushButtonTheme,
      toggleButtonTheme: toggleButtonTheme,
      helpButtonTheme: helpButtonTheme,
      sliderTheme: sliderTheme,
      segmentedControlTheme: segmentedControlTheme,
      switchTheme: switchTheme,
      progressTheme: progressTheme,
      accentColorUnfocused: accentColorUnfocused,
      colorWellTheme: colorWellTheme,
      levelIndicatorsTheme: levelIndicatorsTheme,
      ratingIndicatorTheme: ratingIndicatorTheme,
      tooltipTheme: tooltipTheme,
      popupButtonTheme: popupButtonTheme,
      contextMenuTheme: contextMenuTheme,
      comboButtonTheme: comboButtonTheme,
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

  factory AppKitThemeData.fromMacosTheme(MacosThemeData themeData,
      {bool highContrast = false}) {
    final brightness = themeData.brightness;
    final themeAccentColor = _getThemeAccentColor(themeData.accentColor);
    final accentColor = themeAccentColor != null
        ? brightness.resolve(themeAccentColor.color, themeAccentColor.darkColor)
        : null;

    return AppKitThemeData(
      brightness: themeData.brightness,
      accentColor: accentColor,
      isMainWindow: themeData.isMainWindow,
      visualDensity: themeData.visualDensity,
      canvasColor: themeData.canvasColor,
      typography: AppKitTypography.fromMacosTypograhpy(themeData.typography),
    );
  }

  static CupertinoDynamicColor? _getThemeAccentColor(AccentColor? color) {
    if (null == color) return null;
    switch (color) {
      case AccentColor.blue:
        return AppKitColors.systemBlue;
      case AccentColor.purple:
        return AppKitColors.systemPurple;
      case AccentColor.pink:
        return AppKitColors.systemPink;
      case AccentColor.red:
        return AppKitColors.systemRed;
      case AccentColor.orange:
        return AppKitColors.systemOrange;
      case AccentColor.yellow:
        return AppKitColors.systemYellow;
      case AccentColor.green:
        return AppKitColors.systemGreen;
      case AccentColor.graphite:
        return AppKitColors.systemGray;
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
    required this.sliderTheme,
    required this.segmentedControlTheme,
    required this.switchTheme,
    required this.progressTheme,
    required this.colorWellTheme,
    required this.circularSliderTheme,
    required this.canvasColor,
    required this.controlBackgroundPressedColor,
    required this.accentColorUnfocused,
    required this.levelIndicatorsTheme,
    required this.ratingIndicatorTheme,
    required this.tooltipTheme,
    required this.popupButtonTheme,
    required this.contextMenuTheme,
    required this.comboButtonTheme,
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
        sliderTheme,
        segmentedControlTheme,
        switchTheme,
        progressTheme,
        colorWellTheme,
        controlBackgroundPressedColor,
        accentColorUnfocused,
        circularSliderTheme,
        levelIndicatorsTheme,
        ratingIndicatorTheme,
        tooltipTheme,
        popupButtonTheme,
        contextMenuTheme,
        comboButtonTheme,
      ];

  AppKitThemeData copyWith({
    Brightness? brightness,
    Color? accentColor,
    bool? isMainWindow,
    VisualDensity? visualDensity,
    AppKitTypography? typography,
    Color? canvasColor,
    Color? controlBackgroundColor,
    Color? controlBackgroundColorDisabled,
    CupertinoDynamicColor? controlBackgroundPressedColor,
    Color? accentColorUnfocused,
    AppKitPushButtonThemeData? pushButtonTheme,
    AppKitToggleButtonThemeData? toggleButtonTheme,
    AppKitHelpButtonThemeData? helpButtonTheme,
    AppKitSliderThemeData? sliderTheme,
    AppKitSegmentedControlThemeData? segmentedControlTheme,
    AppKitSwitchThemeData? switchTheme,
    AppKitProgressThemeData? progressTheme,
    AppKitColorWellThemeData? colorWellTheme,
    AppKitCircularSliderThemeData? circularSliderTheme,
    AppKitLevelIndicatorsThemeData? levelIndicatorsTheme,
    AppKitRatingIndicatorThemeData? ratingIndicatorTheme,
    AppKitTooltipThemeData? tooltipTheme,
    AppKitPopupButtonThemeData? popupButtonTheme,
    AppKitContextMenuThemeData? contextMenuTheme,
    AppKitComboButtonThemeData? comboButtonTheme,
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
      sliderTheme: sliderTheme ?? this.sliderTheme,
      segmentedControlTheme:
          segmentedControlTheme ?? this.segmentedControlTheme,
      canvasColor: canvasColor ?? this.canvasColor,
      controlBackgroundPressedColor:
          controlBackgroundPressedColor ?? this.controlBackgroundPressedColor,
      switchTheme: switchTheme ?? this.switchTheme,
      progressTheme: progressTheme ?? this.progressTheme,
      accentColorUnfocused: accentColorUnfocused ?? this.accentColorUnfocused,
      colorWellTheme: colorWellTheme ?? this.colorWellTheme,
      circularSliderTheme: circularSliderTheme ?? this.circularSliderTheme,
      levelIndicatorsTheme: levelIndicatorsTheme ?? this.levelIndicatorsTheme,
      ratingIndicatorTheme: ratingIndicatorTheme ?? this.ratingIndicatorTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
      popupButtonTheme: popupButtonTheme ?? this.popupButtonTheme,
      contextMenuTheme: contextMenuTheme ?? this.contextMenuTheme,
      comboButtonTheme: comboButtonTheme ?? this.comboButtonTheme,
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
      helpButtonTheme: other.helpButtonTheme,
      sliderTheme: other.sliderTheme,
      segmentedControlTheme: other.segmentedControlTheme,
      controlBackgroundPressedColor: other.controlBackgroundPressedColor,
      switchTheme: other.switchTheme,
      progressTheme: other.progressTheme,
      accentColorUnfocused: other.accentColorUnfocused,
      colorWellTheme: other.colorWellTheme,
      circularSliderTheme: other.circularSliderTheme,
      levelIndicatorsTheme: other.levelIndicatorsTheme,
      ratingIndicatorTheme: other.ratingIndicatorTheme,
      tooltipTheme: other.tooltipTheme,
      popupButtonTheme: other.popupButtonTheme,
      contextMenuTheme: other.contextMenuTheme,
      comboButtonTheme: other.comboButtonTheme,
    );
  }

  AppKitThemeData lerp(AppKitThemeData a, AppKitThemeData b, double t) {
    return AppKitThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      isMainWindow: t < 0.5 ? a.isMainWindow : b.isMainWindow,
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      typography: AppKitTypography.lerp(a.typography, b.typography, t),
      pushButtonTheme: AppKitPushButtonThemeData.lerp(
          a.pushButtonTheme, b.pushButtonTheme, t),
      toggleButtonTheme: AppKitToggleButtonThemeData.lerp(
          a.toggleButtonTheme, b.toggleButtonTheme, t),
      helpButtonTheme: AppKitHelpButtonThemeData.lerp(
          a.helpButtonTheme, b.helpButtonTheme, t),
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t)!,
      sliderTheme: AppKitSliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      segmentedControlTheme: AppKitSegmentedControlThemeData.lerp(
          a.segmentedControlTheme, b.segmentedControlTheme, t),
      controlBackgroundPressedColor: CupertinoDynamicColor.withBrightness(
        color: Color.lerp(a.controlBackgroundPressedColor.color,
            b.controlBackgroundPressedColor.color, t)!,
        darkColor: Color.lerp(a.controlBackgroundPressedColor.darkColor,
            b.controlBackgroundPressedColor.darkColor, t)!,
      ),
      switchTheme: AppKitSwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      progressTheme:
          AppKitProgressThemeData.lerp(a.progressTheme, b.progressTheme, t),
      accentColorUnfocused:
          Color.lerp(a.accentColorUnfocused, b.accentColorUnfocused, t)!,
      colorWellTheme:
          AppKitColorWellThemeData.lerp(a.colorWellTheme, b.colorWellTheme, t),
      circularSliderTheme: AppKitCircularSliderThemeData.lerp(
          a.circularSliderTheme, b.circularSliderTheme, t),
      levelIndicatorsTheme: AppKitLevelIndicatorsThemeData.lerp(
          a.levelIndicatorsTheme, b.levelIndicatorsTheme, t),
      ratingIndicatorTheme: AppKitRatingIndicatorThemeData.lerp(
          a.ratingIndicatorTheme, b.ratingIndicatorTheme, t),
      tooltipTheme:
          AppKitTooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
      popupButtonTheme: AppKitPopupButtonThemeData.lerp(
          a.popupButtonTheme, b.popupButtonTheme, t),
      contextMenuTheme: AppKitContextMenuThemeData.lerp(
          a.contextMenuTheme, b.contextMenuTheme, t),
      comboButtonTheme: AppKitComboButtonThemeData.lerp(
          a.comboButtonTheme, b.comboButtonTheme, t),
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
        .add(DiagnosticsProperty<AppKitTypography>('typography', typography));
    properties.add(DiagnosticsProperty<AppKitPushButtonThemeData>(
        'pushButtonTheme', pushButtonTheme));
    properties.add(DiagnosticsProperty<AppKitToggleButtonThemeData>(
        'toggleButtonTheme', toggleButtonTheme));
    properties.add(DiagnosticsProperty<AppKitHelpButtonThemeData>(
        'helpButtonTheme', helpButtonTheme));
    properties.add(
        DiagnosticsProperty<AppKitSliderThemeData>('sliderTheme', sliderTheme));
    properties.add(DiagnosticsProperty<AppKitSegmentedControlThemeData>(
        'segmentedControlTheme', segmentedControlTheme));
    properties.add(ColorProperty(
        'controlBackgroundPressedColor', controlBackgroundPressedColor));
    properties.add(
        DiagnosticsProperty<AppKitSwitchThemeData>('switchTheme', switchTheme));
    properties.add(DiagnosticsProperty<AppKitProgressThemeData>(
        'progressTheme', progressTheme));
    properties.add(ColorProperty('accentColorUnfocused', accentColorUnfocused));
    properties.add(DiagnosticsProperty<AppKitColorWellThemeData>(
        'colorWellTheme', colorWellTheme));
    properties.add(DiagnosticsProperty<AppKitCircularSliderThemeData>(
        'circularSliderTheme', circularSliderTheme));
    properties.add(DiagnosticsProperty<AppKitLevelIndicatorsThemeData>(
        'levelIndicatorsTheme', levelIndicatorsTheme));
    properties.add(DiagnosticsProperty<AppKitRatingIndicatorThemeData>(
        'ratingIndicatorTheme', ratingIndicatorTheme));
    properties.add(DiagnosticsProperty<AppKitTooltipThemeData>(
        'tooltipTheme', tooltipTheme));
    properties.add(DiagnosticsProperty<AppKitPopupButtonThemeData>(
        'popupButtonTheme', popupButtonTheme));
    properties.add(DiagnosticsProperty<AppKitContextMenuThemeData>(
        'contextMenuTheme', contextMenuTheme));
    properties.add(DiagnosticsProperty<AppKitComboButtonThemeData>(
        'comboButtonTheme', comboButtonTheme));
  }
}

extension UiElementColorBuilderX on UiElementColorContainer {
  BoxShadow get shadowPrimary => BoxShadow(
        color: shadowColor.withOpacity(0.4),
        blurRadius: 0.50,
        offset: const Offset(0.0, 1),
        blurStyle: BlurStyle.outer,
      );

  BoxShadow get shadowSecondary => BoxShadow(
        color: shadowColor.withOpacity(0.1),
        blurRadius: 0.0,
        spreadRadius: 0.5,
        blurStyle: BlurStyle.outer,
        offset: const Offset(0.0, 0.0),
      );
}
