import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitWallpaperTintingOverride extends StatefulWidget {
  const AppKitWallpaperTintingOverride({super.key, this.child});

  final Widget? child;

  @override
  State<AppKitWallpaperTintingOverride> createState() =>
      _AppKitWallpaperTintingOverrideState();
}

class _AppKitWallpaperTintingOverrideState
    extends State<AppKitWallpaperTintingOverride> {
  @override
  void initState() {
    super.initState();
    AppKitGlobalWallpaperTintingSettings.addWallpaperTintingOverride();
  }

  @override
  void dispose() {
    AppKitGlobalWallpaperTintingSettings.removeWallpaperTintingOverride();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
