import 'package:appkit_ui_elements/appkit_ui_elements.dart';
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

  static AppKitColorContainer text = AppKitColorContainer(
      opaque: AppKitColor(
        primary: const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.85),
            darkColor: Color.fromRGBO(255, 255, 255, 0.85)),
        secondary: const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            darkColor: Color.fromRGBO(255, 255, 255, 0.55)),
        tertiary: const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            darkColor: Color.fromRGBO(255, 255, 255, 0.25)),
        quaternary: const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            darkColor: Color.fromRGBO(255, 255, 255, 0.1)),
        quinary: const CupertinoDynamicColor.withBrightness(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            darkColor: Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      vibrant: AppKitColor(
        primary: const CupertinoDynamicColor.withBrightness(
            color: Color(0xFF4C4C4C), darkColor: Color(0xFFE5E5E5)),
        secondary: const CupertinoDynamicColor.withBrightness(
            color: Color(0xFF808080), darkColor: Color(0xFF7C7C7C)),
        tertiary: const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFBFBFBF), darkColor: Color(0xFF414141)),
        quaternary: const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFBFBFBF), darkColor: Color(0xFF414141)),
        quinary: const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFBFBFBF), darkColor: Color(0xFF414141)),
      ));

  static AppKitMaterial materials = AppKitMaterial(
    ultraThick: const AppKitMaterialColor.withBrightness(
        color: Color(0xD6F6F6F6), darkColor: Color(0x80000000), blur: 30),
    thick: const AppKitMaterialColor.withBrightness(
        color: Color(0xB8F6F6F6), darkColor: Color(0x66000000), blur: 30),
    medium: const AppKitMaterialColor.withBrightness(
        color: Color(0x99F6F6F6), darkColor: Color(0x4A000000), blur: 30),
    thin: const AppKitMaterialColor.withBrightness(
        color: Color(0x7AF6F6F6), darkColor: Color(0x33000000), blur: 30),
    ultraThin: const AppKitMaterialColor.withBrightness(
        color: Color(0x5CF6F6F6), darkColor: Color(0x1A000000), blur: 30),
  );

  static const CupertinoDynamicColor labelColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xD8000000),
    darkColor: Color(0xD8FFFFFF),
  );

  static const secondaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    darkColor: Color(0x8CFFFFFF),
  );

  static const tertiaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x42000000),
    darkColor: Color(0x3FFFFFFF),
  );

  static const quaternaryLabelColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x19000000),
    darkColor: Color(0x19FFFFFF),
  );

  static const CupertinoDynamicColor textColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor placeholderTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0x3F000000),
    darkColor: Color(0x3FFFFFFF),
  );

  static const CupertinoDynamicColor selectedTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor textBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF1E1E1E),
  );

  static const CupertinoDynamicColor selectedTextBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDFC5E0),
    darkColor: Color(0xFF705771),
  );

  // static const CupertinoDynamicColor keyboardFocusIndicatorColor = CupertinoDynamicColor.withBrightness(
  //   color: Color(0x7F842685),
  //   darkColor: Color(0x7FDC78DE),
  // );

  static const controlBackgroundPressedColor =
      CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.2),
    darkColor: Color.fromRGBO(255, 255, 255, 0.2),
  );

  static const CupertinoDynamicColor unemphasizedSelectedTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor unemphasizedSelectedTextBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDCDCDC),
    darkColor: Color(0xFF464646),
  );

  static const CupertinoDynamicColor linkColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF0068DA),
    darkColor: Color(0xFF419CFF),
  );

  static const CupertinoDynamicColor separatorColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0x19000000),
    darkColor: Color(0x19FFFFFF),
  );

  static const List<CupertinoDynamicColor> alternatingContentBackgroundColors =
      [
    CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFFFF), darkColor: Color(0xFF1E1E1E)),
    CupertinoDynamicColor.withBrightness(
        color: Color(0xFFF4F5F5), darkColor: Color(0x0CFFFFFF)),
  ];

  static const CupertinoDynamicColor
      unemphasizedSelectedContentBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDCDCDC),
    darkColor: Color(0xFF464646),
  );

  static const CupertinoDynamicColor selectedMenuItemTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF), // TBD
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor gridColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE6E6E6),
    darkColor: Color(0xFF1A1A1A),
  );

  static const CupertinoDynamicColor headerTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xD8000000),
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor controlColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0x3FFFFFFF),
  );

  static const CupertinoDynamicColor controlBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF1E1E1E),
  );

  static const CupertinoDynamicColor controlTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xD8000000),
    darkColor: Color(0xD8FFFFFF),
  );

  static const CupertinoDynamicColor disabledControlTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0x3F000000),
    darkColor: Color(0x3FFFFFFF),
  );

  static const CupertinoDynamicColor selectedControlColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDFC5E0),
    darkColor: Color(0xFF705771),
  );

  static const CupertinoDynamicColor selectedControlTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xD8000000),
    darkColor: Color(0xD8FFFFFF),
  );

  static const CupertinoDynamicColor alternateSelectedControlTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFFFFFFFF),
  );

  static const CupertinoDynamicColor windowBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFECECEC),
    darkColor: Color(0xFF323232),
  );

  static const canvasColor = CupertinoDynamicColor.withBrightness(
      color: Color.fromRGBO(246, 246, 246, 1.0),
      darkColor: Color.fromRGBO(40, 40, 40, 1.0));

  static const CupertinoDynamicColor windowFrameTextColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xD8000000),
    darkColor: Color(0xD8FFFFFF),
  );

  static const CupertinoDynamicColor underPageBackgroundColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xE5969696),
    darkColor: Color(0xFF282828),
  );

  static const CupertinoDynamicColor findHighlightColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFF00), // TBD
    darkColor: Color(0xFFFFFF00),
  );

  static const CupertinoDynamicColor highlightColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFFB4B4B4),
  );

  static const CupertinoDynamicColor shadowColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFF000000),
  );

  static const dividerColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x1F000000),
    darkColor: Color(0x1FFFFFFF),
  );

  static CupertinoDynamicColor scrollbarColor =
      CupertinoDynamicColor.withBrightness(
    color: AppKitColors.systemGray.color.withOpacity(0.8),
    darkColor: AppKitColors.systemGray.darkColor.withOpacity(0.8),
  );

  static const toolbarIconColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    darkColor: Color.fromRGBO(255, 255, 255, 0.5),
  );

  static const BoxShadow shadowPrimary = BoxShadow(
      color: Color(0x66000000),
      offset: Offset(0.0, 1.0),
      blurRadius: 0.5,
      spreadRadius: 0.0,
      blurStyle: BlurStyle.outer);
  static const BoxShadow shadowSecondary = BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0.0, 0.0),
      blurRadius: 0.0,
      spreadRadius: 0.5,
      blurStyle: BlurStyle.outer);

  /// https://developer.apple.com/design/human-interface-guidelines/color#macOS-system-colors
  static const CupertinoDynamicColor systemRed =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(255, 59, 48, 1),
    darkColor: Color(0xFFFF453A),
    highContrastColor: Color.fromRGBO(255, 49, 38, 1),
    darkHighContrastColor: Color.fromRGBO(255, 79, 68, 1),
  );

  static const CupertinoDynamicColor systemOrange =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(255, 149, 0, 1),
    darkColor: Color(0xFFFF9F0A),
    highContrastColor: Color.fromRGBO(245, 139, 0, 1),
    darkHighContrastColor: Color.fromRGBO(255, 169, 20, 1),
  );

  static const CupertinoDynamicColor systemYellow =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(255, 204, 0, 1),
    darkColor: Color(0xFFFFD60A),
    highContrastColor: Color.fromRGBO(245, 194, 0, 1),
    darkHighContrastColor: Color.fromRGBO(255, 224, 20, 1),
  );

  static const CupertinoDynamicColor systemGreen =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(40, 205, 65, 1),
    darkColor: Color(0xFF32D74B),
    highContrastColor: Color.fromRGBO(30, 195, 55, 1),
    darkHighContrastColor: Color.fromRGBO(60, 225, 85, 1),
  );

  static const CupertinoDynamicColor systemMint =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(0, 199, 190, 1),
    darkColor: Color.fromRGBO(102, 212, 207, 1),
    highContrastColor: Color.fromRGBO(10, 189, 180, 1),
    darkHighContrastColor: Color.fromRGBO(108, 224, 219, 1),
  );

  static const CupertinoDynamicColor systemTeal =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(89, 173, 196, 1),
    darkColor: Color(0xFF6AC4DC),
    highContrastColor: Color.fromRGBO(46, 167, 189, 1),
    darkHighContrastColor: Color.fromRGBO(68, 212, 237, 1),
  );

  static const CupertinoDynamicColor systemCyan =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(85, 190, 240, 1),
    darkColor: Color.fromRGBO(90, 200, 245, 1),
    highContrastColor: Color.fromRGBO(65, 175, 220, 1),
    darkHighContrastColor: Color.fromRGBO(90, 205, 250, 1),
  );

  static const CupertinoDynamicColor systemBlue =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(0, 122, 255, 1),
    darkColor: Color(0xFF0A84FF),
    highContrastColor: Color.fromRGBO(0, 122, 245, 1),
    darkHighContrastColor: Color.fromRGBO(20, 142, 255, 1),
  );

  static const CupertinoDynamicColor systemIndigo =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(88, 86, 214, 1),
    darkColor: Color(0xFF5E5CE6),
    highContrastColor: Color.fromRGBO(84, 82, 204, 1),
    darkHighContrastColor: Color.fromRGBO(99, 97, 242, 1),
  );

  static const CupertinoDynamicColor systemPurple =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(175, 82, 222, 1),
    darkColor: Color(0xFFBF5AF2),
    highContrastColor: Color.fromRGBO(159, 75, 201, 1),
    darkHighContrastColor: Color.fromRGBO(204, 101, 255, 1),
  );

  static const CupertinoDynamicColor systemPink =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(255, 45, 85, 1),
    darkColor: Color(0xFFFF375F),
    highContrastColor: Color.fromRGBO(245, 35, 75, 1),
    darkHighContrastColor: Color.fromRGBO(255, 65, 105, 1),
  );

  static const CupertinoDynamicColor systemBrown =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(162, 132, 94, 1),
    darkColor: Color(0xFFAC8E68),
    highContrastColor: Color.fromRGBO(152, 122, 84, 1),
    darkHighContrastColor: Color.fromRGBO(182, 152, 114, 1),
  );

  static const CupertinoDynamicColor systemGray =
      CupertinoDynamicColor.withBrightnessAndContrast(
    color: Color.fromRGBO(142, 142, 147, 1),
    darkColor: Color(0xFF98989D),
    highContrastColor: Color.fromRGBO(132, 132, 137, 1),
    darkHighContrastColor: Color.fromRGBO(162, 162, 167, 1),
  );

  static const appleBlue = Color(0xff0433ff);
  static const appleBrown = Color(0xffaa7942);
  static const appleCyan = Color(0xff00fdff);
  static const appleGreen = Color(0xff00f900);
  static const appleMagenta = Color(0xffff40ff);
  static const appleOrange = Color(0xffff9300);
  static const applePurple = Color(0xff094219);
  static const appleRed = Color(0xffff2600);
  static const appleYellow = Color(0xfffffb00);
}

class AppKitMaterial {
  final AppKitMaterialColor ultraThick;
  final AppKitMaterialColor thick;
  final AppKitMaterialColor medium;
  final AppKitMaterialColor thin;
  final AppKitMaterialColor ultraThin;

  AppKitMaterial(
      {required this.ultraThick,
      required this.thick,
      required this.medium,
      required this.thin,
      required this.ultraThin});
}

class AppKitMaterialColor extends CupertinoDynamicColor {
  final double blur;

  const AppKitMaterialColor.withBrightnessAndContrast(
      {required super.color,
      required super.darkColor,
      required super.highContrastColor,
      required super.darkHighContrastColor,
      required this.blur})
      : super.withBrightnessAndContrast();

  const AppKitMaterialColor.withBrightness(
      {required super.color, required super.darkColor, required this.blur})
      : super.withBrightness();
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

  CupertinoDynamicColor get quinaryInverted =>
      CupertinoDynamicColor.withBrightness(
          color: quinary.darkColor, darkColor: quinary.color);

  AppKitColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.quaternary,
    required this.quinary,
  });

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

  bool get isHighContrastDependent {
    return color != highContrastColor ||
        darkColor != darkHighContrastColor ||
        elevatedColor != highContrastElevatedColor ||
        darkElevatedColor != darkHighContrastElevatedColor;
  }

  bool get isInterfaceElevationDependent {
    return color != elevatedColor ||
        darkColor != darkElevatedColor ||
        highContrastColor != highContrastElevatedColor ||
        darkHighContrastColor != darkHighContrastElevatedColor;
  }

  Color resolveWith(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return isDark ? darkColor : color;
  }

  static Color resolve(BuildContext context, Color resolvable) {
    if (resolvable is CupertinoDynamicColor) {
      final Brightness brightness = resolvable.isPlatformBrightnessDependent
          ? AppKitTheme.maybeBrightnessOf(context) ?? Brightness.light
          : Brightness.light;

      final CupertinoUserInterfaceLevelData level =
          resolvable.isInterfaceElevationDependent
              ? CupertinoUserInterfaceLevel.maybeOf(context) ??
                  CupertinoUserInterfaceLevelData.base
              : CupertinoUserInterfaceLevelData.base;

      final bool highContrast = resolvable.isHighContrastDependent &&
          (MediaQuery.maybeHighContrastOf(context) ?? false);

      final Color resolved = switch ((brightness, level, highContrast)) {
        (Brightness.light, CupertinoUserInterfaceLevelData.base, false) =>
          resolvable.color,
        (Brightness.light, CupertinoUserInterfaceLevelData.base, true) =>
          resolvable.highContrastColor,
        (Brightness.light, CupertinoUserInterfaceLevelData.elevated, false) =>
          resolvable.elevatedColor,
        (Brightness.light, CupertinoUserInterfaceLevelData.elevated, true) =>
          resolvable.highContrastElevatedColor,
        (Brightness.dark, CupertinoUserInterfaceLevelData.base, false) =>
          resolvable.darkColor,
        (Brightness.dark, CupertinoUserInterfaceLevelData.base, true) =>
          resolvable.darkHighContrastColor,
        (Brightness.dark, CupertinoUserInterfaceLevelData.elevated, false) =>
          resolvable.darkElevatedColor,
        (Brightness.dark, CupertinoUserInterfaceLevelData.elevated, true) =>
          resolvable.darkHighContrastElevatedColor,
      };

      Element? debugContext;
      assert(() {
        debugContext = context as Element;
        return true;
      }());
      return AppKitResolvedDynamicColor(
        resolved,
        resolvable.color,
        resolvable.darkColor,
        resolvable.highContrastColor,
        resolvable.darkHighContrastColor,
        resolvable.elevatedColor,
        resolvable.darkElevatedColor,
        resolvable.highContrastElevatedColor,
        resolvable.darkHighContrastElevatedColor,
        debugContext,
      );
    } else {
      return resolvable;
    }
  }
}

class AppKitResolvedDynamicColor extends CupertinoDynamicColor {
  const AppKitResolvedDynamicColor(
    this.resolvedColor,
    Color color,
    Color darkColor,
    Color highContrastColor,
    Color darkHighContrastColor,
    Color elevatedColor,
    Color darkElevatedColor,
    Color highContrastElevatedColor,
    Color darkHighContrastElevatedColor,
    Element? debugResolveContext,
  ) : super(
          color: color,
          darkColor: darkColor,
          highContrastColor: highContrastColor,
          darkHighContrastColor: darkHighContrastColor,
          elevatedColor: elevatedColor,
          darkElevatedColor: darkElevatedColor,
          highContrastElevatedColor: highContrastElevatedColor,
          darkHighContrastElevatedColor: darkHighContrastElevatedColor,
        );

  final Color resolvedColor;

  @override
  int get value => resolvedColor.value;
}
