import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppKitPopupButtonTheme extends InheritedTheme {
  final AppKitPopupButtonThemeData data;

  const AppKitPopupButtonTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppKitPopupButtonTheme && oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitPopupButtonTheme(data: data, child: child);
  }

  static AppKitPopupButtonThemeData of(BuildContext context) {
    final AppKitPopupButtonTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitPopupButtonTheme>();
    return theme?.data ?? AppKitTheme.of(context).popupButtonTheme;
  }
}

class AppKitPopupButtonThemeData with Diagnosticable {
  final Color? elevatedButtonColor;
  final Color plainButtonColor;
  final CupertinoDynamicColor arrowsColor;
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

    final plainButtonColor = (isDark
            ? AppKitColors.systemGray.darkColor
            : AppKitColors.systemGray.color)
        .withOpacity(0.2);
    const arrowsColor = AppKitColors.labelColor;

    final inlineTextStyle =
        typography.subheadline.copyWith(fontWeight: FontWeight.w500);

    // large
    final largeSize = AppKitPopupThemeSizeData(
      height: 29.0,
      textStyle: typography.body.copyWith(fontSize: 13.5),
      inlineTextStyle: inlineTextStyle.copyWith(fontSize: 13.5),
      borderRadius: 6.0,
      arrowsStrokeWidth: 1.75,
      arrowsSize: const Size(7.5, 12.5),
      childPadding: const EdgeInsets.only(bottom: 2.0, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 2.0, right: 4.0),
      containerPadding: const EdgeInsets.only(left: 9.0, right: 2.0),
      inlineContainerPadding:
          const EdgeInsets.only(left: 9.5, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // regular
    final regularSize = AppKitPopupThemeSizeData(
      height: 20.0,
      textStyle: typography.body,
      inlineTextStyle: inlineTextStyle,
      borderRadius: 5.5,
      arrowsStrokeWidth: 1.75,
      arrowsSize: const Size(5.5, 10),
      childPadding: const EdgeInsets.only(bottom: 1.0, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 2.0, right: 4.0),
      containerPadding: const EdgeInsets.only(left: 7.5, right: 2.0),
      inlineContainerPadding:
          const EdgeInsets.only(left: 8.0, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // small
    final smallSize = AppKitPopupThemeSizeData(
      height: 17.0,
      textStyle: typography.body.copyWith(fontSize: 10.0),
      inlineTextStyle: inlineTextStyle.copyWith(fontSize: 10.0), // TBD
      borderRadius: 5.0,
      arrowsStrokeWidth: 1.25,
      arrowsSize: const Size(5.0, 8.0),
      childPadding: const EdgeInsets.only(bottom: 1.0, right: 4.0),
      inlineChildPadding: const EdgeInsets.only(bottom: 1.5, right: 5.0),
      containerPadding: const EdgeInsets.only(left: 6.0, right: 2.0),
      inlineContainerPadding:
          const EdgeInsets.only(left: 7.5, top: 0.5, right: 4.5, bottom: 0.5),
    );

    // mini
    final miniSize = AppKitPopupThemeSizeData(
        height: 14.0,
        textStyle: typography.body.copyWith(fontSize: 9.0),
        inlineTextStyle: inlineTextStyle.copyWith(fontSize: 9.0), // TBD
        borderRadius: 3.0,
        arrowsStrokeWidth: 1.0,
        arrowsSize: const Size(3.0, 5.5),
        childPadding: const EdgeInsets.only(bottom: 0.5, right: 4.0),
        inlineChildPadding: const EdgeInsets.only(bottom: 1.0, right: 5.0),
        containerPadding: const EdgeInsets.only(left: 5.0, right: 2.0),
        inlineContainerPadding: const EdgeInsets.only(
            left: 7.5, top: 0.5, right: 4.5, bottom: 0.5));

    final sizeData = {
      AppKitControlSize.mini: miniSize,
      AppKitControlSize.small: smallSize,
      AppKitControlSize.regular: regularSize,
      AppKitControlSize.large: largeSize,
    };

    return AppKitPopupButtonThemeData(
        arrowsColor: arrowsColor,
        plainButtonColor: plainButtonColor,
        sizeData: sizeData);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('elevatedButtonColor', elevatedButtonColor));
    properties.add(ColorProperty('plainButtonColor', plainButtonColor));
    properties.add(ColorProperty('arrowsColor', arrowsColor));
    properties.add(
        DiagnosticsProperty<Map<AppKitControlSize, AppKitPopupThemeSizeData>>(
            'sizeData', sizeData));
  }

  AppKitPopupButtonThemeData copyWith({
    Color? elevatedButtonColor,
    Color? plainButtonColor,
    CupertinoDynamicColor? arrowsColor,
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
        sizeData.entries.map(
          (entry) {
            return MapEntry(
              entry.key,
              entry.value.merge(other.sizeData[entry.key]),
            );
          },
        ),
      ),
    );
  }

  static AppKitPopupButtonThemeData lerp(
      AppKitPopupButtonThemeData a, AppKitPopupButtonThemeData b, double t) {
    return AppKitPopupButtonThemeData(
      elevatedButtonColor:
          Color.lerp(a.elevatedButtonColor, b.elevatedButtonColor, t),
      plainButtonColor: Color.lerp(a.plainButtonColor, b.plainButtonColor, t)!,
      arrowsColor: CupertinoDynamicColor.withBrightness(
        color: Color.lerp(a.arrowsColor.color, b.arrowsColor.color, t)!,
        darkColor:
            Color.lerp(a.arrowsColor.darkColor, b.arrowsColor.darkColor, t)!,
      ),
      sizeData: Map.fromEntries(
        a.sizeData.entries.map(
          (entry) {
            return MapEntry(
              entry.key,
              AppKitPopupThemeSizeData.lerp(
                  entry.value, b.sizeData[entry.key]!, t),
            );
          },
        ),
      ),
    );
  }
}

class AppKitPopupThemeSizeData with Diagnosticable {
  final double height;
  final TextStyle textStyle;
  final TextStyle inlineTextStyle;
  final double borderRadius;
  final double arrowsStrokeWidth;
  final Size arrowsSize;
  final EdgeInsets childPadding;
  final EdgeInsets inlineChildPadding;
  final EdgeInsets containerPadding;
  final EdgeInsets inlineContainerPadding;

  double get inlineHeight => height * 1.25;

  double get inlineBorderRadius => inlineHeight / 2.0;

  double get arrowsButtonSize => height - 4;

  double get iconSize => textStyle.fontSize! * 1.2;

  double get inlineIconsSize => inlineTextStyle.fontSize! * 1.2;

  EdgeInsets get iconPadding => const EdgeInsets.only(right: 4.0, top: 0.0);

  AppKitPopupThemeSizeData({
    required this.height,
    required this.textStyle,
    required this.inlineTextStyle,
    required this.borderRadius,
    required this.arrowsStrokeWidth,
    required this.arrowsSize,
    required this.childPadding,
    required this.inlineChildPadding,
    required this.containerPadding,
    required this.inlineContainerPadding,
  });

  AppKitPopupThemeSizeData copyWith({
    double? height,
    TextStyle? textStyle,
    TextStyle? inlineTextStyle,
    double? borderRadius,
    double? arrowsStrokeWidth,
    Size? arrowsSize,
    EdgeInsets? childPadding,
    EdgeInsets? inlineChildPadding,
    EdgeInsets? containerPadding,
    EdgeInsets? inlineContainerPadding,
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
      inlineContainerPadding:
          inlineContainerPadding ?? this.inlineContainerPadding,
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
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(
        DiagnosticsProperty<TextStyle>('inlineTextStyle', inlineTextStyle));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(DoubleProperty('arrowsStrokeWidth', arrowsStrokeWidth));
    properties.add(DiagnosticsProperty<Size>('arrowsSize', arrowsSize));
    properties
        .add(DiagnosticsProperty<EdgeInsets>('childPadding', childPadding));
    properties.add(DiagnosticsProperty<EdgeInsets>(
        'inlineChildPadding', inlineChildPadding));
    properties.add(
        DiagnosticsProperty<EdgeInsets>('containerPadding', containerPadding));
    properties.add(DiagnosticsProperty<EdgeInsets>(
        'inlineContainerPadding', inlineContainerPadding));
  }

  static AppKitPopupThemeSizeData lerp(
      AppKitPopupThemeSizeData a, AppKitPopupThemeSizeData b, double t) {
    return AppKitPopupThemeSizeData(
      height: lerpDouble(a.height, b.height, t)!,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
      inlineTextStyle: TextStyle.lerp(a.inlineTextStyle, b.inlineTextStyle, t)!,
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t)!,
      arrowsStrokeWidth:
          lerpDouble(a.arrowsStrokeWidth, b.arrowsStrokeWidth, t)!,
      arrowsSize: Size.lerp(a.arrowsSize, b.arrowsSize, t)!,
      childPadding: EdgeInsets.lerp(a.childPadding, b.childPadding, t)!,
      inlineChildPadding:
          EdgeInsets.lerp(a.inlineChildPadding, b.inlineChildPadding, t)!,
      containerPadding:
          EdgeInsets.lerp(a.containerPadding, b.containerPadding, t)!,
      inlineContainerPadding: EdgeInsets.lerp(
          a.inlineContainerPadding, b.inlineContainerPadding, t)!,
    );
  }
}
