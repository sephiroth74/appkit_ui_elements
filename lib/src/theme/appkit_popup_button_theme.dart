import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppKitPopupButtonTheme extends InheritedTheme {
  final AppKitPopupButtonThemeData data;

  const AppKitPopupButtonTheme({super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppKitPopupButtonTheme && oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitPopupButtonTheme(data: data, child: child);
  }

  static AppKitPopupButtonThemeData of(BuildContext context) {
    final AppKitPopupButtonTheme? theme = context.dependOnInheritedWidgetOfExactType<AppKitPopupButtonTheme>();
    return theme?.data ?? AppKitTheme.of(context).popupButtonTheme;
  }
}

class AppKitPopupButtonThemeData with Diagnosticable {
  final Color? elevatedButtonColor;
  final Color plainButtonColor;
  final Color arrowsColor;
  final Map<AppKitControlSize, AppKitPopupThemeSizeData> sizeData;

  AppKitPopupButtonThemeData({
    this.elevatedButtonColor,
    required this.arrowsColor,
    required this.plainButtonColor,
    required this.sizeData,
  });

  static AppKitPopupButtonThemeData fallback({
    required Brightness brightness,
    required AppKitTypography typography,
    Color? elevatedButtonColor,
  }) {
    final isDark = brightness == Brightness.dark;

    final plainButtonColor = (isDark ? AppKitColors.systemGray.darkColor : AppKitColors.systemGray.color).withValues(
      alpha: 0.2,
    );
    final arrowsColor = isDark ? AppKitColors.labelColor.darkColor : AppKitColors.labelColor.color;

    final inlineTextStyle = typography.subheadline.copyWith(fontWeight: FontWeight.w500);

    // large
    final largeSize = AppKitPopupThemeSizeData(
      height: 30.0,
      inlineHeight: 30.0 * 1.25,
      inlineBorderRadius: (30.0 * 1.25) / 2.0,
      textStyle: typography.body.copyWith(fontSize: 13.5),
      inlineTextStyle: inlineTextStyle.copyWith(fontSize: 13.5),
      borderRadius: 6.5,
      arrowsStrokeWidth: 1.75,
      arrowsSize: const Size(7.5, 12.5),
      childPadding: const EdgeInsets.only(bottom: 2.0, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 2.0, right: 1.0),
      containerPadding: const EdgeInsets.only(left: 9.0, right: 3.0),
      inlineContainerPadding: const EdgeInsets.only(left: 10.0, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // regular
    final regularSize = AppKitPopupThemeSizeData(
      height: 21.0,
      inlineHeight: 21.0 * 1.25,
      inlineBorderRadius: (21.0 * 1.25) / 2.0,
      textStyle: typography.body,
      inlineTextStyle: inlineTextStyle,
      borderRadius: 6,
      arrowsStrokeWidth: 1.75,
      arrowsSize: const Size(5.5, 10),
      childPadding: const EdgeInsets.only(bottom: 2.5, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 2.0, right: 1.0),
      containerPadding: const EdgeInsets.only(left: 7.5, right: 3),
      inlineContainerPadding: const EdgeInsets.only(left: 10.0, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // small
    final smallSize = AppKitPopupThemeSizeData(
      height: 18.0,
      inlineHeight: 18.0 * 1.25,
      inlineBorderRadius: (18.0 * 1.25) / 2.0,
      textStyle: typography.body.copyWith(fontSize: 10.0),
      inlineTextStyle: inlineTextStyle.copyWith(fontSize: 10.0), // TBD
      borderRadius: 5.0,
      arrowsStrokeWidth: 1.25,
      arrowsSize: const Size(5.0, 8.0),
      childPadding: const EdgeInsets.only(bottom: 1.0, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 1.5, right: 1.0),
      containerPadding: const EdgeInsets.only(left: 6.0, right: 3.0),
      inlineContainerPadding: const EdgeInsets.only(left: 7.5, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // mini
    final miniSize = AppKitPopupThemeSizeData(
      height: 15.0,
      inlineHeight: 15.0 * 1.25,
      inlineBorderRadius: (15.0 * 1.25) / 2.0,
      textStyle: typography.body.copyWith(fontSize: 9.0),
      inlineTextStyle: inlineTextStyle.copyWith(fontSize: 9.0), // TBD
      borderRadius: 3.0,
      arrowsStrokeWidth: 1.0,
      arrowsSize: const Size(3.0, 5.5),
      childPadding: const EdgeInsets.only(bottom: 0.5, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 1.0, right: 1.0),
      containerPadding: const EdgeInsets.only(left: 5.0, right: 3.0),
      inlineContainerPadding: const EdgeInsets.only(left: 7.5, top: 0.5, right: 4.5, bottom: 0.5),
    );

    final sizeData = {
      AppKitControlSize.mini: miniSize,
      AppKitControlSize.small: smallSize,
      AppKitControlSize.regular: regularSize,
      AppKitControlSize.large: largeSize,
    };

    return AppKitPopupButtonThemeData(arrowsColor: arrowsColor, plainButtonColor: plainButtonColor, sizeData: sizeData);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('elevatedButtonColor', elevatedButtonColor));
    properties.add(ColorProperty('plainButtonColor', plainButtonColor));
    properties.add(ColorProperty('arrowsColor', arrowsColor));
    properties.add(DiagnosticsProperty<Map<AppKitControlSize, AppKitPopupThemeSizeData>>('sizeData', sizeData));
  }

  AppKitPopupButtonThemeData copyWith({
    Color? elevatedButtonColor,
    Color? plainButtonColor,
    Color? arrowsColor,
    Map<AppKitControlSize, AppKitPopupThemeSizeData>? sizeData,
  }) {
    return AppKitPopupButtonThemeData(
      elevatedButtonColor: elevatedButtonColor ?? this.elevatedButtonColor,
      plainButtonColor: plainButtonColor ?? this.plainButtonColor,
      arrowsColor: arrowsColor ?? this.arrowsColor,
      sizeData: sizeData ?? this.sizeData,
    );
  }

  AppKitPopupButtonThemeData merge(AppKitPopupButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      elevatedButtonColor: other.elevatedButtonColor,
      plainButtonColor: other.plainButtonColor,
      arrowsColor: other.arrowsColor,
      sizeData: Map.fromEntries(
        sizeData.entries.map((entry) {
          return MapEntry(entry.key, entry.value.merge(other.sizeData[entry.key]));
        }),
      ),
    );
  }

  static AppKitPopupButtonThemeData lerp(AppKitPopupButtonThemeData a, AppKitPopupButtonThemeData b, double t) {
    return AppKitPopupButtonThemeData(
      elevatedButtonColor: Color.lerp(a.elevatedButtonColor, b.elevatedButtonColor, t),
      plainButtonColor: Color.lerp(a.plainButtonColor, b.plainButtonColor, t)!,
      arrowsColor: Color.lerp(a.arrowsColor, b.arrowsColor, t)!,
      sizeData: Map.fromEntries(
        a.sizeData.entries.map((entry) {
          return MapEntry(entry.key, AppKitPopupThemeSizeData.lerp(entry.value, b.sizeData[entry.key]!, t));
        }),
      ),
    );
  }
}

class AppKitPopupThemeSizeData with Diagnosticable {
  final double height;
  final double inlineHeight;
  final double iconSize;
  final double inlineIconsSize;

  final TextStyle textStyle;
  final TextStyle inlineTextStyle;
  final double borderRadius;
  final double arrowsStrokeWidth;
  final Size arrowsSize;
  final EdgeInsets childPadding;
  final EdgeInsets inlineChildPadding;
  final EdgeInsets containerPadding;
  final EdgeInsets inlineContainerPadding;
  final double inlineBorderRadius;
  final Color? inlineBackgroundColor;
  final Color? inlineHoveredBackgroundColor;
  final Color? inlinePressedBackgroundColor;
  final double arrowsButtonSize;

  double get textPadding => 4.0;

  AppKitPopupThemeSizeData({
    this.height = 21.0,
    this.inlineHeight = 21.0 * 1.25,
    this.borderRadius = 6.0,
    this.arrowsStrokeWidth = 1.75,
    this.arrowsSize = const Size(5.5, 10),
    required this.textStyle,
    required this.inlineTextStyle,
    this.childPadding = const EdgeInsets.only(bottom: 2.5, right: 4.0),
    this.containerPadding = const EdgeInsets.only(left: 7.5, right: 3),
    this.inlineChildPadding = const EdgeInsets.only(bottom: 2.0, right: 1.0),
    this.inlineContainerPadding = const EdgeInsets.only(left: 10.0, top: 0.5, right: 4.5, bottom: 0.5),
    required this.inlineBorderRadius,
    this.inlineBackgroundColor,
    this.inlineHoveredBackgroundColor,
    this.inlinePressedBackgroundColor,
    double? arrowsButtonSize,
    double? iconSize,
    double? inlineIconsSize,
  }) : arrowsButtonSize = arrowsButtonSize ?? height - 5.0,
       iconSize = iconSize ?? textStyle.fontSize! * 1.2,
       inlineIconsSize = inlineIconsSize ?? inlineTextStyle.fontSize! * 1.2;

  AppKitPopupThemeSizeData copyWith({
    Color? inlineBackgroundColor,
    Color? inlineHoveredBackgroundColor,
    Color? inlinePressedBackgroundColor,
    double? arrowsButtonSize,
    double? arrowsStrokeWidth,
    double? borderRadius,
    double? height,
    double? iconSize,
    double? inlineBorderRadius,
    double? inlineHeight,
    double? inlineIconsSize,
    EdgeInsets? childPadding,
    EdgeInsets? containerPadding,
    EdgeInsets? inlineChildPadding,
    EdgeInsets? inlineContainerPadding,
    Size? arrowsSize,
    TextStyle? inlineTextStyle,
    TextStyle? textStyle,
  }) {
    return AppKitPopupThemeSizeData(
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      inlineTextStyle: inlineTextStyle ?? this.inlineTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      arrowsStrokeWidth: arrowsStrokeWidth ?? this.arrowsStrokeWidth,
      arrowsSize: arrowsSize ?? this.arrowsSize,
      childPadding: childPadding ?? this.childPadding,
      inlineChildPadding: inlineChildPadding ?? this.inlineChildPadding,
      containerPadding: containerPadding ?? this.containerPadding,
      inlineContainerPadding: inlineContainerPadding ?? this.inlineContainerPadding,
      inlineBorderRadius: inlineBorderRadius ?? this.inlineBorderRadius,
      inlineHeight: inlineHeight ?? this.inlineHeight,
      inlineBackgroundColor: inlineBackgroundColor ?? this.inlineBackgroundColor,
      inlineHoveredBackgroundColor: inlineHoveredBackgroundColor ?? this.inlineHoveredBackgroundColor,
      inlinePressedBackgroundColor: inlinePressedBackgroundColor ?? this.inlinePressedBackgroundColor,
      arrowsButtonSize: arrowsButtonSize ?? this.arrowsButtonSize,
      iconSize: iconSize ?? this.iconSize,
      inlineIconsSize: inlineIconsSize ?? this.inlineIconsSize,
    );
  }

  AppKitPopupThemeSizeData merge(AppKitPopupThemeSizeData? other) {
    if (other == null) return this;
    return copyWith(
      height: other.height,
      textStyle: other.textStyle,
      inlineTextStyle: other.inlineTextStyle,
      borderRadius: other.borderRadius,
      arrowsStrokeWidth: other.arrowsStrokeWidth,
      arrowsSize: other.arrowsSize,
      childPadding: other.childPadding,
      inlineChildPadding: other.inlineChildPadding,
      containerPadding: other.containerPadding,
      inlineContainerPadding: other.inlineContainerPadding,
      inlineBorderRadius: other.inlineBorderRadius,
      inlineHeight: other.inlineHeight,
      inlineBackgroundColor: other.inlineBackgroundColor,
      inlineHoveredBackgroundColor: other.inlineHoveredBackgroundColor,
      inlinePressedBackgroundColor: other.inlinePressedBackgroundColor,
      arrowsButtonSize: other.arrowsButtonSize,
      iconSize: other.iconSize,
      inlineIconsSize: other.inlineIconsSize,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<TextStyle>('inlineTextStyle', inlineTextStyle));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(DoubleProperty('arrowsStrokeWidth', arrowsStrokeWidth));
    properties.add(DiagnosticsProperty<Size>('arrowsSize', arrowsSize));
    properties.add(DiagnosticsProperty<EdgeInsets>('childPadding', childPadding));
    properties.add(DiagnosticsProperty<EdgeInsets>('inlineChildPadding', inlineChildPadding));
    properties.add(DiagnosticsProperty<EdgeInsets>('containerPadding', containerPadding));
    properties.add(DiagnosticsProperty<EdgeInsets>('inlineContainerPadding', inlineContainerPadding));
    properties.add(DoubleProperty('inlineBorderRadius', inlineBorderRadius));
    properties.add(DoubleProperty('inlineHeight', inlineHeight));
    properties.add(ColorProperty('inlineBackgroundColor', inlineBackgroundColor));
    properties.add(ColorProperty('inlineHoveredBackgroundColor', inlineHoveredBackgroundColor));
    properties.add(ColorProperty('inlinePressedBackgroundColor', inlinePressedBackgroundColor));
    properties.add(DoubleProperty('arrowsButtonSize', arrowsButtonSize));
    properties.add(DoubleProperty('iconSize', iconSize));
    properties.add(DoubleProperty('inlineIconsSize', inlineIconsSize));
  }

  static AppKitPopupThemeSizeData lerp(AppKitPopupThemeSizeData a, AppKitPopupThemeSizeData b, double t) {
    return AppKitPopupThemeSizeData(
      height: lerpDouble(a.height, b.height, t)!,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
      inlineTextStyle: TextStyle.lerp(a.inlineTextStyle, b.inlineTextStyle, t)!,
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t)!,
      arrowsStrokeWidth: lerpDouble(a.arrowsStrokeWidth, b.arrowsStrokeWidth, t)!,
      arrowsSize: Size.lerp(a.arrowsSize, b.arrowsSize, t)!,
      childPadding: EdgeInsets.lerp(a.childPadding, b.childPadding, t)!,
      inlineChildPadding: EdgeInsets.lerp(a.inlineChildPadding, b.inlineChildPadding, t)!,
      containerPadding: EdgeInsets.lerp(a.containerPadding, b.containerPadding, t)!,
      inlineContainerPadding: EdgeInsets.lerp(a.inlineContainerPadding, b.inlineContainerPadding, t)!,
      inlineBorderRadius: lerpDouble(a.inlineBorderRadius, b.inlineBorderRadius, t)!,
      inlineHeight: lerpDouble(a.inlineHeight, b.inlineHeight, t)!,
      inlineBackgroundColor: Color.lerp(a.inlineBackgroundColor, b.inlineBackgroundColor, t),
      inlineHoveredBackgroundColor: Color.lerp(a.inlineHoveredBackgroundColor, b.inlineHoveredBackgroundColor, t),
      inlinePressedBackgroundColor: Color.lerp(a.inlinePressedBackgroundColor, b.inlinePressedBackgroundColor, t),
      arrowsButtonSize: lerpDouble(a.arrowsButtonSize, b.arrowsButtonSize, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
      inlineIconsSize: lerpDouble(a.inlineIconsSize, b.inlineIconsSize, t)!,
    );
  }
}
