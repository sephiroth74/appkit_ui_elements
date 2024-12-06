import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/material.dart';

class AppKitPlainButton extends StatefulWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  const AppKitPlainButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.semanticLabel,
    this.color,
  });

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
        child: UiElementColorBuilder(builder: (context, colorContainer) {
          final color = widget.color ??
              AppKitColors.text.opaque.quaternary.resolveFrom(context);

          final lumination = color.computeLuminance();
          final textColor = lumination > 0.5
              ? AppKitColors.text.opaque.primary.darkColor
              : AppKitColors.text.opaque.primary.color;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            foregroundDecoration: isDown
                ? BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  )
                : null,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: DefaultTextStyle(
                style: AppKitTheme.of(context)
                    .typography
                    .body
                    .copyWith(color: textColor),
                child: widget.child,
              ),
            ),
          );
        }),
      ),
    );
  }
}
