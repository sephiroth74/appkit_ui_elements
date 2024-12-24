import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const AppKitIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final theme = AppKitIconTheme.of(context);
    final size = this.size ?? theme.size;
    final color = this.color ?? theme.color;
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
