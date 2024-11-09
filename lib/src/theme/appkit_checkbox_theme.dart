import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppkitCheckboxTheme extends InheritedTheme {
  final AppKitCheckboxThemeData data;

  const AppkitCheckboxTheme(
      {super.key, required super.child, required this.data});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    throw UnimplementedError();
  }
}

class AppKitCheckboxThemeData with Diagnosticable {}
