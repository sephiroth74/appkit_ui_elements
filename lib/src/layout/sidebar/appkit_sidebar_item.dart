import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppKitSidebarItem with Diagnosticable {
  const AppKitSidebarItem({
    this.leading,
    required this.label,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
    this.focusNode,
    this.semanticLabel,
    this.disclosureItems,
    this.expandDisclosureItems = false,
    this.trailing,
  });

  /// The widget before [label].
  ///
  /// Typically an [Icon]
  final Widget? leading;

  /// Indicates what content this widget represents.
  ///
  /// Typically a [Text]
  final Widget label;

  /// The color to paint this widget as when selected.
  ///
  /// If null, [MacosThemeData.primaryColor] is used.
  final Color? selectedColor;

  /// The color to paint this widget as when unselected.
  ///
  /// Defaults to transparent.
  final Color? unselectedColor;

  /// The [shape] property specifies the outline (border) of the
  /// decoration. The shape must not be null. It's used alongside
  /// [selectedColor].
  final ShapeBorder? shape;

  /// The focus node used by this item.
  final FocusNode? focusNode;

  /// The semantic label used by screen readers.
  final String? semanticLabel;

  /// The disclosure items. If null, there will be no disclosure items.
  ///
  /// If non-null and [leading] is null, a local animated icon is created
  final List<AppKitSidebarItem>? disclosureItems;

  /// If true, the disclosure items will be expanded otherwise collapsed.
  ///
  /// Defaults to false. There is no impact if [disclosureItems] is null.
  final bool expandDisclosureItems;

  /// An optional trailing widget.
  ///
  /// Typically a text indicator of a count of items, like in this
  /// screenshots from the Apple Notes app:
  /// <img src="https://imgur.com/REpW9f9.png" height="88" width="219" />
  final Widget? trailing;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ColorProperty('unselectedColor', unselectedColor));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(IterableProperty<AppKitSidebarItem>(
      'disclosure items',
      disclosureItems,
    ));
    properties.add(
        FlagProperty('expandDisclosureItems', value: expandDisclosureItems));
    properties.add(DiagnosticsProperty<Widget?>('trailing', trailing));
  }
}
