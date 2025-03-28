import 'dart:ui';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:macos_window_utils/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:provider/provider.dart';

class AppKitOverlayFilterWidget extends StatelessWidget {
  const AppKitOverlayFilterWidget({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.backgroundBlur,
    this.color,
    this.enableWallpaperTinting = true,
  });

  final bool enableWallpaperTinting;

  final double backgroundBlur;

  /// The widget to apply the blur filter to.
  final Widget child;

  /// The border radius to use when applying the effect to the
  /// child widget.
  final BorderRadius borderRadius;

  /// The color to use as the filter's background.
  ///
  /// If it is null, the macOS default surface background
  /// colors will be used.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppKitWallpaperTintingOverride(
      enabled: enableWallpaperTinting,
      child: Consumer<MainWindowModel>(builder: (context, model, _) {
        return VisualEffectSubviewContainer(
          cornerRadius: borderRadius.topLeft.x,
          material: NSVisualEffectViewMaterial.menu,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
              border: Border.all(
                color: AppKitColors.shadowColor.withValues(alpha: 0.35),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppKitColors.shadowColor.withValues(alpha: 0.25),
                  offset: const Offset(0, 3.5),
                  blurRadius: 11.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: BackdropFilter(
                blendMode: BlendMode.srcOver,
                filter: ImageFilter.blur(
                    sigmaX: backgroundBlur,
                    sigmaY: backgroundBlur,
                    tileMode: TileMode.clamp),
                child: child,
              ),
            ),
          ),
        );
      }),
    );
  }
}
