import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

/// Defines the height of a regular-sized [AppKitTitleBar].
const kTitleBarHeight = 28.0;

class AppKitTitleBar extends StatelessWidget {
  const AppKitTitleBar({
    super.key,
    this.height = kTitleBarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.padding = const EdgeInsets.all(8),
    this.decoration,
    this.centerTitle = true,
    this.dividerColor,
  });

  /// Specifies the height of this [AppKitTitleBar].
  ///
  /// Defaults to [kTitleBarHeight] which is 28.0.
  final double height;

  /// Align the [title] within the [AppKitTitleBar].
  ///
  /// Defaults to [Alignment.center].
  ///
  /// The [AppKitTitleBar] will expand to fill its parent and position its
  /// child within itself according to the given value.
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment alignment;

  /// The [title] contained by the container.
  final Widget? title;

  /// The decoration to paint behind the [title].
  final BoxDecoration? decoration;

  /// Empty space to inscribe inside the title bar. The [title], if any, is
  /// placed inside this padding.
  ///
  /// Defaults to `EdgeInsets.all(8)`
  final EdgeInsets padding;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// The color of the divider below the title bar.
  ///
  /// Defaults to MacosTheme.of(context).dividerColor.
  ///
  /// Set it to MacosColors.transparent to remove.
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    // ignore: no_leading_underscores_for_local_identifiers
    Widget? _title = title;
    if (_title != null) {
      _title = DefaultTextStyle(
        style: theme.typography.headline.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: theme.brightness.isDark
              ? const Color(0xFFEAEAEA)
              : const Color(0xFF4D4D4D),
        ),
        child: _title,
      );
    }

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(
          left: !kIsWeb && isMacOS ? 70 : 0,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: decoration?.color?.a == 1.0
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            alignment: alignment,
            padding: padding,
            decoration: BoxDecoration(
              color: theme.canvasColor,
              border: Border(
                bottom: BorderSide(color: dividerColor ?? theme.dividerColor),
              ),
            ).copyWith(
              color: decoration?.color,
              image: decoration?.image,
              border: decoration?.border,
              borderRadius: decoration?.borderRadius,
              boxShadow: decoration?.boxShadow,
              gradient: decoration?.gradient,
            ),
            child: NavigationToolbar(
              middle: _title,
              centerMiddle: centerTitle,
              middleSpacing: 8,
            ),
          ),
        ),
      ),
    );
  }
}
