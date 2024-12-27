import 'dart:ui' as ui;

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppKitIconTheme extends InheritedTheme {
  const AppKitIconTheme({
    super.key,
    required this.data,
    required super.child,
  });

  factory AppKitIconTheme.toolbar(
    BuildContext context, {
    required IconData icon,
    bool showLabel = false,
    VoidCallback? onPressed,
  }) {
    return AppKitIconTheme(
      data: AppKitIconThemeData(
        size: showLabel ? 16.0 : 20.0,
      ),
      child: AppKitIconButton(
        icon: icon,
        padding: showLabel
            ? const EdgeInsets.symmetric(horizontal: 5, vertical: 3)
            : const EdgeInsets.all(5),
        disabledColor: Colors.transparent,
        color: AppKitColors.toolbarIconColor.resolveFrom(context),
        onPressed: onPressed,
        boxConstraints: showLabel
            ? const BoxConstraints(
                minHeight: 19,
                minWidth: 35,
                maxWidth: 35,
                maxHeight: 22,
              )
            : const BoxConstraints(
                minHeight: 19,
                minWidth: 15,
                maxWidth: 35,
                maxHeight: 28,
              ),
      ),
    );
  }

  static Widget merge({
    Key? key,
    required AppKitIconThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return AppKitIconTheme(
          key: key,
          data: _getInheritedIconThemeData(context).merge(data),
          child: child,
        );
      },
    );
  }

  final AppKitIconThemeData data;

  static AppKitIconThemeData of(BuildContext context) {
    return _getInheritedIconThemeData(context);
  }

  static AppKitIconThemeData _getInheritedIconThemeData(BuildContext context) {
    final AppKitIconTheme? iconTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitIconTheme>();
    return iconTheme?.data ?? AppKitTheme.of(context).iconTheme;
  }

  @override
  bool updateShouldNotify(AppKitIconTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitIconTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

class AppKitIconThemeData with Diagnosticable {
  const AppKitIconThemeData({
    this.color,
    double? opacity,
    this.size,
  }) : _opacity = opacity;

  const AppKitIconThemeData.fallback()
      : color = const Color.fromARGB(255, 0, 122, 255),
        _opacity = 1.0,
        size = 24.0;

  AppKitIconThemeData copyWith({
    Color? color,
    double? opacity,
    double? size,
  }) {
    return AppKitIconThemeData(
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      size: size ?? this.size,
    );
  }

  AppKitIconThemeData merge(AppKitIconThemeData? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      opacity: other.opacity,
      size: other.size,
    );
  }

  AppKitIconThemeData resolve(BuildContext context) => this;

  bool get isConcrete => color != null && opacity != null && size != null;

  final Color? color;

  double? get opacity => _opacity?.clamp(0.0, 1.0);

  final double? _opacity;

  final double? size;

  static AppKitIconThemeData lerp(
    AppKitIconThemeData? a,
    AppKitIconThemeData? b,
    double t,
  ) {
    return AppKitIconThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      opacity: ui.lerpDouble(a?.opacity, b?.opacity, t),
      size: ui.lerpDouble(a?.size, b?.size, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AppKitIconThemeData &&
        other.color?.value == color?.value &&
        other.opacity == opacity &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(color, opacity, size);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DoubleProperty('opacity', opacity, defaultValue: null));
    properties.add(DoubleProperty('size', size, defaultValue: null));
  }
}
