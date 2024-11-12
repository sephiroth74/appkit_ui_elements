import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppKitColors {
  static AppKitColorContainer fills = AppKitColorContainer(
    opaque: AppKitColor(
      primary: const CupertinoDynamicColor.withBrightness(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          darkColor: Color.fromRGBO(255, 255, 255, 0.1)),
      secondary: const CupertinoDynamicColor.withBrightness(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          darkColor: Color.fromRGBO(255, 255, 255, 0.08)),
      tertiary: const CupertinoDynamicColor.withBrightness(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          darkColor: Color.fromRGBO(255, 255, 255, 0.05)),
      quaternary: const CupertinoDynamicColor.withBrightness(
          color: Color.fromRGBO(0, 0, 0, 0.03),
          darkColor: Color.fromRGBO(255, 255, 255, 0.03)),
      quinary: const CupertinoDynamicColor.withBrightness(
          color: Color.fromRGBO(0, 0, 0, 0.02),
          darkColor: Color.fromRGBO(255, 255, 255, 0.02)),
    ),
    vibrant: AppKitColor(
      primary: const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFD9D9D9), darkColor: Color(0xFF242424)),
      secondary: const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFE6E6E6), darkColor: Color(0xFF141414)),
      tertiary: const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFF2F2F2), darkColor: Color(0xFF0D0D0D)),
      quaternary: const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFF7F7F7), darkColor: Color(0xFF090909)),
      quinary: const CupertinoDynamicColor.withBrightness(
          color: Color(0xFFFBFBFB), darkColor: Color(0xFF070707)),
    ),
  );
}

class AppKitColorContainer {
  final AppKitColor opaque;
  final AppKitColor vibrant;

  AppKitColorContainer({required this.opaque, required this.vibrant});

  AppKitColorContainer copyWith({AppKitColor? opaque, AppKitColor? vibrant}) {
    return AppKitColorContainer(
      opaque: opaque ?? this.opaque,
      vibrant: vibrant ?? this.vibrant,
    );
  }

  AppKitColorContainer merge(AppKitColorContainer? other) {
    if (other == null) return this;
    return copyWith(
      opaque: other.opaque,
      vibrant: other.vibrant,
    );
  }

  lerp(AppKitColorContainer a, AppKitColorContainer b, double t) {
    return AppKitColorContainer(
      opaque: a.opaque.lerp(a.opaque, b.opaque, t),
      vibrant: a.vibrant.lerp(a.vibrant, b.vibrant, t),
    );
  }
}

class AppKitColor with Diagnosticable {
  final CupertinoDynamicColor primary;
  final CupertinoDynamicColor secondary;
  final CupertinoDynamicColor tertiary;
  final CupertinoDynamicColor quaternary;
  final CupertinoDynamicColor quinary;

  AppKitColor(
      {required this.primary,
      required this.secondary,
      required this.tertiary,
      required this.quaternary,
      required this.quinary});

  AppKitColor copyWith(
      {CupertinoDynamicColor? primary,
      CupertinoDynamicColor? secondary,
      CupertinoDynamicColor? tertiary,
      CupertinoDynamicColor? quaternary,
      CupertinoDynamicColor? quinary}) {
    return AppKitColor(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      quaternary: quaternary ?? this.quaternary,
      quinary: quinary ?? this.quinary,
    );
  }

  AppKitColor merge(AppKitColor? other) {
    if (other == null) return this;
    return copyWith(
      primary: other.primary,
      secondary: other.secondary,
      tertiary: other.tertiary,
      quaternary: other.quaternary,
      quinary: other.quinary,
    );
  }

  lerp(AppKitColor a, AppKitColor b, double t) {
    return AppKitColor(
      primary: CupertinoDynamicColor.withBrightness(
          color: Color.lerp(a.primary.color, b.primary.color, t)!,
          darkColor: Color.lerp(a.primary.darkColor, b.primary.darkColor, t)!),
      secondary: CupertinoDynamicColor.withBrightness(
          color: Color.lerp(a.secondary.color, b.secondary.color, t)!,
          darkColor:
              Color.lerp(a.secondary.darkColor, b.secondary.darkColor, t)!),
      tertiary: CupertinoDynamicColor.withBrightness(
          color: Color.lerp(a.tertiary.color, b.tertiary.color, t)!,
          darkColor:
              Color.lerp(a.tertiary.darkColor, b.tertiary.darkColor, t)!),
      quaternary: CupertinoDynamicColor.withBrightness(
          color: Color.lerp(a.quaternary.color, b.quaternary.color, t)!,
          darkColor:
              Color.lerp(a.quaternary.darkColor, b.quaternary.darkColor, t)!),
      quinary: CupertinoDynamicColor.withBrightness(
          color: Color.lerp(a.quinary.color, b.quinary.color, t)!,
          darkColor: Color.lerp(a.quinary.darkColor, b.quinary.darkColor, t)!),
    );
  }
}

extension AppKitDynamicColor on CupertinoDynamicColor {
  bool get isPlatformBrightnessDependent {
    return color != darkColor ||
        elevatedColor != darkElevatedColor ||
        highContrastColor != darkHighContrastColor ||
        highContrastElevatedColor != darkHighContrastElevatedColor;
  }

  Color resolveWith(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return isDark ? darkColor : color;
  }
}
