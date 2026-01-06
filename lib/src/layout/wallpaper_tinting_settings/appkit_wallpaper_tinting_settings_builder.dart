import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitWallpaperTintingSettingsBuilder extends StatelessWidget {
  const AppKitWallpaperTintingSettingsBuilder({super.key, required this.builder});

  final Widget Function(BuildContext, AppKitWallpaperTintingSettingsData) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppKitWallpaperTintingSettingsData>(
      stream: AppKitGlobalWallpaperTintingSettings.onDataChangedStream,
      initialData: AppKitGlobalWallpaperTintingSettings.data,
      builder: (context, snapshot) {
        final data = snapshot.data ?? AppKitGlobalWallpaperTintingSettings.data;

        return builder(context, data);
      },
    );
  }
}
