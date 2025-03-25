import 'dart:async';
import 'dart:io';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:macos_window_utils/macos/ns_window_delegate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

typedef MainWindowWidgetBuilder = Widget Function(
    BuildContext context, bool isMainWindow);

class MainWindowListener extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool>? onMainWindowChanged;

  const MainWindowListener({
    super.key,
    required this.child,
    required this.onMainWindowChanged,
  });

  @override
  State<MainWindowListener> createState() => _MainWindowListenerState();
}

class _MainWindowListenerState extends State<MainWindowListener> {
  late StreamSubscription<bool> _subscription;
  late bool _isMainWindow;

  @override
  void initState() {
    super.initState();
    _isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
    _subscription =
        MainWindowStateListener.instance.isMainWindow.listen((isMainWindow) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_isMainWindow == isMainWindow) return;
        _isMainWindow = isMainWindow;
        widget.onMainWindowChanged?.call(isMainWindow);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainWindowListener oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MainWindowStateListener {
  final BehaviorSubject<bool> isMainWindow = BehaviorSubject.seeded(true);

  static MainWindowStateListener instance =
      MainWindowStateListener._constructor();

  NSWindowDelegateHandle? _handle;

  MainWindowStateListener._constructor() {
    _init();
  }

  _init() {
    if (kIsWeb) return;
    if (!Platform.isMacOS) return;

    _initDelegate();
    _initIsWindowMain();
  }

  /// Initializes the [NSWindowDelegate] to listen for main window changes.
  void _initDelegate() {
    final delegate = _MainWindowStateListenerDelegate(
      onWindowDidBecomeMain: () => isMainWindow.add(true),
      onWindowDidResignMain: () => isMainWindow.add(false),
    );
    _handle = WindowManipulator.addNSWindowDelegate(delegate);
  }

  /// Initializes the [_isMainWindow] variable.
  Future<void> _initIsWindowMain() async {
    isMainWindow.sink.add(await WindowManipulator.isMainWindow());
  }

  /// Disposes this listener.
  void dispose() {
    _handle?.removeFromHandler();
  }
}

/// The [NSWindowDelegate] used by [WindowMainStateListener].
class _MainWindowStateListenerDelegate extends NSWindowDelegate {
  _MainWindowStateListenerDelegate({
    required this.onWindowDidBecomeMain,
    required this.onWindowDidResignMain,
  });

  /// Called when the window becomes the main window.
  final void Function() onWindowDidBecomeMain;

  /// Called when the window resigns as the main window.
  final void Function() onWindowDidResignMain;

  @override
  void windowDidBecomeMain() => onWindowDidBecomeMain();

  @override
  void windowDidResignMain() => onWindowDidResignMain();
}

class MainWindowModel extends ChangeNotifier {
  bool _isMainWindow = true;

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

  @override
  void initState() {
    super.initState();

    _subscription =
        MainWindowStateListener.instance.isMainWindow.listen((isMainWindow) {
      _model.isMainWindow = isMainWindow;
    });
  }

  @override
  void dispose() {
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
            return widget.builder(context, model.isMainWindow);
          },
        );
      },
    );
  }
}
