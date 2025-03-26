import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/debugger.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_window_utils/macos/ns_window_delegate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

typedef MainWindowWidgetBuilder = Widget Function(
    BuildContext context, bool isMainWindow);

abstract mixin class _MainWindowStateListener {
  void dispose();
}

class _MainWindowStateListenerWindowManager
    with WindowListener, _MainWindowStateListener {
  _MainWindowStateListenerWindowManager() {
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();
    MainWindowStateListener.instance.isMainWindow.add(true);
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();
    MainWindowStateListener.instance.isMainWindow.add(false);
  }
}

class _MainWindowStateListenerNSWindowDelegate extends NSWindowDelegate
    with _MainWindowStateListener {
  NSWindowDelegateHandle? _handle;

  _MainWindowStateListenerNSWindowDelegate() {
    _init();
  }

  _init() {
    _initDelegate();
    _initIsWindowMain();
  }

  /// Initializes the [NSWindowDelegate] to listen for main window changes.
  void _initDelegate() {
    _handle = WindowManipulator.addNSWindowDelegate(this);
  }

  @override
  void windowDidBecomeMain() {
    super.windowDidBecomeMain();
    MainWindowStateListener.instance.isMainWindow.sink.add(true);
  }

  @override
  void windowDidResignMain() {
    super.windowDidResignMain();
    MainWindowStateListener.instance.isMainWindow.sink.add(false);
  }

  /// Initializes the [_isMainWindow] variable.
  Future<void> _initIsWindowMain() async {
    MainWindowStateListener.instance.isMainWindow.sink
        .add(await WindowManipulator.isMainWindow());
  }

  /// Disposes this listener.
  @override
  void dispose() {
    _handle?.removeFromHandler();
  }
}

class MainWindowStateListener {
  final BehaviorSubject<bool> isMainWindow = BehaviorSubject.seeded(true);
  static MainWindowStateListener instance = MainWindowStateListener._();
  MainWindowStateListener._();
}

class MainWindowStateListenerDelegate {
  _MainWindowStateListener? _listener;

  void init() {
    _listener ??= AppKitUiElements.useWindowManager
        ? _MainWindowStateListenerWindowManager()
        : _MainWindowStateListenerNSWindowDelegate();
  }

  void dispose() {
    _listener?.dispose();
    _listener = null;
  }
}

/// Model for the main window.
///
/// This model is used to determine if the current window is the main window.
///
/// This model is used by [MainWindowProviderWidgetBuilder].
/// Example:
///
/// ```dart
/// MainWindowProviderWidgetBuilder(
///   builder: (context, isMainWindow) {
///     return isMainWindow ? MyMainWindow() : MySecondaryWindow();
///   },
/// )
/// ```
///
/// Inside a child widget it can be just consumed:
///
/// ```dart
/// final isMainWindow = context.watch<MainWindowModel>().isMainWindow;
/// ```
///
/// or:
///
/// ```dart
/// Consumer<MainWindowModel>(
///   builder: (context, model, child) {
///     return model.isMainWindow ? MyMainWindow() : MySecondaryWindow();
///   },
/// )
/// ```
///
class MainWindowModel extends ChangeNotifier {
  bool _isMainWindow = false;

  bool get isMainWindow => _isMainWindow;

  set isMainWindow(bool value) {
    if (_isMainWindow == value) return;
    _isMainWindow = value;
    notifyListeners();
  }
}

class MainWindowProviderWidgetBuilder extends StatefulWidget {
  final Function(BuildContext context, bool isMainWindow) builder;
  const MainWindowProviderWidgetBuilder({super.key, required this.builder});

  @override
  State<MainWindowProviderWidgetBuilder> createState() =>
      _MainWindowProviderWidgetBuilderState();
}

class _MainWindowProviderWidgetBuilderState
    extends State<MainWindowProviderWidgetBuilder> {
  late final debugLabel = shortHash(this);
  late final _model = MainWindowModel();
  late StreamSubscription<bool> _subscription;
  MainWindowStateListenerDelegate? _delegate;

  @override
  void initState() {
    super.initState();

    _subscription =
        MainWindowStateListener.instance.isMainWindow.listen((isMainWindow) {
      _model.isMainWindow = isMainWindow;
    });

    _delegate = MainWindowStateListenerDelegate()..init();
  }

  @override
  void dispose() {
    _delegate?.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      builder: (context, child) {
        return Consumer<MainWindowModel>(
          builder: (context, model, child) {
            logDebug(this, 'isMainWindow: ${model.isMainWindow}');
            return widget.builder(context, model.isMainWindow);
          },
        );
      },
    );
  }
}
