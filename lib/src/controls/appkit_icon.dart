import 'package:appkit_ui_elements/appkit_ui_elements.dart';

/// A custom icon widget with customizable properties.
///
/// The [AppKitIcon] widget allows users to display an icon with customizable
/// size and color. The appearance of the icon can be customized using various
/// properties.
///
/// Example usage:
/// ```dart
/// AppKitIcon(
///   Icons.home,
///   size: 24.0,
///   color: Colors.blue,
/// )
/// ```
class AppKitIcon extends StatelessWidget {
  /// The icon to display.
  ///
  /// Must not be null.
  final IconData icon;

  /// The size of the icon.
  ///
  /// If null, the default size from the theme will be used.
  final double? size;

  /// The color of the icon.
  ///
  /// If null, the default color from the theme will be used.
  final Color? color;

  /// Creates an [AppKitIcon] widget.
  ///
  /// The [icon] parameter must not be null.
  const AppKitIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final theme = AppKitIconTheme.of(context);
    final size = this.size ?? theme.size;
    final color = this.color ?? theme.color;
    return Icon(icon, size: size, color: color);
  }
}
