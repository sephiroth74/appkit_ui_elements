import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const _kDialogBorderRadius = BorderRadius.all(Radius.circular(10.0));
const _kDefaultDialogConstraints = BoxConstraints(
  minWidth: 260,
  maxWidth: 260,
);

class AppKitDialog extends StatelessWidget {
  const AppKitDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButton,
    this.icon,
    this.secondaryButton,
    this.horizontalActions = true,
    this.suppress,
  });

  final IconData? icon;

  final Widget title;

  final Widget message;

  final AppKitButton primaryButton;

  final AppKitButton? secondaryButton;

  final bool? horizontalActions;

  final Widget? suppress;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    if (secondaryButton != null) {
      assert(secondaryButton is AppKitButton);
    }
    final brightness = AppKitTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withOpacity(0.45),
      Colors.white.withOpacity(0.15),
    );

    return MainWindowBuilder(builder: (context, isMainWindow) {
      final theme = AppKitTheme.of(context);
      return Dialog(
        elevation: 20,
        shadowColor: AppKitColors.shadowColor,
        backgroundColor: brightness.resolve(
          CupertinoColors.systemGrey6.color,
          theme.controlBackgroundColor,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: _kDialogBorderRadius,
        ),
        child: Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, bottom: 16.0, top: 20.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: innerBorderColor,
            ),
            borderRadius: _kDialogBorderRadius,
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: outerBorderColor,
            ),
            borderRadius: _kDialogBorderRadius,
          ),
          child: ConstrainedBox(
            constraints: _kDefaultDialogConstraints,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 64,
                    maxWidth: 64,
                  ),
                  child: Icon(icon, size: 64),
                ),
                const SizedBox(height: 16),
                DefaultTextStyle(
                  style: theme.typography.headline,
                  textAlign: TextAlign.center,
                  child: title,
                ),
                const SizedBox(height: 10),
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: theme.typography.subheadline,
                  child: message,
                ),
                const SizedBox(height: 16),
                if (secondaryButton == null) ...[
                  Row(
                    children: [
                      Expanded(child: primaryButton),
                    ],
                  ),
                ] else ...[
                  if (horizontalActions!) ...[
                    Row(
                      children: [
                        if (secondaryButton != null) ...[
                          Expanded(child: secondaryButton!),
                          const SizedBox(width: 8.0),
                        ],
                        Expanded(
                          child: primaryButton,
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: primaryButton),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        if (secondaryButton != null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: secondaryButton!,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
                if (suppress != null) ...[
                  const SizedBox(height: 16),
                  DefaultTextStyle(
                    style: theme.typography.headline,
                    child: suppress!,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Displays a macos alert dialog above the current contents of the app.
Future<T?> showAppKitDialog<T>({
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
      _AppKitDialogRoute<T>(
        settings: routeSettings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Builder(
            builder: (context) {
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

class _AppKitDialogRoute<T> extends PopupRoute<T> {
  _AppKitDialogRoute({
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

@protected
class SubtleBounceCurve extends Curve {
  const SubtleBounceCurve();

  @override
  double transform(double t) {
    final simulation = SpringSimulation(
      const SpringDescription(
        damping: 14,
        mass: 1.4,
        stiffness: 180,
      ),
      0.0,
      1.0,
      0.1,
    );
    return simulation.x(t) + t * (1 - simulation.x(1.0));
  }
}
