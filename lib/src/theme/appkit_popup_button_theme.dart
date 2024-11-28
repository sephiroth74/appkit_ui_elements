import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
  final Color? plainButtonColor;

  AppKitPopupButtonThemeData({
    this.elevatedButtonColor,
    this.plainButtonColor,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('elevatedButtonColor', elevatedButtonColor));
    properties.add(ColorProperty('plainButtonColor', plainButtonColor));
  }

  AppKitPopupButtonThemeData copyWith({
    Color? elevatedButtonColor,
    Color? plainButtonColor,
  }) {
    return AppKitPopupButtonThemeData(
      elevatedButtonColor: elevatedButtonColor ?? this.elevatedButtonColor,
      plainButtonColor: plainButtonColor ?? this.plainButtonColor,
    );
  }

  AppKitPopupButtonThemeData merge(AppKitPopupButtonThemeData? other) {
    if (other == null) return this;
    return copyWith(
      elevatedButtonColor: other.elevatedButtonColor,
      plainButtonColor: other.plainButtonColor,
    );
  }

  static AppKitPopupButtonThemeData lerp(
      AppKitPopupButtonThemeData a, AppKitPopupButtonThemeData b, double t) {
    return AppKitPopupButtonThemeData(
      elevatedButtonColor:
          Color.lerp(a.elevatedButtonColor, b.elevatedButtonColor, t),
      plainButtonColor: Color.lerp(a.plainButtonColor, b.plainButtonColor, t),
    );
  }
}
