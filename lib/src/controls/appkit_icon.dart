import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const AppKitIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final theme = AppKitIconTheme.of(context);
    return Icon(
      icon,
      size: size,
      color: color ?? theme.color,
    );
  }
}
