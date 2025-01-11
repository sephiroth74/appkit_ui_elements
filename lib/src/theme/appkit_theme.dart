import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
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
  final AppKitAccentColor accentColor;
  final AppKitButtonThemeData buttonTheme;
  final AppKitCircularSliderThemeData circularSliderTheme;
  final AppKitColorWellThemeData colorWellTheme;
  final AppKitComboButtonThemeData comboButtonTheme;
  final AppKitContextMenuThemeData contextMenuTheme;
  final AppKitDateTimePickerThemeData dateTimePickerTheme;
  final AppKitIconButtonThemeData iconButtonTheme;
  final AppKitIconThemeData iconTheme;
  final AppKitLevelIndicatorsThemeData levelIndicatorsTheme;
  final AppKitPopupButtonThemeData popupButtonTheme;
  final AppKitProgressThemeData progressTheme;
  final AppKitRatingIndicatorThemeData ratingIndicatorTheme;
  final AppKitScrollbarThemeData scrollbarTheme;
  final AppKitSegmentedControlThemeData segmentedControlTheme;
  final AppKitSliderThemeData sliderTheme;
  final AppKitSwitchThemeData switchTheme;
  final AppKitTooltipThemeData tooltipTheme;
  final AppKitTypography typography;
  final bool isMainWindow;
  final Brightness brightness;
  final Color activeColor;
  final Color activeColorUnfocused;
  final Color canvasColor;
  final Color controlBackgroundColor;
  final Color controlBackgroundPressedColor;
  final Color controlColor;
  final Color dividerColor;
  final Color keyboardFocusIndicatorColor;
  final Color selectedTextBackgroundColor;
  final Color selectedControlColor;
  final VisualDensity visualDensity;

  /// The color to use for the background of selected and emphasized content.
  ///
  /// https://developer.apple.com/documentation/appkit/nscolor/selectedcontentbackgroundcolor
  final Color selectedContentBackgroundColor;
  final Color selectedContentBackgroundColorUnfocused;

  factory AppKitThemeData({
    Brightness brightness = Brightness.light,
    VisualDensity? visualDensity,
    AppKitButtonThemeData? buttonTheme,
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
    AppKitDateTimePickerThemeData? dateTimePickerTheme,
    AppKitAccentColor? accentColor,
    bool? isMainWindow,
    Color? canvasColor,
    Color? activeColor,
    Color? activeColorUnfocused,
    Color? controlBackgroundColor,
    Color? controlColor,
    Color? controlBackgroundPressedColor,
    Color? controlBackgroundColorDisabled,
    AppKitTypography? typography,
    Color? dividerColor,
    Color? keyboardFocusIndicatorColor,
    Color? selectedTextBackgroundColor,
    Color? selectedControlColor,
    Color? selectedContentBackgroundColor,
    Color? selectedContentBackgroundColorUnfocused,
  }) {
    final bool isDark = brightness == Brightness.dark;

    accentColor ??= AppKitAccentColor.blue;

    activeColor ??= _ColorProvider.getPrimaryColor(
      accentColor: accentColor,
      isDark: isDark,
      isMainWindow: true,
    );

    activeColorUnfocused ??= _ColorProvider.getPrimaryColor(
      accentColor: accentColor,
      isDark: isDark,
      isMainWindow: false,
    );

    keyboardFocusIndicatorColor ??=
        _ColorProvider.getKeyboardFocusIndicatorColor(
            isDark: isDark, accentColor: accentColor);

    selectedTextBackgroundColor ??=
        _ColorProvider.getSelectedTextBackgroundColor(
            isDark: isDark, accentColor: accentColor);

    selectedControlColor ??= _ColorProvider.getSelectedControlColor(
        isDark: isDark, accentColor: accentColor);

    selectedContentBackgroundColor ??=
        _ColorProvider.getSelectedContentBackgroundColor(
            accentColor: accentColor, isDark: isDark, isMainWindow: true);
    selectedContentBackgroundColorUnfocused ??=
        _ColorProvider.getSelectedContentBackgroundColor(
            accentColor: accentColor, isDark: isDark, isMainWindow: false);

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

    controlColor ??= isDark
        ? AppKitColors.controlColor.darkColor
        : AppKitColors.controlColor.color;

    Color controlBackgroundColorDisabledDark =
        AppKitColors.controlBackgroundColor.darkColor.withValues(alpha: 0.35);
    Color controlBackgroundColorDisabledLight =
        AppKitColors.controlBackgroundColor.color.withValues(alpha: 0.35);

    controlBackgroundColorDisabled ??= isDark
        ? controlBackgroundColorDisabledDark
        : controlBackgroundColorDisabledLight;

    controlBackgroundPressedColor ??= isDark
        ? AppKitColors.controlBackgroundPressedColor.darkColor
        : AppKitColors.controlBackgroundPressedColor.color;

    dividerColor ??= isDark
        ? AppKitColors.separatorColor.darkColor
        : AppKitColors.separatorColor.color;

    buttonTheme ??= AppKitButtonThemeData(
      inline: AppKitInlineButtonThemeData(
        secondaryColor: controlColor,
        destructiveColor: isDark
            ? AppKitColors.systemRed.darkColor
            : AppKitColors.systemRed.color,
        accentColor: activeColor,
        backgroundColorDisabled: isDark
            ? controlColor.multiplyOpacity(0.5)
            : controlColor.multiplyOpacity(0.5),
      ),
      flat: AppKitFlatButtonThemeData(
        secondaryColor: controlColor,
        destructiveColor: isDark
            ? AppKitColors.systemRed.darkColor
            : AppKitColors.systemRed.color,
        accentColor: activeColor,
        backgroundColorDisabled: isDark
            ? controlColor.multiplyOpacity(0.5)
            : controlColor.multiplyOpacity(0.5),
      ),
      push: AppKitPushButtonThemeData(
        secondaryColor: controlColor,
        destructiveColor: isDark
            ? AppKitColors.systemRed.darkColor
            : AppKitColors.systemRed.color,
        accentColor: selectedContentBackgroundColor,
        backgroundColorDisabled: isDark
            ? controlColor.multiplyOpacity(0.75)
            : controlColor.multiplyOpacity(0.75),
      ),
    );

    sliderTheme ??= AppKitSliderThemeData(
      trackColor: isDark
          ? AppKitColors.controlColor.darkColor
          : const Color(0xFFe1e0de),
      thumbColor: AppKitColors.controlColor.color,
      sliderColor: activeColor,
      tickColor: isDark
          ? const Color.fromARGB(255, 155, 155, 155)
          : const Color(0xFFC9C9C7),
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
      accentColorUnfocused: activeColorUnfocused,
    );

    levelIndicatorsTheme ??= AppKitLevelIndicatorsThemeData(
      normalColor: AppKitColors.systemGreen,
      warningColor: AppKitColors.systemYellow,
      criticalColor: AppKitColors.systemRed,
      strokeColor: AppKitColors.systemGray.withValues(alpha: 0.5),
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
      backgroundColor: isDark
          ? AppKitColors.controlColor.darkColor
          : AppKitColors.controlColor.color,
      thumbColor: isDark
          ? Colors.black.withValues(alpha: 0.75)
          : Colors.black.withValues(alpha: 0.5),
      thumbColorUnfocused: activeColorUnfocused,
    );

    segmentedControlTheme ??= AppKitSegmentedControlThemeData(
      accentColor: selectedContentBackgroundColor,
      dividerColorMultipleSelection: isDark
          ? AppKitColors.separatorColor.darkColor
          : const Color(0xFFE8E8E8),
      dividerColorSingleSelection: isDark
          ? AppKitColors.separatorColor.darkColor
          : const Color(0xFFCCCBCB),
      singleSelectionColor: isDark
          ? AppKitColors.materials.ultraThin.elevatedColor
          : AppKitColors.controlColor.color,
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
      accentColorUnfocused: activeColorUnfocused,
    );

    colorWellTheme ??= AppKitColorWellThemeData(
      borderRadiusMinimal: 5.5,
      borderRadiusExpanded: 5.5,
      borderRadiusRegular: 5.5,
      borderRadiusRegularInner: 2.0,
    );

    tooltipTheme ??= AppKitTooltipThemeData(
        verticalOffset: 18.0,
        padding:
            const EdgeInsets.only(left: 6.0, top: 3.0, right: 6.0, bottom: 5.0),
        margin: EdgeInsets.zero,
        preferBelow: true,
        waitDuration: const Duration(seconds: 1),
        showDuration: const Duration(seconds: 10),
        minHeight: 24.0,
        textStyle: typography.callout.copyWith(
          fontSize: 13.0,
          color: isDark
              ? AppKitColors.text.opaque.secondary.darkColor
              : const Color(0xFF4D4D4D),
        ),
        decoration: () {
          const radius = BorderRadius.all(Radius.circular(2.0));
          final shadow = [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 0.0,
              spreadRadius: 0.5,
              color: AppKitColors.shadowColor.withValues(alpha: 0.12),
            ),
            BoxShadow(
              color: AppKitColors.shadowColor.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              spreadRadius: 0,
              blurRadius: 6,
            ),
          ];
          final border = Border.all(
            width: 0.5,
            color: isDark
                ? const Color.fromRGBO(144, 144, 144, 1.0)
                : const Color(0xFF4D4D4D),
          );

          return BoxDecoration(
            color: isDark
                ? AppKitColors.unemphasizedSelectedTextBackgroundColor.darkColor
                : const Color(0xFFF6F6F6),
            borderRadius: radius,
            boxShadow: shadow,
            border: border,
          );
        }());

    popupButtonTheme ??= AppKitPopupButtonThemeData.fallback(
      brightness: brightness,
      typography: typography,
      elevatedButtonColor: activeColor,
    );

    comboButtonTheme ??= AppKitComboButtonThemeData.fallback(
      brightness: brightness,
      typography: typography,
    );

    contextMenuTheme ??= AppKitContextMenuThemeData(
      backgroundBlur: 2,
      borderRadius: 6.0,
      backgroundColor: isDark
          ? AppKitColors.controlBackgroundColor.darkColor
              .withValues(alpha: 0.85)
          : const Color(0xFFe7e7e7),
    );

    iconTheme ??= AppKitIconThemeData(
      color: activeColor,
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

    iconButtonTheme ??= AppKitIconButtonTheme.fallback(brightness);

    dateTimePickerTheme ??= AppKitDateTimePickerThemeData(
      graphicalDatePickerBackgroundColor: (isDark
              ? AppKitColors.controlColor.darkColor
              : AppKitColors.controlColor.color)
          .multiplyOpacity(0.5),
      textualDatePickerBackgroundColor: (isDark
              ? AppKitColors.controlColor.darkColor
              : AppKitColors.controlColor.color)
          .multiplyOpacity(0.5),
      accentColor: activeColor,
    );

    final defaultData = AppKitThemeData.raw(
      accentColor: accentColor,
      activeColor: activeColor,
      activeColorUnfocused: activeColorUnfocused,
      brightness: brightness,
      buttonTheme: buttonTheme,
      canvasColor: canvasColor,
      circularSliderTheme: circularSliderTheme,
      colorWellTheme: colorWellTheme,
      comboButtonTheme: comboButtonTheme,
      contextMenuTheme: contextMenuTheme,
      controlBackgroundColor: controlBackgroundColor,
      controlBackgroundPressedColor: controlBackgroundPressedColor,
      controlColor: controlColor,
      dateTimePickerTheme: dateTimePickerTheme,
      dividerColor: dividerColor,
      iconButtonTheme: iconButtonTheme,
      iconTheme: iconTheme,
      isMainWindow: isMainWindow,
      keyboardFocusIndicatorColor: keyboardFocusIndicatorColor,
      selectedTextBackgroundColor: selectedTextBackgroundColor,
      selectedControlColor: selectedControlColor,
      levelIndicatorsTheme: levelIndicatorsTheme,
      popupButtonTheme: popupButtonTheme,
      progressTheme: progressTheme,
      ratingIndicatorTheme: ratingIndicatorTheme,
      scrollbarTheme: scrollbarTheme,
      segmentedControlTheme: segmentedControlTheme,
      selectedContentBackgroundColor: selectedContentBackgroundColor,
      selectedContentBackgroundColorUnfocused:
          selectedContentBackgroundColorUnfocused,
      sliderTheme: sliderTheme,
      switchTheme: switchTheme,
      tooltipTheme: tooltipTheme,
      typography: typography,
      visualDensity: visualDensity,
    );

    final customData = defaultData.copyWith(
      accentColor: accentColor,
      activeColor: activeColor,
      activeColorUnfocused: activeColorUnfocused,
      brightness: brightness,
      buttonTheme: buttonTheme,
      canvasColor: canvasColor,
      colorWellTheme: colorWellTheme,
      comboButtonTheme: comboButtonTheme,
      contextMenuTheme: contextMenuTheme,
      controlBackgroundColor: controlBackgroundColor,
      controlBackgroundColorDisabled: controlBackgroundColorDisabled,
      controlBackgroundPressedColor: controlBackgroundPressedColor,
      controlColor: controlColor,
      dateTimePickerTheme: dateTimePickerTheme,
      dividerColor: dividerColor,
      iconButtonTheme: iconButtonTheme,
      iconTheme: iconTheme,
      isMainWindow: isMainWindow,
      keyboardFocusIndicatorColor: keyboardFocusIndicatorColor,
      selectedTextBackgroundColor: selectedTextBackgroundColor,
      selectedControlColor: selectedControlColor,
      levelIndicatorsTheme: levelIndicatorsTheme,
      popupButtonTheme: popupButtonTheme,
      progressTheme: progressTheme,
      ratingIndicatorTheme: ratingIndicatorTheme,
      scrollbarTheme: scrollbarTheme,
      segmentedControlTheme: segmentedControlTheme,
      selectedContentBackgroundColor: selectedContentBackgroundColor,
      selectedContentBackgroundColorUnfocused:
          selectedContentBackgroundColorUnfocused,
      sliderTheme: sliderTheme,
      switchTheme: switchTheme,
      tooltipTheme: tooltipTheme,
      typography: typography,
      visualDensity: visualDensity,
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
    required this.activeColor,
    required this.activeColorUnfocused,
    required this.dividerColor,
    required this.isMainWindow,
    required this.visualDensity,
    required this.typography,
    required this.buttonTheme,
    required this.sliderTheme,
    required this.segmentedControlTheme,
    required this.switchTheme,
    required this.progressTheme,
    required this.colorWellTheme,
    required this.circularSliderTheme,
    required this.canvasColor,
    required this.controlBackgroundPressedColor,
    required this.controlBackgroundColor,
    required this.controlColor,
    required this.levelIndicatorsTheme,
    required this.ratingIndicatorTheme,
    required this.tooltipTheme,
    required this.popupButtonTheme,
    required this.contextMenuTheme,
    required this.comboButtonTheme,
    required this.iconTheme,
    required this.scrollbarTheme,
    required this.iconButtonTheme,
    required this.dateTimePickerTheme,
    required this.keyboardFocusIndicatorColor,
    required this.selectedTextBackgroundColor,
    required this.selectedControlColor,
    required this.selectedContentBackgroundColor,
    required this.selectedContentBackgroundColorUnfocused,
  });

  @override
  List<Object?> get props => [
        brightness,
        activeColor,
        activeColorUnfocused,
        isMainWindow,
        visualDensity,
        canvasColor,
        typography,
        buttonTheme,
        sliderTheme,
        segmentedControlTheme,
        switchTheme,
        progressTheme,
        colorWellTheme,
        controlBackgroundColor,
        controlColor,
        controlBackgroundPressedColor,
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
        buttonTheme,
        dateTimePickerTheme,
        keyboardFocusIndicatorColor,
        selectedTextBackgroundColor,
        selectedControlColor,
        selectedContentBackgroundColor,
        selectedContentBackgroundColorUnfocused,
      ];

  AppKitThemeData copyWith({
    AppKitAccentColor? accentColor,
    AppKitButtonThemeData? buttonTheme,
    AppKitCircularSliderThemeData? circularSliderTheme,
    AppKitColorWellThemeData? colorWellTheme,
    AppKitComboButtonThemeData? comboButtonTheme,
    AppKitContextMenuThemeData? contextMenuTheme,
    AppKitDateTimePickerThemeData? dateTimePickerTheme,
    AppKitIconButtonThemeData? iconButtonTheme,
    AppKitIconThemeData? iconTheme,
    AppKitLevelIndicatorsThemeData? levelIndicatorsTheme,
    AppKitPopupButtonThemeData? popupButtonTheme,
    AppKitProgressThemeData? progressTheme,
    AppKitRatingIndicatorThemeData? ratingIndicatorTheme,
    AppKitScrollbarThemeData? scrollbarTheme,
    AppKitSegmentedControlThemeData? segmentedControlTheme,
    AppKitSliderThemeData? sliderTheme,
    AppKitSwitchThemeData? switchTheme,
    AppKitTooltipThemeData? tooltipTheme,
    AppKitTypography? typography,
    bool? isMainWindow,
    Brightness? brightness,
    Color? activeColor,
    Color? activeColorUnfocused,
    Color? canvasColor,
    Color? controlBackgroundColor,
    Color? controlBackgroundColorDisabled,
    Color? controlBackgroundPressedColor,
    Color? controlColor,
    Color? dividerColor,
    Color? keyboardFocusIndicatorColor,
    Color? selectedTextBackgroundColor,
    Color? selectedControlColor,
    Color? selectedContentBackgroundColor,
    Color? selectedContentBackgroundColorUnfocused,
    VisualDensity? visualDensity,
  }) {
    return AppKitThemeData.raw(
      accentColor: accentColor ?? this.accentColor,
      activeColor: activeColor ?? this.activeColor,
      activeColorUnfocused: activeColorUnfocused ?? this.activeColorUnfocused,
      brightness: brightness ?? this.brightness,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      canvasColor: canvasColor ?? this.canvasColor,
      circularSliderTheme: circularSliderTheme ?? this.circularSliderTheme,
      colorWellTheme: colorWellTheme ?? this.colorWellTheme,
      comboButtonTheme: comboButtonTheme ?? this.comboButtonTheme,
      contextMenuTheme: contextMenuTheme ?? this.contextMenuTheme,
      controlBackgroundColor:
          controlBackgroundColor ?? this.controlBackgroundColor,
      controlBackgroundPressedColor:
          controlBackgroundPressedColor ?? this.controlBackgroundPressedColor,
      controlColor: controlColor ?? this.controlColor,
      dateTimePickerTheme: dateTimePickerTheme ?? this.dateTimePickerTheme,
      dividerColor: dividerColor ?? this.dividerColor,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      iconTheme: iconTheme ?? this.iconTheme,
      isMainWindow: isMainWindow ?? this.isMainWindow,
      keyboardFocusIndicatorColor:
          keyboardFocusIndicatorColor ?? this.keyboardFocusIndicatorColor,
      selectedTextBackgroundColor:
          selectedTextBackgroundColor ?? this.selectedTextBackgroundColor,
      selectedControlColor: selectedControlColor ?? this.selectedControlColor,
      levelIndicatorsTheme: levelIndicatorsTheme ?? this.levelIndicatorsTheme,
      popupButtonTheme: popupButtonTheme ?? this.popupButtonTheme,
      progressTheme: progressTheme ?? this.progressTheme,
      ratingIndicatorTheme: ratingIndicatorTheme ?? this.ratingIndicatorTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      segmentedControlTheme:
          segmentedControlTheme ?? this.segmentedControlTheme,
      selectedContentBackgroundColor:
          selectedContentBackgroundColor ?? this.selectedContentBackgroundColor,
      selectedContentBackgroundColorUnfocused:
          selectedContentBackgroundColorUnfocused ??
              this.selectedContentBackgroundColorUnfocused,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
      typography: typography ?? this.typography,
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }

  AppKitThemeData merge(AppKitThemeData? other) {
    if (other == null) return this;
    return copyWith(
      accentColor: other.accentColor,
      activeColor: other.activeColor,
      activeColorUnfocused: other.activeColorUnfocused,
      brightness: other.brightness,
      buttonTheme: other.buttonTheme,
      canvasColor: other.canvasColor,
      circularSliderTheme: other.circularSliderTheme,
      colorWellTheme: other.colorWellTheme,
      comboButtonTheme: other.comboButtonTheme,
      contextMenuTheme: other.contextMenuTheme,
      controlBackgroundColor: other.controlBackgroundColor,
      controlBackgroundPressedColor: other.controlBackgroundPressedColor,
      controlColor: other.controlColor,
      dateTimePickerTheme: other.dateTimePickerTheme,
      dividerColor: other.dividerColor,
      iconButtonTheme: other.iconButtonTheme,
      iconTheme: other.iconTheme,
      isMainWindow: other.isMainWindow,
      keyboardFocusIndicatorColor: other.keyboardFocusIndicatorColor,
      selectedTextBackgroundColor: other.selectedTextBackgroundColor,
      selectedControlColor: other.selectedControlColor,
      levelIndicatorsTheme: other.levelIndicatorsTheme,
      popupButtonTheme: other.popupButtonTheme,
      progressTheme: other.progressTheme,
      ratingIndicatorTheme: other.ratingIndicatorTheme,
      scrollbarTheme: other.scrollbarTheme,
      segmentedControlTheme: other.segmentedControlTheme,
      selectedContentBackgroundColor: other.selectedContentBackgroundColor,
      selectedContentBackgroundColorUnfocused:
          other.selectedContentBackgroundColorUnfocused,
      sliderTheme: other.sliderTheme,
      switchTheme: other.switchTheme,
      tooltipTheme: other.tooltipTheme,
      typography: other.typography,
      visualDensity: other.visualDensity,
    );
  }

  AppKitThemeData lerp(AppKitThemeData a, AppKitThemeData b, double t) {
    return AppKitThemeData.raw(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      accentColor: t < 0.5 ? a.accentColor : b.accentColor,
      activeColor: Color.lerp(a.activeColor, b.activeColor, t)!,
      activeColorUnfocused:
          Color.lerp(a.activeColorUnfocused, b.activeColorUnfocused, t)!,
      isMainWindow: t < 0.5 ? a.isMainWindow : b.isMainWindow,
      visualDensity: VisualDensity.lerp(a.visualDensity, b.visualDensity, t),
      typography: AppKitTypography.lerp(a.typography, b.typography, t),
      buttonTheme: AppKitButtonThemeData.lerp(a.buttonTheme, b.buttonTheme, t),
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t)!,
      sliderTheme: AppKitSliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      segmentedControlTheme: AppKitSegmentedControlThemeData.lerp(
          a.segmentedControlTheme, b.segmentedControlTheme, t),
      controlBackgroundColor:
          Color.lerp(a.controlBackgroundColor, b.controlBackgroundColor, t)!,
      controlColor: Color.lerp(a.controlColor, b.controlColor, t)!,
      controlBackgroundPressedColor: Color.lerp(
          a.controlBackgroundPressedColor, b.controlBackgroundPressedColor, t)!,
      switchTheme: AppKitSwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      progressTheme:
          AppKitProgressThemeData.lerp(a.progressTheme, b.progressTheme, t),
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
      keyboardFocusIndicatorColor: Color.lerp(
          a.keyboardFocusIndicatorColor, b.keyboardFocusIndicatorColor, t)!,
      selectedTextBackgroundColor: Color.lerp(
          a.selectedTextBackgroundColor, b.selectedTextBackgroundColor, t)!,
      selectedControlColor:
          Color.lerp(a.selectedControlColor, b.selectedControlColor, t)!,
      selectedContentBackgroundColor: Color.lerp(
          a.selectedContentBackgroundColor,
          b.selectedContentBackgroundColor,
          t)!,
      selectedContentBackgroundColorUnfocused: Color.lerp(
          a.selectedContentBackgroundColorUnfocused,
          b.selectedContentBackgroundColorUnfocused,
          t)!,
      dateTimePickerTheme: AppKitDateTimePickerThemeData.lerp(
          a.dateTimePickerTheme, b.dateTimePickerTheme, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Brightness>('brightness', brightness));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('activeColorUnfocused', activeColorUnfocused));
    properties.add(FlagProperty('isMainWindow',
        value: isMainWindow, ifTrue: 'main window'));
    properties.add(
        DiagnosticsProperty<VisualDensity>('visualDensity', visualDensity));
    properties.add(ColorProperty('canvasColor', canvasColor));
    properties
        .add(DiagnosticsProperty<AppKitTypography>('typography', typography));
    properties.add(
        DiagnosticsProperty<AppKitButtonThemeData>('buttonTheme', buttonTheme));
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
    properties.add(ColorProperty(
        'keyboardFocusIndicatorColor', keyboardFocusIndicatorColor));
    properties.add(ColorProperty(
        'selectedTextBackgroundColor', selectedTextBackgroundColor));
    properties.add(ColorProperty('selectedControlColor', selectedControlColor));
    properties.add(ColorProperty(
        'selectedContentBackgroundColor', selectedContentBackgroundColor));
    properties.add(ColorProperty('selectedContentBackgroundColorUnfocused',
        selectedContentBackgroundColorUnfocused));
    properties.add(DiagnosticsProperty<AppKitDateTimePickerThemeData>(
        'dateTimePickerTheme', dateTimePickerTheme));
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
        return isDark ? const Color(0xFF007AFF) : const Color(0xFF007AFF);

      case AppKitAccentColor.purple:
        return isDark ? const Color(0xFFA550A7) : const Color(0xFF953D96);

      case AppKitAccentColor.pink:
        return isDark ? const Color(0xFFF74F9E) : const Color(0xFFF74F9E);

      case AppKitAccentColor.red:
        return isDark ? const Color(0xFFFF5257) : const Color(0xFFE0383E);

      case AppKitAccentColor.orange:
        return isDark ? const Color(0xFFF7821B) : const Color(0xFFF7821B);

      case AppKitAccentColor.yellow:
        return isDark ? const Color(0xFFFFC600) : const Color(0xFFFFC726);

      case AppKitAccentColor.green:
        return isDark ? const Color(0xFF62BA46) : const Color(0xFF62BA46);

      case AppKitAccentColor.graphite:
        return isDark ? const Color(0xFF8C8C8C) : const Color(0xFF989898);
    }
  }

  static Color getActiveColorUnfocused({required bool isDark}) {
    return isDark
        ? const Color.fromRGBO(76, 78, 65, 1.0)
        : const Color.fromRGBO(180, 180, 180, 1.0);
  }

  /// The color to use for the background of selected and emphasized content.
  static Color getSelectedContentBackgroundColor({
    required AppKitAccentColor accentColor,
    required bool isDark,
    required bool isMainWindow,
  }) {
    if (!isMainWindow) {
      return getActiveColorUnfocused(isDark: isDark);
    }

    switch (accentColor) {
      case AppKitAccentColor.blue:
        return isDark ? const Color(0xFF0059D1) : const Color(0xFF0064E1);
      case AppKitAccentColor.purple:
        return isDark ? const Color(0xFF803482) : const Color(0xFF7D2A7E);
      case AppKitAccentColor.pink:
        return isDark ? const Color(0xFFC93379) : const Color(0xFFD93B86);
      case AppKitAccentColor.red:
        return isDark ? const Color(0xFFD13539) : const Color(0xFFC4262B);
      case AppKitAccentColor.orange:
        return isDark ? const Color(0xFFC96003) : const Color(0xFFD96B0A);
      case AppKitAccentColor.yellow:
        return isDark ? const Color(0xFFD19E00) : const Color(0xFFE1AC15);
      case AppKitAccentColor.green:
        return isDark ? const Color(0xFF43932A) : const Color(0xFF4DA033);
      case AppKitAccentColor.graphite:
        return isDark ? const Color(0xFF696969) : const Color(0xFF808080);
    }
  }

  static Color getKeyboardFocusIndicatorColor(
      {required AppKitAccentColor accentColor, required bool isDark}) {
    switch (accentColor) {
      case AppKitAccentColor.blue:
        return isDark ? const Color(0x7F1AA9FF) : const Color(0x7F0067F4);
      case AppKitAccentColor.purple:
        return isDark ? const Color(0x7FDC78DE) : const Color(0x7F842685);
      case AppKitAccentColor.pink:
        return isDark ? const Color(0x7FFF77D4) : const Color(0x7FEC398D);
      case AppKitAccentColor.red:
        return isDark ? const Color(0x7FFF7A80) : const Color(0x7FD32127);
      case AppKitAccentColor.orange:
        return isDark ? const Color(0x7FFFB33A) : const Color(0x7FFFB33A);
      case AppKitAccentColor.yellow:
        return isDark ? const Color(0x7FFFFF1A) : const Color(0x7FF4B90E);
      case AppKitAccentColor.green:
        return isDark ? const Color(0x7F8DF56C) : const Color(0x7F4EAB30);
      case AppKitAccentColor.graphite:
        return isDark ? const Color(0x7FBFBFBF) : const Color(0xFF99999E);
    }
  }

  static Color getSelectedTextBackgroundColor(
      {required AppKitAccentColor accentColor, required bool isDark}) {
    switch (accentColor) {
      case AppKitAccentColor.blue:
        return !isDark ? const Color(0xFFB3D7FF) : const Color(0xFF3F638B);
      case AppKitAccentColor.purple:
        return !isDark ? const Color(0xFFDFC5E0) : const Color(0xFF705771);
      case AppKitAccentColor.pink:
        return !isDark ? const Color(0xFFFDCBE2) : const Color(0xFF89576E);
      case AppKitAccentColor.red:
        return !isDark ? const Color(0xFFF6C4C5) : const Color(0xFF8B5759);
      case AppKitAccentColor.orange:
        return !isDark ? const Color(0xFFFDDABB) : const Color(0xFF896647);
      case AppKitAccentColor.yellow:
        return !isDark ? const Color(0xFFFFEEBE) : const Color(0xFF8B7A3F);
      case AppKitAccentColor.green:
        return !isDark ? const Color(0xFFD0EAC8) : const Color(0xFF5C7654);
      case AppKitAccentColor.graphite:
        return !isDark ? const Color(0xFFE0E0E0) : const Color(0x3FFFFFFF);
    }
  }

  static Color getSelectedControlColor(
      {required AppKitAccentColor accentColor, required bool isDark}) {
    switch (accentColor) {
      case AppKitAccentColor.blue:
        return !isDark ? const Color(0xFFB3D7FF) : const Color(0xFF3F638B);
      case AppKitAccentColor.purple:
        return !isDark ? const Color(0xFFDFC5E0) : const Color(0xFF705771);
      case AppKitAccentColor.pink:
        return !isDark ? const Color(0xFFFDCBE2) : const Color(0xFF89576E);
      case AppKitAccentColor.red:
        return !isDark ? const Color(0xFFF6C4C5) : const Color(0xFF8B5759);
      case AppKitAccentColor.orange:
        return !isDark ? const Color(0xFFFDDABB) : const Color(0xFF896647);
      case AppKitAccentColor.yellow:
        return !isDark ? const Color(0xFFFFEEBE) : const Color(0xFF8B7A3F);
      case AppKitAccentColor.green:
        return !isDark ? const Color(0xFFD0EAC8) : const Color(0xFF5C7654);
      case AppKitAccentColor.graphite:
        return !isDark ? const Color(0xFFE0E0E0) : const Color(0x3FFFFFFF);
    }
  }
}
