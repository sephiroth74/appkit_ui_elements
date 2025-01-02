import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitToggleButton extends StatefulWidget {
  const AppKitToggleButton({
    super.key,
    required this.onChanged,
    required this.childOn,
    required this.childOff,
    required this.isOn,
    this.type = AppKitButtonType.primary,
    this.padding,
    this.semanticLabel,
    this.color,
    this.mouseCursor = SystemMouseCursors.basic,
    this.size = AppKitControlSize.regular,
  });

  final bool isOn;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;
  final MouseCursor mouseCursor;
  final AppKitButtonType type;
  final Widget childOn;
  final Widget childOff;
  final AppKitControlSize size;
  final Color? color;
  final AppKitButtonStyle style = AppKitButtonStyle.push;

  bool get enabled => onChanged != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitControlSize>('controlSize', size));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties
        .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(DiagnosticsProperty<Color>('color', color));
    properties.add(EnumProperty<AppKitButtonType>('type', type));
    properties.add(EnumProperty<AppKitButtonStyle>('style', style));
  }

  @override
  State<AppKitToggleButton> createState() => _AppKitToggleButtonState();
}

class _AppKitToggleButtonState extends State<AppKitToggleButton> {
  bool get isOn => widget.isOn;

  bool get enabled => widget.onChanged != null;

  void _handleOnPressed() {
    if (enabled) {
      widget.onChanged?.call(!isOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final theme = AppKitTheme.of(context);
    final buttonTheme = AppKitButtonTheme.of(context);

    return AppKitButtonTheme(
        data: buttonTheme.copyWith(
          push: buttonTheme.push.copyWith(
            accentColor: widget.type == AppKitButtonType.primary && isOn
                ? null
                : buttonTheme.push.secondaryColor,
          ),
        ),
        child: AppKitButton(
          accentColor: widget.color,
          mouseCursor: widget.mouseCursor,
          onPressed: enabled ? _handleOnPressed : null,
          padding: widget.padding,
          semanticLabel: widget.semanticLabel,
          size: widget.size,
          style: widget.style,
          type: widget.type == AppKitButtonType.primary && isOn
              ? widget.type
              : AppKitButtonType.secondary,
          textStyle: isOn && widget.type != AppKitButtonType.primary
              ? TextStyle(
                  color: widget.color ??
                      buttonTheme.push.accentColor ??
                      theme.activeColor)
              : null,
          child: isOn ? widget.childOn : widget.childOff,
        ));
  }
}
