import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

/// A custom toggle button widget for the AppKit UI library.
///
/// This widget extends [StatefulWidget] and provides a toggle button
/// that can be used to switch between two states (on/off).
///
/// Example usage:
/// ```dart
/// AppKitToggleButton(
///   isOn: true,
///   onChanged: (isOn) {
///     print('Toggle button state: $isOn');
///   },
///   childOn: Icon(Icons.check),
///   childOff: Icon(Icons.close),
/// )
/// ```
///
/// The [AppKitToggleButton] can be customized with various properties
/// to fit the needs of your application.
class AppKitToggleButton extends StatefulWidget {
  /// Indicates whether the toggle button is in the "on" state.
  ///
  /// When `true`, the toggle button is in the "on" state.
  /// When `false`, the toggle button is in the "off" state.
  final bool isOn;

  final EdgeInsetsGeometry? padding;

  /// A callback that is called when the toggle button's state is changed.
  ///
  /// The callback receives a boolean value indicating the new state of the
  /// toggle button. If the value is `true`, the button is in the "on" state;
  /// if `false`, the button is in the "off" state.
  ///
  /// This callback is optional and can be `null`. If it is `null`, the
  /// toggle button will be disabled and will not respond to user input.
  final ValueChanged<bool>? onChanged;

  /// A semantic label for the toggle button, which can be used by screen readers
  /// to provide a description of the button's purpose. This is particularly
  /// useful for accessibility purposes.
  ///
  /// If null, no semantic label will be provided.
  final String? semanticLabel;

  /// The cursor to be displayed when the mouse pointer is over the toggle button.
  ///
  /// This property allows you to customize the appearance of the mouse cursor
  /// when it hovers over the toggle button, providing better visual feedback
  /// to the user. It accepts a [MouseCursor] object, which can be set to various
  /// predefined cursor styles or a custom cursor.
  final MouseCursor mouseCursor;

  /// The type of the AppKit button.
  ///
  /// This determines the visual style and behavior of the button.
  /// It is defined by the [AppKitButtonType] enumeration.
  final AppKitButtonType type;

  /// The widget to display when the toggle button is in the "on" state.
  final Widget childOn;

  /// The widget to display when the toggle button is in the "off" state.
  final Widget childOff;

  /// The size of the AppKit toggle button.
  ///
  /// This determines the overall dimensions of the button, which can be
  /// useful for creating a consistent UI layout. The size is defined
  /// using the `AppKitControlSize` enum.
  final AppKitControlSize size;

  /// The color of the toggle button.
  ///
  /// This property allows you to set a custom color for the toggle button.
  /// If no color is provided, the default color will be used.
  final Color? color;

  /// The style of the AppKit button, which determines its appearance and behavior.
  ///
  /// This is a final variable of type `AppKitButtonStyle` and is set to `AppKitButtonStyle.push`.
  final AppKitButtonStyle style = AppKitButtonStyle.push;

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
          onTap: enabled ? _handleOnPressed : null,
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
