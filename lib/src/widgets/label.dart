import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';

class AppKitLabel extends StatelessWidget {
  /// Creates a label.
  const AppKitLabel({
    super.key,
    this.icon,
    required this.text,
    this.child,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final Widget? icon;

  final Widget text;

  final Widget? child;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final theme = AppKitTheme.of(context);
    final text = DefaultTextStyle(
      style: (theme.typography.body).copyWith(
        color: AppKitColors.labelColor.resolveFrom(context),
        fontWeight: FontWeight.w500,
      ),
      child: this.text,
    );
    return UiElementColorBuilder(builder: (context, colorContainer) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: AppKitIconTheme(
                data: AppKitIconThemeData(
                  size: theme.typography.body.fontSize ?? 24,
                  color: colorContainer.controlAccentColor,
                ),
                child: icon!,
              ),
            ),
          text,
          if (child != null) child!,
        ],
      );
    });
  }
}
