import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitColorWellTheme extends InheritedTheme {
  final AppKitColorWellThemeData data;

  const AppKitColorWellTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitColorWellTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitColorWellTheme(data: data, child: child);
  }

  static AppKitColorWellThemeData of(BuildContext context) {
    final AppKitColorWellTheme? theme =
        context.dependOnInheritedWidgetOfExactType<AppKitColorWellTheme>();
    return theme?.data ?? AppKitTheme.of(context).colorWellTheme;
  }
}

class AppKitColorWellThemeData with Diagnosticable {
  final Color borderColor;
  final List<Color> gradientColors;

  AppKitColorWellThemeData({
    required this.borderColor,
    required this.gradientColors,
  });

  static AppKitColorWellThemeData lerp(
      AppKitColorWellThemeData? a, AppKitColorWellThemeData? b, double t) {
    return AppKitColorWellThemeData(
      borderColor: Color.lerp(a?.borderColor, b?.borderColor, t)!,
      gradientColors: List.generate(
        a?.gradientColors.length ?? 0,
        (index) =>
            Color.lerp(a?.gradientColors[index], b?.gradientColors[index], t)!,
      ),
    );
  }

  AppKitColorWellThemeData merge(AppKitColorWellThemeData? other) {
    if (other == null) return this;
    return copyWith(
      borderColor: other.borderColor,
      gradientColors: other.gradientColors,
    );
  }

  AppKitColorWellThemeData copyWith({
    Color? borderColor,
    List<Color>? gradientColors,
  }) {
    return AppKitColorWellThemeData(
      borderColor: borderColor ?? this.borderColor,
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(IterableProperty<Color>('gradientColors', gradientColors));
  }
}
