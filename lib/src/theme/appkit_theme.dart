import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return (inheritedTheme?.theme.data ?? AppKitThemeData.fallback());
  }

  static AppKitThemeData? maybeOf(BuildContext context) {
    final _InheritedAppKitTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAppKitTheme>();
    return inheritedTheme?.theme.data;
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
  final AppKitAccentColor accentColor;
  final Color primaryColor;
  final Color activeColor;
  final Color focusColor;
  final Color dividerColor;
  final bool isMainWindow;
  final VisualDensity visualDensity;
  final Color canvasColor;
  final Color controlBackgroundColor;
  final Color controlBackgroundPressedColor;
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
  final AppKitIconThemeData iconTheme;
  final AppKitTypography typography;
  final AppKitScrollbarThemeData scrollbarTheme;
  final AppKitIconButtonThemeData iconButtonTheme;

  factory AppKitThemeData({
    Brightness brightness = Brightness.light,
    Color? primaryColor,
    Color? activeColor,
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
    AppKitIconThemeData? iconTheme,
    AppKitScrollbarThemeData? scrollbarTheme,
    AppKitIconButtonThemeData? iconButtonTheme,
    Color? canvasColor,
    AppKitAccentColor? accentColor,
    bool? isMainWindow,
    Color? controlBackgroundColor,
    Color? controlBackgroundPressedColor,
    Color? controlBackgroundColorDisabled,
    Color? accentColorUnfocused,
    AppKitTypography? typography,
    Color? dividerColor,
  }) {
    final bool isDark = brightness == Brightness.dark;

    accentColor ??= AppKitAccentColor.blue;

    primaryColor ??= _ColorProvider.getPrimaryColor(
      accentColor: accentColor,
      isDark: isDark,
      isMainWindow: isMainWindow ?? true,
    );

    activeColor ??= _ColorProvider.getActiveColor(
      accentColor: accentColor,
      isDark: isDark,
      isMainWindow: isMainWindow ?? true,
    );

    Color focusColor = primaryColor.withOpacity(0.749);

    visualDensity ??= VisualDensity.adaptivePlatformDensity;
    isMainWindow ??= true;
    canvasColor ??= isDark
        ? AppKitColors.canvasColor.darkColor
        : AppKitColors.canvasColor.color;
    typography ??=
        isDark ? AppKitTypography.lightOpaque() : AppKitTypography.darkOpaque();

    controlBackgroundColor ??= isDark
        ? AppKitColors.controlBackgroundColor.darkColor
        : AppKitColors.controlBackgroundColor.color;

    controlBackgroundColorDisabled ??= isDark
        ? AppKitColors.controlBackgroundColor.darkColor.withOpacity(0.5)
        : AppKitColors.controlBackgroundColor.color.withOpacity(0.5);

    controlBackgroundPressedColor ??= isDark
        ? AppKitColors.controlBackgroundPressedColor.darkColor
        : AppKitColors.controlBackgroundPressedColor.color;

    accentColorUnfocused ??=
        isDark ? const Color(0xFFbababa) : const Color(0xFFbababa);

    dividerColor ??= isDark
        ? AppKitColors.dividerColor.darkColor
        : AppKitColors.dividerColor.color;

    pushButtonTheme ??= const AppKitPushButtonThemeData(
      buttonRadius: {
        AppKitControlSize.mini: 2.0,
        AppKitControlSize.small: 3.0,
        AppKitControlSize.regular: 5.0,
        AppKitControlSize.large: 5.0,
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
        color: Color.fromRGBO(0, 0, 0, 0.1),
        darkColor: Color.fromRGBO(255, 255, 255, 0.15),
      ),
    );

    toggleButtonTheme ??= AppKitToggleButtonThemeData.copyFrom(pushButtonTheme);

    helpButtonTheme ??= AppKitHelpButtonThemeData(
      color: isDark ? const Color(0xff1e1e1e) : Colors.white,
      disabledColor: isDark
          ? const Color(0xff1e1e1e).withOpacity(0.5)
          : Colors.white.withOpacity(0.5),
    );

    sliderTheme ??= AppKitSliderThemeData(
      trackColor: isDark
          ? AppKitColors.fills.opaque.primary.darkColor
          : AppKitColors.fills.opaque.primary.color,
      thumbColor: controlBackgroundColor,
      sliderColor: activeColor,
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
          isDark ? AppKitColors.systemGray.darkColor : Colors.white,
      thumbColor:
          isDark ? const Color(0x7fffffff) : Colors.black.withOpacity(0.5),
      thumbColorUnfocused: accentColorUnfocused,
    );

    segmentedControlTheme ??= AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection:
          isDark ? AppKitColors.systemGray.darkColor : const Color(0xFFE8E8E8),
      dividerColorSingleSelection:
          isDark ? AppKitColors.systemGray.darkColor : const Color(0xFFCCCBCB),
    );

    switchTheme ??= AppKitSwitchThemeData(
      checkedColor: activeColor,
      uncheckedColor: isDark
          ? const Color(0xFF414141)
          : const Color.fromRGBO(200, 200, 200, 1.0),
      uncheckedColorDisabled: isDark
          ? const Color(0x7F414141)
          : const Color.fromRGBO(200, 200, 200, 0.5),
    );

    progressTheme ??= AppKitProgressThemeData(
      trackColor: isDark ? const Color(0xFF262728) : const Color(0xFFe1e0de),
      color: activeColor,
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
      elevatedButtonColor: primaryColor,
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

    iconTheme ??= AppKitIconThemeData(
      color: primaryColor,
      size: 20,
    );

    scrollbarTheme ??= AppKitScrollbarThemeData(
      thickness: 6.0,
      thicknessWhileHovering: 9.0,
      thumbColor: isDark
          ? AppKitColors.scrollbarColor.darkColor
          : AppKitColors.scrollbarColor.color,
      radius: const Radius.circular(25),
      thumbVisibility: false,
    );

    iconButtonTheme ??= AppKitIconButtonThemeData(
      backgroundColor: Colors.transparent,
      disabledColor: isDark ? const Color(0xff353535) : const Color(0xffE5E5E5),
      hoverColor:
          isDark ? const Color(0xff333336) : Colors.black.withOpacity(0.05),
      pressedColor:
          isDark ? const Color(0xff333336) : Colors.black.withOpacity(0.2),
      shape: BoxShape.rectangle,
      boxConstraints: const BoxConstraints(
        minHeight: 20,
        minWidth: 20,
        maxWidth: 30,
        maxHeight: 30,
      ),
    );

    final defaultData = AppKitThemeData.raw(
      brightness: brightness,
      primaryColor: primaryColor,
      activeColor: activeColor,
      accentColor: accentColor,
      focusColor: focusColor,
      dividerColor: dividerColor,
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
      controlBackgroundColor: controlBackgroundColor,
      controlBackgroundPressedColor: controlBackgroundPressedColor,
      accentColorUnfocused: accentColorUnfocused,
      tooltipTheme: tooltipTheme,
      popupButtonTheme: popupButtonTheme,
      contextMenuTheme: contextMenuTheme,
      comboButtonTheme: comboButtonTheme,
      iconTheme: iconTheme,
      scrollbarTheme: scrollbarTheme,
      iconButtonTheme: iconButtonTheme,
    );

    final customData = defaultData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      primaryColor: primaryColor,
      focusColor: focusColor,
      dividerColor: dividerColor,
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
      iconTheme: iconTheme,
      scrollbarTheme: scrollbarTheme,
      iconButtonTheme: iconButtonTheme,
    );

    return defaultData.merge(customData);
  }

  factory AppKitThemeData.light({
    AppKitAccentColor? accentColor,
    bool isMainWindow = true,
  }) =>
      AppKitThemeData(
        brightness: Brightness.light,
        accentColor: accentColor,
        isMainWindow: isMainWindow,
      );

  factory AppKitThemeData.dark({
    AppKitAccentColor? accentColor,
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

  const AppKitThemeData.raw({
    required this.brightness,
    required this.accentColor,
    required this.primaryColor,
    required this.activeColor,
    required this.focusColor,
    required this.dividerColor,
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
    required this.controlBackgroundColor,
    required this.accentColorUnfocused,
    required this.levelIndicatorsTheme,
    required this.ratingIndicatorTheme,
    required this.tooltipTheme,
    required this.popupButtonTheme,
    required this.contextMenuTheme,
    required this.comboButtonTheme,
    required this.iconTheme,
    required this.scrollbarTheme,
    required this.iconButtonTheme,
  });

  @override
  List<Object?> get props => [
        brightness,
        primaryColor,
        focusColor,
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
        controlBackgroundColor,
        controlBackgroundPressedColor,
        accentColorUnfocused,
        circularSliderTheme,
        levelIndicatorsTheme,
        ratingIndicatorTheme,
        tooltipTheme,
        popupButtonTheme,
        contextMenuTheme,
        comboButtonTheme,
        iconTheme,
        scrollbarTheme,
        dividerColor,
        iconButtonTheme,
      ];

  AppKitThemeData copyWith({
    Brightness? brightness,
    Color? primaryColor,
    Color? activeColor,
    AppKitAccentColor? accentColor,
    Color? focusColor,
    Color? dividerColor,
    bool? isMainWindow,
    VisualDensity? visualDensity,
    AppKitTypography? typography,
    Color? canvasColor,
    Color? controlBackgroundColor,
    Color? controlBackgroundColorDisabled,
    Color? controlBackgroundPressedColor,
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
    AppKitIconThemeData? iconTheme,
    AppKitScrollbarThemeData? scrollbarTheme,
    AppKitIconButtonThemeData? iconButtonTheme,
  }) {
    return AppKitThemeData.raw(
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      activeColor: activeColor ?? this.activeColor,
      accentColor: accentColor ?? this.accentColor,
      focusColor: focusColor ?? this.focusColor,
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
      controlBackgroundColor:
          controlBackgroundColor ?? this.controlBackgroundColor,
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
      iconTheme: iconTheme ?? this.iconTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      dividerColor: dividerColor ?? this.dividerColor,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
    );
  }

  AppKitThemeData merge(AppKitThemeData? other) {
    if (other == null) return this;
    return copyWith(
      brightness: other.brightness,
      accentColor: other.accentColor,
      primaryColor: other.primaryColor,
      focusColor: other.focusColor,
      isMainWindow: other.isMainWindow,
      visualDensity: other.visualDensity,
      typography: other.typography,
      canvasColor: other.canvasColor,
      pushButtonTheme: other.pushButtonTheme,
      toggleButtonTheme: other.toggleButtonTheme,
      helpButtonTheme: other.helpButtonTheme,
      sliderTheme: other.sliderTheme,
      segmentedControlTheme: other.segmentedControlTheme,
      controlBackgroundColor: other.controlBackgroundColor,
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
      iconTheme: other.iconTheme,
      scrollbarTheme: other.scrollbarTheme,
      dividerColor: other.dividerColor,
      iconButtonTheme: other.iconButtonTheme,
    );
  }

  AppKitThemeData lerp(AppKitThemeData a, AppKitThemeData b, double t) {
    return AppKitThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      activeColor: Color.lerp(a.activeColor, b.activeColor, t)!,
      focusColor: Color.lerp(a.focusColor, b.focusColor, t)!,
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
      controlBackgroundColor:
          Color.lerp(a.controlBackgroundColor, b.controlBackgroundColor, t)!,
      controlBackgroundPressedColor: Color.lerp(
          a.controlBackgroundPressedColor, b.controlBackgroundPressedColor, t)!,
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
      iconTheme: AppKitIconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      scrollbarTheme:
          AppKitScrollbarThemeData.lerp(a.scrollbarTheme, b.scrollbarTheme, t),
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t)!,
      iconButtonTheme: AppKitIconButtonThemeData.lerp(
          a.iconButtonTheme, b.iconButtonTheme, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Brightness>('brightness', brightness));
    properties.add(ColorProperty('accentColor', primaryColor));
    properties.add(ColorProperty('primaryColor', primaryColor));
    properties.add(ColorProperty('focusColor', focusColor));
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
    properties
        .add(DiagnosticsProperty<AppKitIconThemeData>('iconTheme', iconTheme));
    properties.add(DiagnosticsProperty<AppKitScrollbarThemeData>(
        'scrollbarTheme', scrollbarTheme));
    properties.add(ColorProperty('dividerColor', dividerColor));
    properties.add(DiagnosticsProperty<AppKitIconButtonThemeData>(
        'iconButtonTheme', iconButtonTheme));
  }
}

class _ColorProvider {
  _ColorProvider._();

  /// Returns the primary color based on the provided parameters.
  static Color getPrimaryColor({
    required AppKitAccentColor accentColor,
    required bool isDark,
    required bool isMainWindow,
  }) {
    if (!isMainWindow) {
      return isDark
          ? const Color.fromRGBO(100, 100, 100, 0.625)
          : const Color.fromRGBO(190, 190, 190, 1.0);
    }

    switch (accentColor) {
      case AppKitAccentColor.blue:
        if (isDark) {
          return AppKitColors.systemBlue.darkColor;
        } else {
          return AppKitColors.systemBlue.color;
        }

      case AppKitAccentColor.purple:
        if (isDark) {
          return AppKitColors.systemPurple.darkColor;
        } else {
          return AppKitColors.systemPurple.color;
        }

      case AppKitAccentColor.pink:
        if (isDark) {
          return AppKitColors.systemPink.darkColor;
        } else {
          return AppKitColors.systemPink.color;
        }

      case AppKitAccentColor.red:
        if (isDark) {
          return AppKitColors.systemRed.darkColor;
        } else {
          return AppKitColors.systemRed.color;
        }

      case AppKitAccentColor.orange:
        if (isDark) {
          return AppKitColors.systemOrange.darkColor;
        } else {
          return AppKitColors.systemOrange.color;
        }

      case AppKitAccentColor.yellow:
        if (isDark) {
          return AppKitColors.systemYellow.darkColor;
        } else {
          return AppKitColors.systemYellow.color;
        }

      case AppKitAccentColor.green:
        if (isDark) {
          return AppKitColors.systemGreen.darkColor;
        } else {
          return AppKitColors.systemGreen.color;
        }

      case AppKitAccentColor.graphite:
        if (isDark) {
          return AppKitColors.systemGray.darkColor;
        } else {
          return AppKitColors.systemGray.color;
        }
    }
  }

  /// Returns the active color based on the provided parameters.
  static Color getActiveColor({
    required AppKitAccentColor accentColor,
    required bool isDark,
    required bool isMainWindow,
  }) {
    if (!isMainWindow) {
      return isDark
          ? const Color.fromRGBO(76, 78, 65, 1.0)
          : const Color.fromRGBO(180, 180, 180, 1.0);
    }

    switch (accentColor) {
      case AppKitAccentColor.blue:
        if (isDark) {
          return const Color.fromRGBO(0, 122, 255, 1.0);
        } else {
          return const Color.fromRGBO(10, 132, 255, 1.0);
        }

      case AppKitAccentColor.purple:
        if (isDark) {
          return const Color(0xFFbb3dc4);
        } else {
          return const Color.fromRGBO(218, 142, 255, 1.0);
        }

      case AppKitAccentColor.pink:
        if (isDark) {
          return const Color.fromRGBO(255, 45, 85, 1.0);
        } else {
          return const Color.fromRGBO(255, 55, 95, 1.0);
        }

      case AppKitAccentColor.red:
        if (isDark) {
          return const Color.fromRGBO(255, 59, 48, 1.0);
        } else {
          return const Color.fromRGBO(255, 69, 58, 1.0);
        }

      case AppKitAccentColor.orange:
        if (isDark) {
          return const Color.fromRGBO(255, 149, 0, 1.0);
        } else {
          return const Color.fromRGBO(255, 159, 10, 1.0);
        }

      case AppKitAccentColor.yellow:
        if (isDark) {
          return const Color.fromRGBO(255, 204, 0, 1.0);
        } else {
          return const Color.fromRGBO(255, 214, 10, 1.0);
        }

      case AppKitAccentColor.green:
        if (isDark) {
          return const Color.fromRGBO(76, 217, 100, 1.0);
        } else {
          return const Color.fromRGBO(76, 227, 110, 1.0);
        }

      case AppKitAccentColor.graphite:
        if (isDark) {
          return const Color.fromRGBO(142, 142, 142, 1.0);
        } else {
          return const Color.fromRGBO(142, 142, 142, 1.0);
        }
    }
  }
}

@protected
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
