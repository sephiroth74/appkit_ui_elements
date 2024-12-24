import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitWallpaperTintingOverride extends StatefulWidget {
  const AppKitWallpaperTintingOverride({
    super.key,
    this.child,
    this.enabled = true,
  });

  final Widget? child;
  final bool enabled;

  @override
  State<AppKitWallpaperTintingOverride> createState() =>
      _AppKitWallpaperTintingOverrideState();
}

class _AppKitWallpaperTintingOverrideState
    extends State<AppKitWallpaperTintingOverride> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      AppKitGlobalWallpaperTintingSettings.addWallpaperTintingOverride();
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      AppKitGlobalWallpaperTintingSettings.removeWallpaperTintingOverride();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
