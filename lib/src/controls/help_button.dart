import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

const _kSize = 20.0;
const _kSizeIconRatio = 0.65;

class AppKitHelpButton extends StatefulWidget {
  final Color? color;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final MouseCursor cursor;
  final double size;

  const AppKitHelpButton({
    super.key,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.basic,
    this.size = _kSize,
  });

  bool get enabled => onPressed != null;

  @override
  State<AppKitHelpButton> createState() => _AppKitHelpButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed,
        ifNull: 'disabled', ifPresent: 'enabled'));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<MouseCursor>('cursor', cursor));
    properties.add(DoubleProperty('size', size));
  }
}

class _AppKitHelpButtonState extends State<AppKitHelpButton> {
  @visibleForTesting
  bool buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!buttonHeldDown) {
      setState(() => buttonHeldDown = true);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  void _handleTapCancel() {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final helpButtonTheme = AppKitHelpButtonTheme.of(context);
    return MouseRegion(
      cursor: widget.cursor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? _handleTapDown : null,
        onTapUp: widget.enabled ? _handleTapUp : null,
        onTapCancel: widget.enabled ? _handleTapCancel : null,
        onTap: () => widget.onPressed?.call(),
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          child: Container(
            constraints: BoxConstraints(
                minWidth: widget.size,
                minHeight: widget.size,
                maxWidth: widget.size,
                maxHeight: widget.size),
            child: UiElementColorBuilder(
              builder: (context, colorContainer) {
                final color = widget.enabled
                    ? (widget.color ??
                        helpButtonTheme.color ??
                        MacosColors.controlBackgroundColor)
                    : (widget.disabledColor ??
                        helpButtonTheme.disabledColor ??
                        MacosColors.controlBackgroundColor.withOpacity(0.5));

                final colorLuminance = color.computeLuminance();

                Color iconColor = colorLuminance > 0.5
                    ? MacosColors.controlTextColor.color
                    : MacosColors.controlTextColor.darkColor;

                if (!widget.enabled) {
                  iconColor = MacosColors.tertiaryLabelColor.color;
                }

                final foregroundColor = colorLuminance > 0.5
                    ? MacosColors.black.withOpacity(0.1)
                    : MacosColors.white.withOpacity(0.2);

                return Container(
                  foregroundDecoration: buttonHeldDown
                      ? BoxDecoration(
                          color: foregroundColor, shape: BoxShape.circle)
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(
                              blurStyle: BlurStyle.outer,
                              offset: const Offset(0, 0.25),
                              blurRadius: 1.5,
                              spreadRadius: 0,
                              color: MacosColors.black.withOpacity(0.3)),
                          BoxShadow(
                              blurStyle: BlurStyle.outer,
                              offset: const Offset(0, 0),
                              blurRadius: 0,
                              spreadRadius: 0.5,
                              color: MacosColors.black.withOpacity(0.05))
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.question,
                        size: widget.size * _kSizeIconRatio,
                        color: iconColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
