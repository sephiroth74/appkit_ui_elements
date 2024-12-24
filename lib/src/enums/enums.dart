import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const _kBezelBorderRadius = 1.0;
const _kRoundedBorderRadius = 6.0;

/// @see https://docs-assets.developer.apple.com/published/accf80df231061eac66e07e5377e0d31/SwiftUI-View-controlSize@2x.png
enum AppKitControlSize {
  mini,
  small,
  regular,
  large,
}

enum AppKitPushButtonType { primary, secondary, destructive }

enum AppKitToggleButtonType { primary, secondary }

enum AppKitSliderStyle {
  continuous,
  discreteFixed,
  discreteFree,
}

enum AppKitSegmentedControlSize { regular, small, mini }

enum AppKitColorPickerMode {
  /// No color panel mode.
  none,

  /// The grayscale-alpha color mode.
  gray,

  /// The red-green-blue color mode.
  rgb,

  /// The cyan-magenta-yellow-black color mode.
  cmyk,

  /// The hue-saturation-brightness color mode.
  hsb,

  /// The custom palette color mode.
  customPalette,

  /// The custom color list mode.
  colorList,

  /// The color wheel mode.
  wheel,

  /// The crayon picker mode.
  crayon,
}

/// Position of the tick marks in a level indicator.
enum AppKitLevelIndicatorTickMarkPosition {
  none,
  above,
  below,
}

/// Style of a level indicator.
enum AppKitLevelIndicatorStyle {
  continuous,
  discrete,
}

enum AppKitItemState {
  on,
  off,
  mixed;

  bool get isOn => this == AppKitItemState.on;
  bool get isOff => this == AppKitItemState.off;
  bool get isMixed => this == AppKitItemState.mixed;
}

enum AppKitMenuEdge {
  auto,
  left,
  right,
  top,
  bottom;

  bool get isLeft => this == AppKitMenuEdge.left;

  Offset getRectPosition(Rect rect) {
    switch (this) {
      case AppKitMenuEdge.left:
        return rect.topLeft;
      case AppKitMenuEdge.right:
        return rect.topRight;
      case AppKitMenuEdge.top:
        return rect.topLeft;
      case AppKitMenuEdge.bottom:
        return rect.bottomLeft;
      default:
        return rect.bottomLeft;
    }
  }
}

enum AppKitPopupButtonStyle {
  push,
  bevel,
  plain,
  inline,
}

enum AppKitPulldownButtonStyle {
  push,
  bevel,
  plain,
  inline,
}

enum AppKitComboBoxStyle {
  bordered,
  plain,
}

enum AppKitOverlayVisibilityMode {
  never,
  editing,
  notEditing,
  always,
}

enum AppKitTextFieldBehavior {
  selectable,
  editable,
  none;

  bool get canRequestFocus => this != AppKitTextFieldBehavior.none;

  bool get readOnly =>
      this == AppKitTextFieldBehavior.selectable ||
      this == AppKitTextFieldBehavior.none;
}

enum AppKitTextFieldBorderStyle {
  none,
  line,
  bezel,
  rounded;

  double getBorderRadius(double? radius) {
    switch (this) {
      case AppKitTextFieldBorderStyle.none:
      case AppKitTextFieldBorderStyle.line:
        return 0.0;
      case AppKitTextFieldBorderStyle.bezel:
        return radius ?? _kBezelBorderRadius;
      case AppKitTextFieldBorderStyle.rounded:
        return radius ?? _kRoundedBorderRadius;
    }
  }
}

enum AppKitColorWellStyle { regular, minimal, expanded }

enum AppKitDatePickerType {
  graphical,
  textualWithStepper,
  textual,
}

enum AppKitDateElements {
  monthDayYear,
  monthYear,
  none;

  DateFormat getDateFormat([String? locale]) {
    switch (this) {
      case AppKitDateElements.monthDayYear:
        return DateFormat.yMd(locale);
      case AppKitDateElements.monthYear:
        return DateFormat.yM(locale);
      case AppKitDateElements.none:
        return DateFormat.yMd(locale);
    }
  }
}

enum AppKitTimeElements {
  hourMinuteSecond,
  hourMinute,
  none;

  DateFormat getDateFormat([String? locale]) {
    switch (this) {
      case AppKitTimeElements.hourMinuteSecond:
        return DateFormat.Hms(locale);
      case AppKitTimeElements.hourMinute:
        return DateFormat.Hm(locale);
      case AppKitTimeElements.none:
        return DateFormat.Hms(locale);
    }
  }
}

enum AppKitDatePickerSelectionType {
  single,
  range,
}

enum AppKitGroupBoxStyle {
  defaultScrollBox,
  roundedScrollBox,
  standardScrollBox,
}

enum AppKitAccentColor {
  blue,
  purple,
  pink,
  red,
  orange,
  yellow,
  green,
  graphite;
}

enum AppKitResizableSide {
  left,
  right,
  top,
}
