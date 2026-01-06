import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A plain button widget for the AppKit UI library.
///
/// This button is a stateful widget that provides a simple button
/// with customizable appearance and behavior.
///
/// Example usage:
///
/// ```dart
/// AppKitPlainButton(
///   onPressed: () {
///     // Handle button press
///   },
///   child: Text('Press Me'),
/// )
/// ```
///
/// See also:
///
///  * [AppKitIconButton], a similar button that includes an icon.
///  * [AppKitButton], a button that displays text.
///
class AppKitPlainButton extends StatefulWidget {
  /// A widget that represents the child of the button.
  final Widget child;

  /// The color of the button. If null, the default color will be used.
  final Color? color;

  /// The callback that is called when the button is pressed. If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The semantic label for the button, used for accessibility.
  final String? semanticLabel;

  const AppKitPlainButton({super.key, required this.child, required this.onPressed, this.semanticLabel, this.color});

  @override
  State<AppKitPlainButton> createState() => _AppKitPlainButtonState();
}

class _AppKitPlainButtonState extends State<AppKitPlainButton> {
  bool get enabled => widget.onPressed != null;
  bool isDown = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => isDown = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => isDown = false);
  }

  void _handleTapCancel() {
    setState(() => isDown = false);
  }

  void _handleTap() {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: enabled ? _handleTap : null,
        child: Consumer<MainWindowModel>(
          builder: (context, model, _) {
            final theme = AppKitTheme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            final color = widget.color ?? AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.quaternary);
            final blendedColor = Color.lerp(theme.canvasColor, color, color.a)!;

            final lumination = blendedColor.computeLuminance();
            final textColor = lumination > 0.5
                ? AppKitColors.text.opaque.primary.darkColor
                : AppKitColors.text.opaque.primary.color;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              foregroundDecoration: isDown
                  ? BoxDecoration(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1))
                  : null,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.0)),
              child: Center(
                child: DefaultTextStyle(
                  style: theme.typography.body.copyWith(color: textColor),
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
