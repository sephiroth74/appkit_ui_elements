import 'dart:ui';

import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitTooltipTheme extends InheritedTheme {
  final AppKitTooltipThemeData data;

  const AppKitTooltipTheme({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  Widget wrap(BuildContext context, Widget child) {
    final AppKitTooltipTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<AppKitTooltipTheme>();
    return identical(this, ancestorTheme)
        ? child
        : AppKitTooltipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(AppKitTooltipTheme oldWidget) =>
      data != oldWidget.data;

  static AppKitTooltipThemeData of(BuildContext context) {
    final AppKitTooltipTheme? tooltipTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitTooltipTheme>();
    return tooltipTheme?.data ?? AppKitTheme.of(context).tooltipTheme;
  }
}

class AppKitTooltipThemeData with Diagnosticable {
  final double verticalOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool preferBelow;
  final Decoration decoration;
  final Duration waitDuration;
  final Duration showDuration;
  final TextStyle textStyle;
  final double minHeight;

  AppKitTooltipThemeData({
    required this.verticalOffset,
    required this.padding,
    required this.margin,
    required this.preferBelow,
    required this.decoration,
    required this.waitDuration,
    required this.showDuration,
    required this.textStyle,
    required this.minHeight,
  });

  AppKitTooltipThemeData copyWith({
    double? verticalOffset,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool? preferBelow,
    Decoration? decoration,
    Duration? waitDuration,
    Duration? showDuration,
    TextStyle? textStyle,
    double? minHeight,
  }) {
    return AppKitTooltipThemeData(
      verticalOffset: verticalOffset ?? this.verticalOffset,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      preferBelow: preferBelow ?? this.preferBelow,
      decoration: decoration ?? this.decoration,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
      textStyle: textStyle ?? this.textStyle,
      minHeight: minHeight ?? this.minHeight,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('verticalOffset', verticalOffset));
    properties.add(DiagnosticsProperty('padding', padding));
    properties.add(DiagnosticsProperty('margin', margin));
    properties.add(FlagProperty('preferBelow',
        value: preferBelow, ifTrue: 'below', ifFalse: 'above', showName: true));
    properties.add(DiagnosticsProperty('decoration', decoration));
    properties.add(DiagnosticsProperty('waitDuration', waitDuration));
    properties.add(DiagnosticsProperty('showDuration', showDuration));
    properties.add(DiagnosticsProperty('textStyle', textStyle));
    properties.add(DoubleProperty('minHeight', minHeight));
  }

  static AppKitTooltipThemeData lerp(
      AppKitTooltipThemeData a, AppKitTooltipThemeData b, double t) {
    return AppKitTooltipThemeData(
      verticalOffset: lerpDouble(a.verticalOffset, b.verticalOffset, t)!,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t)!,
      preferBelow: t < 0.5 ? a.preferBelow : b.preferBelow,
      decoration: Decoration.lerp(a.decoration, b.decoration, t)!,
      waitDuration: t < 0.5 ? a.waitDuration : b.waitDuration,
      showDuration: t < 0.5 ? a.showDuration : b.showDuration,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
      minHeight: lerpDouble(a.minHeight, b.minHeight, t)!,
    );
  }
}
