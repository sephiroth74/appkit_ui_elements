import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _kSheetBorderRadius = BorderRadius.all(Radius.circular(12.0));
const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 140.0, vertical: 48.0);

class AppKitSheet extends StatelessWidget {
  const AppKitSheet({
    super.key,
    required this.child,
    this.insetPadding = _defaultInsetPadding,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsets? insetPadding;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    final EdgeInsets effectivePadding =
        MediaQuery.of(context).viewInsets + (insetPadding ?? EdgeInsets.zero);

    return MainWindowBuilder(builder: (context, isMainWindow) {
      final theme = AppKitTheme.of(context);
      final brightness = AppKitTheme.brightnessOf(context);

      final outerBorderColor = brightness.resolve(
        Colors.black.withOpacity(0.23),
        Colors.black.withOpacity(0.76),
      );

      final innerBorderColor = brightness.resolve(
        Colors.white.withOpacity(0.45),
        Colors.white.withOpacity(0.15),
      );
      return AnimatedPadding(
        padding: effectivePadding,
        duration: insetAnimationDuration,
        curve: insetAnimationCurve,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: backgroundColor ??
                  brightness.resolve(
                    CupertinoColors.systemGrey6.color,
                    theme.controlBackgroundColor,
                  ),
              borderRadius: _kSheetBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: AppKitColors.shadowColor.withOpacity(0.55),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: innerBorderColor,
              ),
              borderRadius: _kSheetBorderRadius,
            ),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: outerBorderColor,
              ),
              borderRadius: _kSheetBorderRadius,
            ),
            child: child,
          ),
        ),
      );
    });
  }
}

Future<T?> showAppKitSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  final provider = MainWindowStateListener.instance;
  final initialData = Stream.value(provider.isMainWindow.value);
  final stream = provider.isMainWindow;

  // combine the two streams and return the first value
  return Stream.fromFutures([initialData.first, stream.first])
      .first
      .then((data) {
    if (!context.mounted) {
      return null;
    }

    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final theme = AppKitTheme.of(context);

    return navigator.push<T>(
      _AppKitSheetRoute<T>(
        settings: routeSettings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return MainWindowBuilder(
            builder: (context, isMainWindow) {
              return builder(context);
            },
          );
        },
        capturedThemes: InheritedTheme.capture(
          from: context,
          // ignore: use_build_context_synchronously
          to: navigator.context,
        ),
        barrierDismissible: barrierDismissible,
        barrierColor:
            barrierColor ?? theme.controlBackgroundColor.multiplyOpacity(0.5),
        barrierLabel: barrierLabel ??
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  });
}

class _AppKitSheetRoute<T> extends PopupRoute<T> {
  _AppKitSheetRoute({
    required RoutePageBuilder pageBuilder,
    required this.capturedThemes,
    bool barrierDismissible = false,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    super.settings,
  })  : _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor;

  final RoutePageBuilder _pageBuilder;

  final CapturedThemes capturedThemes;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  Curve get barrierCurve => Curves.linear;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 120);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: capturedThemes
          .wrap(_pageBuilder(context, animation, secondaryAnimation)),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutSine,
        ),
        child: child,
      );
    }
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: const SubtleBounceCurve(),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
        child: child,
      ),
    );
  }
}
