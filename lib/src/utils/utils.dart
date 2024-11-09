import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

bool debugCheckHasAppKitTheme(BuildContext context, [bool check = true]) {
  assert(() {
    if (AppKitTheme.maybeOf(context) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('A AppKitTheme widget is necessary to draw this layout.'),
        ErrorHint(
          'To introduce a AppKitTheme widget, you can either directly '
          'include one, or use a widget that contains MacosTheme itself, '
          'such as MacosApp',
        ),
        ...context.describeMissingAncestor(
            expectedAncestorType: AppKitThemeData),
      ]);
    }
    return true;
  }());
  return true;
}

Color luminance(Color backgroundColor,
    {required CupertinoDynamicColor textColor}) {
  return backgroundColor.computeLuminance() >= 0.5
      ? textColor.darkColor
      : textColor.color;
}
