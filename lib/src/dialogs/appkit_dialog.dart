import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';

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
    this.tertiaryButton,
    this.horizontalActions = true,
    this.suppress,
    this.constraints,
  });

  final Widget? icon;

  final Widget title;

  final WidgetBuilder message;

  final Widget primaryButton;

  final Widget? secondaryButton;

  final Widget? tertiaryButton;

  final bool horizontalActions;

  final Widget? suppress;

  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final brightness = AppKitTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withValues(alpha: 0.23),
      Colors.black.withValues(alpha: 0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withValues(alpha: 0.45),
      Colors.white.withValues(alpha: 0.15),
    );

    return Consumer<MainWindowModel>(builder: (context, model, _) {
      final theme = AppKitTheme.of(context);
      final isHeightConstrained = constraints?.hasBoundedHeight ?? false;
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
          constraints: constraints ?? _kDefaultDialogConstraints,
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
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: constraints,
              child: Column(
                mainAxisSize:
                    isHeightConstrained ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Flexible(
                      flex: 0,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 64,
                          maxWidth: 64,
                        ),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: AppKitIconTheme(
                              data: AppKitTheme.of(context)
                                  .iconTheme
                                  .copyWith(size: 64),
                              child: icon!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Flexible(
                    flex: 0,
                    child: DefaultTextStyle(
                      style: theme.typography.headline,
                      textAlign: TextAlign.center,
                      child: title,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: isHeightConstrained ? 1 : 0,
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: theme.typography.subheadline,
                      child: message.call(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (horizontalActions) ...[
                    Flexible(
                      flex: 0,
                      child: Row(
                        children: [
                          if (tertiaryButton != null) ...[
                            Expanded(flex: 4, child: tertiaryButton!),
                            const SizedBox(width: 16.0),
                            const Spacer(
                              flex: 1,
                            )
                          ],
                          if (secondaryButton != null) ...[
                            Expanded(
                              flex: 4,
                              child: secondaryButton!,
                            ),
                            const SizedBox(width: 8.0),
                          ],
                          Expanded(
                            flex: 4,
                            child: primaryButton,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Flexible(
                      flex: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(child: primaryButton),
                            ],
                          ),
                          if (secondaryButton != null) ...[
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Expanded(
                                  child: secondaryButton!,
                                ),
                              ],
                            ),
                          ],
                          if (tertiaryButton != null) ...[
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Expanded(
                                  child: tertiaryButton!,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (suppress != null) ...[
                    const SizedBox(height: 16),
                    Flexible(
                      flex: 0,
                      child: DefaultTextStyle(
                        style: theme.typography.headline,
                        child: suppress!,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
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
