import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:provider/provider.dart';

/// A custom label widget that extends [StatelessWidget].
///
/// This widget is used to display text with custom styling and properties.
///
/// Example usage:
///
/// ```dart
/// AppKitLabel(
///   text: Text('Hello, World!'),
/// )
/// ```
///
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
    return Consumer<MainWindowModel>(
      builder: (context, model, _) {
        final theme = AppKitTheme.of(context);
        final text = DefaultTextStyle(
          style: (theme.typography.body).copyWith(
            color: AppKitDynamicColor.resolve(context, AppKitColors.labelColor),
            fontWeight: FontWeight.w500,
          ),
          child: this.text,
        );
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AppKitIconTheme(
                  data: AppKitIconThemeData(size: theme.typography.body.fontSize ?? 24, color: theme.activeColor),
                  child: icon!,
                ),
              ),
            text,
            if (child != null) child!,
          ],
        );
      },
    );
  }
}
