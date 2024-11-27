import 'package:appkit_ui_elements/src/utils/global_wallpaper_tinting_settings.dart';
import 'package:flutter/material.dart';

class WallpaperTintingOverride extends StatefulWidget {
  const WallpaperTintingOverride({super.key, this.child});

  final Widget? child;

  @override
  State<WallpaperTintingOverride> createState() =>
      _WallpaperTintingOverrideState();
}

class _WallpaperTintingOverrideState extends State<WallpaperTintingOverride> {
  @override
  void initState() {
    super.initState();
    GlobalWallpaperTintingSettings.addWallpaperTintingOverride();
  }

  @override
  void dispose() {
    GlobalWallpaperTintingSettings.removeWallpaperTintingOverride();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
