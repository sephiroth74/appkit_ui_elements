import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitDateTimePickerTheme extends InheritedTheme {
  final AppKitDateTimePickerThemeData data;

  const AppKitDateTimePickerTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is AppKitDateTimePickerTheme && data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppKitDateTimePickerTheme(data: data, child: child);
  }

  static AppKitDateTimePickerThemeData of(BuildContext context) {
    final AppKitDateTimePickerTheme? dateTimePickerTheme =
        context.dependOnInheritedWidgetOfExactType<AppKitDateTimePickerTheme>();
    return dateTimePickerTheme?.data ??
        AppKitTheme.of(context).dateTimePickerTheme;
  }
}

class AppKitDateTimePickerThemeData with Diagnosticable {
  final Color? graphicalDatePickerBackgroundColor;
  final Color? textualDatePickerBackgroundColor;
  final Color? accentColor;

  AppKitDateTimePickerThemeData({
    this.graphicalDatePickerBackgroundColor,
    this.textualDatePickerBackgroundColor,
    this.accentColor,
  });

  AppKitDateTimePickerThemeData copyWith({
    Color? graphicalDatePickerBackgroundColor,
    Color? textualDatePickerBackgroundColor,
    Color? accentColor,
  }) {
    return AppKitDateTimePickerThemeData(
      graphicalDatePickerBackgroundColor: graphicalDatePickerBackgroundColor ??
          this.graphicalDatePickerBackgroundColor,
      textualDatePickerBackgroundColor: textualDatePickerBackgroundColor ??
          this.textualDatePickerBackgroundColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  AppKitDateTimePickerThemeData merge(AppKitDateTimePickerThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      graphicalDatePickerBackgroundColor:
          other.graphicalDatePickerBackgroundColor,
      textualDatePickerBackgroundColor: other.textualDatePickerBackgroundColor,
      accentColor: other.accentColor,
    );
  }

  static AppKitDateTimePickerThemeData lerp(AppKitDateTimePickerThemeData? a,
      AppKitDateTimePickerThemeData? b, double t) {
    return AppKitDateTimePickerThemeData(
      graphicalDatePickerBackgroundColor: Color.lerp(
          a?.graphicalDatePickerBackgroundColor,
          b?.graphicalDatePickerBackgroundColor,
          t),
      textualDatePickerBackgroundColor: Color.lerp(
          a?.textualDatePickerBackgroundColor,
          b?.textualDatePickerBackgroundColor,
          t),
      accentColor: Color.lerp(a?.accentColor, b?.accentColor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('graphicalDatePickerBackgroundColor',
        graphicalDatePickerBackgroundColor));
    properties.add(ColorProperty(
        'textualDatePickerBackgroundColor', textualDatePickerBackgroundColor));
    properties.add(ColorProperty('accentColor', accentColor));
  }
}
