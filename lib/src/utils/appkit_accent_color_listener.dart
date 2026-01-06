import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

class AppKitAccentColorStreamBuilder extends StreamBuilder {
  AppKitAccentColorStreamBuilder({super.key, required super.builder})
    : super(stream: AppKitAccentColorListener.instance.onChanged);
}

typedef AppKitAccentColorWidgetBuilder = Widget Function(BuildContext context, AppKitAccentColor? accentColor);

class AppKitAccentColorBuilder extends StatelessWidget {
  final AppKitAccentColorWidgetBuilder builder;

  const AppKitAccentColorBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return AppKitAccentColorStreamBuilder(
      builder: (context, snapshot) {
        final accentColor = snapshot.hasData ? snapshot.data as AppKitAccentColor : null;
        return builder(context, accentColor);
      },
    );
  }
}

class AppKitAccentColorListener {
  AppKitAccentColorListener() {
    _init();
  }

  static final instance = AppKitAccentColorListener();

  static final hueComponentToAccentColor = <double, AppKitAccentColor>{
    0.6085324903200698: AppKitAccentColor.blue,
    0.8285987697113538: AppKitAccentColor.purple,
    0.9209523937489168: AppKitAccentColor.pink,
    0.9861913496946438: AppKitAccentColor.red,
    0.06543037411201169: AppKitAccentColor.orange,
    0.11813830353929083: AppKitAccentColor.yellow,
    0.29428158007138466: AppKitAccentColor.green,
    0.0: AppKitAccentColor.graphite,
  };

  AppKitAccentColor? _currentAccentColor;

  AppKitAccentColor? get currentAccentColor => _currentAccentColor;

  final _accentColorStreamController = StreamController<AppKitAccentColor?>.broadcast();

  Stream<AppKitAccentColor?> get onChanged => _accentColorStreamController.stream;

  StreamSubscription<void>? _systemColorObserverStreamSubscription;

  void _init() {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;

    _initCurrentAccentColor();
    _initSystemColorObserver();
  }

  void dispose() {
    _systemColorObserverStreamSubscription?.cancel();
  }

  Future<void> _initCurrentAccentColor() async {
    final hueComponent = await _getHueComponent();
    _currentAccentColor = _resolveAccentColorFromHueComponent(hueComponent);
    _accentColorStreamController.add(_currentAccentColor);
  }

  void _initSystemColorObserver() {
    assert(_systemColorObserverStreamSubscription == null);
    _systemColorObserverStreamSubscription = AppkitUiElementColors.systemColorObserver.stream.listen((_) {
      _accentColorStreamController.add(null);
      _initCurrentAccentColor();
    });
  }

  Future<double> _getHueComponent() async {
    final color = await AppkitUiElementColors.getColorComponents(
      uiElementColor: UiElementColor.controlAccentColor,
      components: const {NSColorComponent.hueComponent},
      colorSpace: NSColorSpace.genericRGB,
      appearance: NSAppearanceName.aqua,
    );

    assert(color.containsKey("hueComponent"));
    return color["hueComponent"]!;
  }

  AppKitAccentColor _resolveAccentColorFromHueComponent(double hueComponent) {
    if (hueComponentToAccentColor.containsKey(hueComponent)) {
      return hueComponentToAccentColor[hueComponent]!;
    }

    debugPrint(
      'Warning: Falling back on slow accent color resolution. It’s possible '
      'that the accent colors have changed in a recent version of macOS, thus '
      'invalidating macos_ui’s accent colors, which were captured on macOS '
      'Ventura. If you see this message, please notify a maintainer of the '
      'macos_ui package.',
    );

    return _slowlyResolveAccentColorFromHueComponent(hueComponent);
  }

  AppKitAccentColor _slowlyResolveAccentColorFromHueComponent(double hueComponent) {
    final entries = hueComponentToAccentColor.entries;
    var lowestDistance = double.maxFinite;
    var toBeReturnedAccentColor = AppKitAccentColor.values.first;

    for (final entry in entries) {
      final distance = _distanceBetweenHueComponents(hueComponent, entry.key);
      if (distance < lowestDistance) {
        lowestDistance = distance;
        toBeReturnedAccentColor = entry.value;
      }
    }

    return toBeReturnedAccentColor;
  }

  double _distanceBetweenHueComponents(double component1, double component2) {
    final rawDifference = (component1 - component2).abs();
    return sin(rawDifference * pi);
  }
}
