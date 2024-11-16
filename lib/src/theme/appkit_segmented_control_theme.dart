import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitSegmentedControlTheme extends InheritedTheme {
  final AppKitSegmentedControlThemeData data;

  const AppKitSegmentedControlTheme(
      {super.key, required super.child, required this.data});

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

  AppKitSegmentedControlThemeData({
    required this.dividerColorMultipleSelection,
    required this.dividerColorSingleSelection,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty(
        'dividerColorMultipleSelection', dividerColorMultipleSelection));
    properties.add(ColorProperty(
        'dividerColorSingleSelection', dividerColorSingleSelection));
  }

  AppKitSegmentedControlThemeData copyWith({
    Color? dividerColorMultipleSelection,
    Color? dividerColorSingleSelection,
  }) {
    return AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection:
          dividerColorMultipleSelection ?? this.dividerColorMultipleSelection,
      dividerColorSingleSelection:
          dividerColorSingleSelection ?? this.dividerColorSingleSelection,
    );
  }

  AppKitSegmentedControlThemeData merge(
      AppKitSegmentedControlThemeData? other) {
    if (other == null) return this;
    return copyWith(
      dividerColorMultipleSelection: other.dividerColorMultipleSelection,
      dividerColorSingleSelection: other.dividerColorSingleSelection,
    );
  }

  static AppKitSegmentedControlThemeData lerp(AppKitSegmentedControlThemeData a,
      AppKitSegmentedControlThemeData b, double t) {
    return AppKitSegmentedControlThemeData(
      dividerColorMultipleSelection: Color.lerp(
          a.dividerColorMultipleSelection, b.dividerColorMultipleSelection, t)!,
      dividerColorSingleSelection: Color.lerp(
          a.dividerColorSingleSelection, b.dividerColorSingleSelection, t)!,
    );
  }
}
