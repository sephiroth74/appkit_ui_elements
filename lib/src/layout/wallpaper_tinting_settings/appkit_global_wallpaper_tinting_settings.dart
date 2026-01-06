import 'dart:async';

class AppKitGlobalWallpaperTintingSettings {
  static final AppKitWallpaperTintingSettingsData data = AppKitWallpaperTintingSettingsData();

  /// The [StreamController] for an event stream that is triggered when [data]
  /// changes.
  static final _onDataChangedStreamController = StreamController<AppKitWallpaperTintingSettingsData>.broadcast();

  /// A stream that can be used to listen to [data] changes.
  static Stream<AppKitWallpaperTintingSettingsData> get onDataChangedStream => _onDataChangedStreamController.stream;

  /// Gets whether wallpaper tinting should be enabled.
  static bool get isWallpaperTintingEnabled => data.isWallpaperTintingEnabled;

  /// Increments the number of active overrides.
  static void addWallpaperTintingOverride() {
    data.addOverride();
    _onDataChangedStreamController.add(data);
  }

  /// Decrements the number of active overrides.
  static void removeWallpaperTintingOverride() {
    data.removeOverride();
    _onDataChangedStreamController.add(data);
  }

  /// Disables wallpaper tinting altogether.
  static void disableWallpaperTinting() {
    data.disableWallpaperTinting();
    _onDataChangedStreamController.add(data);
  }

  /// Allows wallpaper tinting, unless overridden.
  static void allowWallpaperTinting() {
    data.allowWallpaperTinting();
    _onDataChangedStreamController.add(data);
  }
}

/// Holds data related to wallpaper tinting.
class AppKitWallpaperTintingSettingsData {
  /// The number of wallpaper tinting overrides that are currently active.
  ///
  /// A wallpaper tinting override causes wallpaper tinting to be disabled.
  int _numberOfWallpaperTintingOverrides = 0;

  /// Whether wallpaper tinting is disabled by the application's window.
  bool _isWallpaperTintingDisabledByWindow = false;

  /// Gets whether wallpaper tinting should be enabled.
  bool get isWallpaperTintingEnabled => !_isWallpaperTintingDisabledByWindow && _numberOfWallpaperTintingOverrides == 0;

  /// Gets whether wallpaper tinting is disabled by the application's window.
  bool get isWallpaperTintingDisabledByWindow => _isWallpaperTintingDisabledByWindow;

  /// Increments the number of active overrides.
  void addOverride() => _numberOfWallpaperTintingOverrides += 1;

  /// Decrements the number of active overrides.
  void removeOverride() {
    _numberOfWallpaperTintingOverrides -= 1;
    assert(_numberOfWallpaperTintingOverrides >= 0);
  }

  /// Disables wallpaper tinting altogether.
  void disableWallpaperTinting() {
    _isWallpaperTintingDisabledByWindow = true;
  }

  /// Allows wallpaper tinting, unless overridden.
  void allowWallpaperTinting() {
    _isWallpaperTintingDisabledByWindow = false;
  }
}
