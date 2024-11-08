import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:rxdart/rxdart.dart';

class MainWindowStreamBuilder extends StreamBuilder {
  MainWindowStreamBuilder({super.key, required super.builder})
      : super(stream: MainWindowStateListener.instance.isMainWindow);
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
