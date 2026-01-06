import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitSegmentedControlTheme extends InheritedTheme {
  final AppKitSegmentedControlThemeData data;

  const AppKitSegmentedControlTheme({super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant AppKitSegmentedControlTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitSegmentedControlTheme(data: data, child: child);
  }

  static AppKitSegmentedControlThemeData of(BuildContext context) {
    final AppKitSegmentedControlTheme? theme = context
        .dependOnInheritedWidgetOfExactType<AppKitSegmentedControlTheme>();
    return theme?.data ?? AppKitTheme.of(context).segmentedControlTheme;
  }
}

class AppKitSegmentedControlThemeData with Diagnosticable {
  final Color dividerColorMultipleSelection;
  final Color dividerColorSingleSelection;
  final Color singleSelectionColor;
  final Color? accentColor;

  AppKitSegmentedControlThemeData({
    required this.dividerColorMultipleSelection,
    required this.dividerColorSingleSelection,
    required this.singleSelectionColor,
    this.accentColor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('dividerColorMultipleSelection', dividerColorMultipleSelection));
    properties.add(ColorProperty('dividerColorSingleSelection', dividerColorSingleSelection));
    properties.add(ColorProperty('singleSelectionColor', singleSelectionColor));
    properties.add(ColorProperty('accentColor', accentColor));
  }

  AppKitSegmentedControlThemeData copyWith({
    Color? dividerColorMultipleSelection,
    Color? dividerColorSingleSelection,
    Color? singleSelectionColor,
    Color? accentColor,
  }) {
    return AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection: dividerColorMultipleSelection ?? this.dividerColorMultipleSelection,
      dividerColorSingleSelection: dividerColorSingleSelection ?? this.dividerColorSingleSelection,
      singleSelectionColor: singleSelectionColor ?? this.singleSelectionColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  AppKitSegmentedControlThemeData merge(AppKitSegmentedControlThemeData? other) {
    if (other == null) return this;
    return copyWith(
      dividerColorMultipleSelection: other.dividerColorMultipleSelection,
      dividerColorSingleSelection: other.dividerColorSingleSelection,
      singleSelectionColor: other.singleSelectionColor,
      accentColor: other.accentColor,
    );
  }

  static AppKitSegmentedControlThemeData lerp(
    AppKitSegmentedControlThemeData a,
    AppKitSegmentedControlThemeData b,
    double t,
  ) {
    return AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection: Color.lerp(a.dividerColorMultipleSelection, b.dividerColorMultipleSelection, t)!,
      dividerColorSingleSelection: Color.lerp(a.dividerColorSingleSelection, b.dividerColorSingleSelection, t)!,
      singleSelectionColor: Color.lerp(a.singleSelectionColor, b.singleSelectionColor, t)!,
      accentColor: Color.lerp(a.accentColor, b.accentColor, t),
    );
  }
}
