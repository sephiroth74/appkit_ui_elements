import 'package:appkit_ui_elements/src/controls/appkit_custom_painter_button.dart';

/// A custom disclosure button widget with customizable properties.
///
/// The [AppKitDisclosureButton] widget allows users to create a button that toggles
/// between an "up" and "down" state, typically used to show or hide content.
///
/// Example usage:
/// ```dart
/// AppKitDisclosureButton(
///   isDown: true,
///   onPressed: () {
///     print('Disclosure button pressed');
///   },
/// )
/// ```
class AppKitDisclosureButton extends AppKitCustomPainterButton {
  /// Indicates whether the button is in the "down" state.
  ///
  /// If true, the button shows the "down" icon. If false, the button shows the "up" icon.
  final bool isDown;

  /// Creates an [AppKitDisclosureButton] widget.
  ///
  /// The [isDown] parameter must not be null.
  const AppKitDisclosureButton({
    super.key,
    super.color,
    super.size,
    super.semanticLabel,
    super.onPressed,
    required this.isDown,
  }) : super(
            icon: isDown
                ? AppKitControlButtonIcon.disclosureDown
                : AppKitControlButtonIcon.disclosureUp);
}
