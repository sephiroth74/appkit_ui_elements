import 'dart:ui';
import 'package:appkit_ui_elements/src/widgets/wallpaper_tinting_override.dart';
import 'package:flutter/material.dart';

class AppKitOverlayFilterWidget extends StatelessWidget {
  const AppKitOverlayFilterWidget({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.backgroundBlur,
    this.color,
  });

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
    return WallpaperTintingOverride(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 0),
              blurRadius: 0.5,
              spreadRadius: 0.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 0),
              blurRadius: 0.75,
              spreadRadius: 0.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 3.5),
              blurRadius: 11.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur,
              sigmaY: backgroundBlur,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
