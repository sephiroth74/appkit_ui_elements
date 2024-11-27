import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

const _kDefaultFontFamily = '.AppleSystemUIFont';

/// https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/typography
/// https://www.figma.com/design/IX6ph2VWrJiRoMTI1Byz0K/Apple-Design-Resources---macOS-(Community)?node-id=0-1745&node-type=frame&t=xFExY8cQrcYvWzzF-0
class AppKitTypography extends Equatable with Diagnosticable {
  factory AppKitTypography({
    required Color color,
    TextStyle? largeTitle,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? headline,
    TextStyle? subheadline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? tooltip,
    TextStyle? footnote,
    TextStyle? caption1,
    TextStyle? caption2,
  }) {
    largeTitle ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 26,
      letterSpacing: 0.22,
      color: color,
    );
    title1 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 22,
      letterSpacing: -0.26,
      color: color,
    );
    title2 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 17,
      letterSpacing: -0.43,
      color: color,
    );
    title3 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: -0.23,
      color: color,
    );
    headline ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 13,
      letterSpacing: -0.08,
      color: color,
    );
    body ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      letterSpacing: 0.06,
      color: color,
    );
    callout ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: color,
    );
    tooltip ??= const TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      color: Color(0xFF4D4D4D),
    );
    subheadline ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 11,
      letterSpacing: 0.06,
      color: color,
    );
    footnote ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    caption1 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    caption2 ??= TextStyle(
      fontFamily: _kDefaultFontFamily,
      fontWeight: AppKitFontWeight.w510,
      fontSize: 10,
      letterSpacing: 0.12,
      color: color,
    );
    return AppKitTypography.raw(
      largeTitle: largeTitle,
      title1: title1,
      title2: title2,
      title3: title3,
      headline: headline,
      subheadline: subheadline,
      body: body,
      callout: callout,
      tooltip: tooltip,
      footnote: footnote,
      caption1: caption1,
      caption2: caption2,
    );
  }

  factory AppKitTypography.fromMacosTypograhpy(MacosTypography from) {
    return AppKitTypography(
      color: from.largeTitle.color!,
      largeTitle: from.largeTitle,
      title1: from.title1,
      title2: from.title2,
      title3: from.title3,
      headline: from.headline,
      subheadline: from.subheadline,
      body: from.body,
      callout: from.callout,
      tooltip:
          from.callout.copyWith(color: const Color(0xFF4D4D4D), fontSize: 13.0),
      footnote: from.footnote,
      caption1: from.caption1,
      caption2: from.caption2,
    );
  }

  const AppKitTypography.raw({
    required this.largeTitle,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.headline,
    required this.subheadline,
    required this.body,
    required this.callout,
    required this.tooltip,
    required this.footnote,
    required this.caption1,
    required this.caption2,
  });

  factory AppKitTypography.darkOpaque() =>
      AppKitTypography(color: AppKitColors.labelColor.color);
  factory AppKitTypography.lightOpaque() =>
      AppKitTypography(color: AppKitColors.labelColor.darkColor);

  /// Style used for body text.
  final TextStyle body;

  /// Style used for callouts.
  final TextStyle callout;

  final TextStyle tooltip;

  /// Style used for standard captions.
  final TextStyle caption1;

  /// Style used for alternate captions.
  final TextStyle caption2;

  /// Style used in footnotes
  final TextStyle footnote;

  /// Style used for headings.
  final TextStyle headline;

  /// Style used for large titles.
  final TextStyle largeTitle;

  /// Style used for subheadings.
  final TextStyle subheadline;

  /// Style used for first-level hierarchical headings.
  final TextStyle title1;

  /// Style used for second-level hierarchical headings.
  final TextStyle title2;

  /// Style used for third-level hierarchical headings.
  final TextStyle title3;

  AppKitTypography merge(AppKitTypography? other) {
    if (other == null) return this;
    return AppKitTypography.raw(
      largeTitle: largeTitle.merge(other.largeTitle),
      title1: title1.merge(other.title1),
      title2: title2.merge(other.title2),
      title3: title3.merge(other.title3),
      headline: headline.merge(other.headline),
      subheadline: subheadline.merge(other.subheadline),
      body: body.merge(other.body),
      callout: callout.merge(other.callout),
      tooltip: tooltip.merge(other.tooltip),
      footnote: callout.merge(other.footnote),
      caption1: caption1.merge(other.caption1),
      caption2: caption2.merge(other.caption2),
    );
  }

  /// Linearly interpolate between two typographies.
  static AppKitTypography lerp(
      AppKitTypography a, AppKitTypography b, double t) {
    return AppKitTypography.raw(
      largeTitle: TextStyle.lerp(a.largeTitle, b.largeTitle, t)!,
      title1: TextStyle.lerp(a.title1, b.title1, t)!,
      title2: TextStyle.lerp(a.title2, b.title2, t)!,
      title3: TextStyle.lerp(a.title3, b.title3, t)!,
      headline: TextStyle.lerp(a.headline, b.headline, t)!,
      subheadline: TextStyle.lerp(a.subheadline, b.subheadline, t)!,
      body: TextStyle.lerp(a.body, b.body, t)!,
      callout: TextStyle.lerp(a.callout, b.callout, t)!,
      tooltip: TextStyle.lerp(a.tooltip, b.tooltip, t)!,
      footnote: TextStyle.lerp(a.footnote, b.footnote, t)!,
      caption1: TextStyle.lerp(a.caption1, b.caption1, t)!,
      caption2: TextStyle.lerp(a.caption2, b.caption2, t)!,
    );
  }

  static AppKitTypography of(BuildContext context) {
    final theme = AppKitTheme.of(context);
    return theme.typography;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final defaultStyle = AppKitTypography.darkOpaque();
    properties.add(DiagnosticsProperty<TextStyle>(
      'largeTitle',
      largeTitle,
      defaultValue: defaultStyle.largeTitle,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title1',
      title1,
      defaultValue: defaultStyle.title1,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title2',
      title2,
      defaultValue: defaultStyle.title2,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'title3',
      title3,
      defaultValue: defaultStyle.title3,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'headline',
      headline,
      defaultValue: defaultStyle.headline,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'subheadline',
      subheadline,
      defaultValue: defaultStyle.subheadline,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'body',
      body,
      defaultValue: defaultStyle.body,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'callout',
      callout,
      defaultValue: defaultStyle.callout,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'tooltip',
      tooltip,
      defaultValue: defaultStyle.tooltip,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'footnote',
      footnote,
      defaultValue: defaultStyle.footnote,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'caption1',
      caption1,
      defaultValue: defaultStyle.caption1,
    ));
    properties.add(DiagnosticsProperty<TextStyle>(
      'caption2',
      caption2,
      defaultValue: defaultStyle.caption2,
    ));
  }

  @override
  List<Object?> get props => [
        body,
        callout,
        tooltip,
        caption1,
        caption2,
        footnote,
        headline,
        largeTitle,
        subheadline,
        title1,
        title2,
        title3,
      ];
}

/// The thickness of the glyphs used to draw the text.
///
/// Implements [FontWeight] in order to provide the following custom weight
/// values that Apple use in some of their text styles:
/// * [w510]
/// * [w590]
/// * [w860]
///
/// Reference:
/// * [macOS Sonoma Figma Kit](https://www.figma.com/file/IX6ph2VWrJiRoMTI1Byz0K/Apple-Design-Resources---macOS-(Community)?node-id=0%3A1745&mode=dev)
class AppKitFontWeight implements FontWeight {
  const AppKitFontWeight._(this.index, this.value);

  /// The encoded integer value of this font weight.
  @override
  final int index;

  /// The thickness value of this font weight.
  @override
  final int value;

  /// Thin, the least thick
  static const AppKitFontWeight w100 = AppKitFontWeight._(0, 100);

  /// Extra-light
  static const AppKitFontWeight w200 = AppKitFontWeight._(1, 200);

  /// Light
  static const AppKitFontWeight w300 = AppKitFontWeight._(2, 300);

  /// Normal / regular / plain
  static const AppKitFontWeight w400 = AppKitFontWeight._(3, 400);

  /// Medium
  static const AppKitFontWeight w500 = AppKitFontWeight._(4, 500);

  /// An Apple-specific font weight.
  ///
  /// When [AppKitTypography.caption1] needs to be bolded, use this value.
  static const AppKitFontWeight w510 = AppKitFontWeight._(5, 510);

  /// An Apple-specific font weight.
  ///
  /// When [AppKitTypography.body], [AppKitTypography.callout],
  /// [AppKitTypography.subheadline], [AppKitTypography.footnote], or
  /// [AppKitTypography.caption2] need to be bolded, use this value.
  static const AppKitFontWeight w590 = AppKitFontWeight._(6, 590);

  /// Semi-bold
  static const AppKitFontWeight w600 = AppKitFontWeight._(7, 600);

  /// Bold
  static const AppKitFontWeight w700 = AppKitFontWeight._(8, 700);

  /// Extra-bold
  static const AppKitFontWeight w800 = AppKitFontWeight._(9, 800);

  /// An Apple-specific font weight.
  ///
  /// When [AppKitTypography.title3] needs to be bolded, use this value.
  static const AppKitFontWeight w860 = AppKitFontWeight._(10, 860);

  /// Black, the most thick
  static const AppKitFontWeight w900 = AppKitFontWeight._(11, 900);

  /// The default font weight.
  static const AppKitFontWeight normal = w400;

  /// A commonly used font weight that is heavier than normal.
  static const AppKitFontWeight bold = w700;

  /// A list of all the font weights.
  static const List<AppKitFontWeight> values = <AppKitFontWeight>[
    w100,
    w200,
    w300,
    w400,
    w500,
    w510,
    w590,
    w600,
    w700,
    w800,
    w860,
    w900,
  ];

  static AppKitFontWeight? lerp(
    AppKitFontWeight? a,
    AppKitFontWeight? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return values[_lerpInt((a ?? normal).index, (b ?? normal).index, t)
        .round()
        .clamp(0, 8)];
  }

  @override
  String toString() {
    return const <int, String>{
      0: 'AppKitFontWeight.w100',
      1: 'AppKitFontWeight.w200',
      2: 'AppKitFontWeight.w300',
      3: 'AppKitFontWeight.w400',
      4: 'AppKitFontWeight.w500',
      5: 'AppKitFontWeight.w510',
      6: 'AppKitFontWeight.w590',
      7: 'AppKitFontWeight.w600',
      8: 'AppKitFontWeight.w700',
      9: 'AppKitFontWeight.w800',
      10: 'AppKitFontWeight.w860',
      11: 'AppKitFontWeight.w900',
    }[index]!;
  }
}

double _lerpInt(int a, int b, double t) {
  return a + (b - a) * t;
}
