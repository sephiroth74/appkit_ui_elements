import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

class AppKitSegmentedControl extends StatefulWidget {
  /// A controller for the segmented control.
  ///
  /// This is used to manage the state and behavior of the segmented control.
  final AppKitSegmentedController controller;

  /// A list of icons to be displayed in the segmented control.
  ///
  /// This can be null if no icons are needed.
  final List<IconData>? icons;

  /// A list of labels to be displayed in the segmented control.
  ///
  /// This can be null if no labels are needed.
  final List<String>? labels;

  /// A callback function that is triggered when the selection changes.
  ///
  /// The function takes two parameters:
  /// - A set of integers representing the selected indices.
  /// - An integer representing the index of the segment that was changed.
  final Function(Set<int>, int)? onSelectionChanged;

  /// The size of the segmented control.
  ///
  /// This determines the overall size of the control.
  final AppKitSegmentedControlSize size;

  /// The color of the segmented control.
  ///
  /// This can be null if the default color is to be used.
  final Color? color;

  /// Creates an instance of [AppKitSegmentedControl].
  ///
  /// This constructor initializes the segmented control with the provided parameters.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// AppKitSegmentedControl(
  ///   controller: AppKitSegmentedController.single(length: 3),
  /// );
  /// ```
  ///
  /// You can customize the segmented control by passing the appropriate parameters.
  ///
  /// See also:
  ///
  ///  * [AppKitTabView], which is used to display the content of the selected tab.
  const AppKitSegmentedControl({
    super.key,
    required this.controller,
    this.icons,
    this.labels,
    this.color,
    this.onSelectionChanged,
    this.size = AppKitSegmentedControlSize.regular,
  }) : assert(icons != null ? labels == null : labels != null),
       assert(icons == null || icons.length == controller.length),
       assert(labels == null || labels.length == controller.length);

  @override
  State<AppKitSegmentedControl> createState() => _AppKitSegmentedControlState();
}

class _AppKitSegmentedControlState extends State<AppKitSegmentedControl> {
  bool get enabled => widget.onSelectionChanged != null;

  bool get singleSelection => widget.controller.isSingle;

  bool get multipleSelection => !singleSelection;

  bool get multiSelectionStyle => multipleSelection || widget.icons != null;

  bool get singleSelectionStyle => singleSelection && widget.labels != null;

  int? _buttonDownIndex;

  bool _isTabSelected(int index) {
    return widget.controller.isSelected(index);
  }

  bool _isTabDown(int index) {
    return _buttonDownIndex == index;
  }

  void _handleTap(int index) {
    widget.controller.toggleIndex(index);
    widget.onSelectionChanged!(widget.controller.selectedIndexes, index);
  }

  void _handleTapDown(int index) {
    setState(() {
      _buttonDownIndex = index;
    });
  }

  void _handleTapUp(int index) {
    setState(() {
      _buttonDownIndex = null;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _buttonDownIndex = null;
    });
  }

  void _handleControllerChange() {
    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('controller', widget.controller));
    properties.add(ObjectFlagProperty('onSelectionChanged', widget.onSelectionChanged, ifNull: 'disabled'));
    properties.add(IterableProperty('icons', widget.icons, defaultValue: null));
    properties.add(IterableProperty('labels', widget.labels, defaultValue: null));
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handleControllerChange);
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Consumer<MainWindowModel>(
      builder: (context, model, _) {
        final isMainWindow = model.isMainWindow;
        final AppKitThemeData theme = AppKitTheme.of(context);
        final segmentedControlTheme = AppKitSegmentedControlTheme.of(context);
        final accentColor = widget.color ?? segmentedControlTheme.accentColor ?? theme.activeColor;
        final isDark = theme.brightness == Brightness.dark;

        final backgroundColor = multiSelectionStyle ? theme.controlColor : AppKitColors.fills.opaque.quinaryInverted;

        final borderRadius = widget.size.getborderRadius(singleSelectionStyle);
        final constraints = widget.size.constraints;
        return Container(
          padding: multiSelectionStyle ? const EdgeInsets.symmetric(vertical: 1) : EdgeInsets.zero,
          constraints: constraints,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: isDark && singleSelectionStyle
                  ? GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: [
                          AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.tertiary).multiplyOpacity(0.35),
                          AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.primary).multiplyOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.5],
                      ),
                      width: 0.5,
                    )
                  : null,
              boxShadow: [
                if (multiSelectionStyle) ...[
                  BoxShadow(
                    color: AppKitColors.shadowColor.withValues(alpha: 0.35),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 2,
                    spreadRadius: -0.5,
                    offset: const Offset(0, 0.5),
                  ),
                  BoxShadow(
                    color: AppKitColors.shadowColor.withValues(alpha: 0.05),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 0.0,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 0),
                  ),
                ] else ...[
                  BoxShadow(color: AppKitColors.shadowColor.withValues(alpha: 0.125)),
                  BoxShadow(
                    color: (isDark
                        ? theme.controlColor.withLuminance(0.35).withValues(alpha: 0.475)
                        : backgroundColor.withValues(alpha: 0.5)),
                    spreadRadius: -0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, 0.15),
                  ),
                ],
                if (isDark) ...[
                  BoxShadow(
                    color: AppKitColors.shadowColor.withValues(alpha: 0.15),
                    blurRadius: 0.5,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                    offset: const Offset(0, 0.0),
                  ),
                ],
              ],
            ),
            child: SizedBox.expand(
              child: LayoutBuilder(
                builder: (context, layoutConstraints) {
                  assert(layoutConstraints.hasBoundedWidth);
                  final tabSize =
                      (layoutConstraints.maxWidth - (singleSelectionStyle ? 1 : 0)) / widget.controller.length;
                  return Padding(
                    padding: singleSelectionStyle ? const EdgeInsets.all(0.5) : const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(widget.controller.length, (index) {
                        final bool isSelected = _isTabSelected(index);
                        final bool isDown = _isTabDown(index);

                        Widget? child;

                        if (multiSelectionStyle) {
                          // multiple selection style
                          child = _MultipleSegmentedChild(
                            isSelected: isSelected,
                            isDown: isDown,
                            index: index,
                            constraints: constraints,
                            size: widget.size,
                            labels: widget.labels,
                            icons: widget.icons,
                            segmentedControlTheme: segmentedControlTheme,
                            borderRadius: borderRadius,
                            accentColor: accentColor,
                            controller: widget.controller,
                            isDark: isDark,
                            isMainWindow: isMainWindow,
                            isTabSelected: _isTabSelected,
                          );
                        } else {
                          // single selection style
                          child = _SingleSegmentedChild(
                            isSelected: isSelected,
                            isDown: isDown,
                            index: index,
                            constraints: constraints,
                            size: widget.size,
                            theme: theme,
                            segmentedControlTheme: segmentedControlTheme,
                            borderRadius: borderRadius,
                            labels: widget.labels!,
                            isDark: isDark,
                            isMainWindow: isMainWindow,
                            isTabSelected: _isTabSelected,
                            isTabDown: _isTabDown,
                          );
                        }

                        return MouseRegion(
                          hitTestBehavior: HitTestBehavior.opaque,
                          onExit: (_) => _handleTapCancel(),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: enabled ? (_) => _handleTapDown(index) : null,
                            onTapUp: enabled ? (_) => _handleTapUp(index) : null,
                            onTap: enabled ? () => _handleTap(index) : null,
                            child: SizedBox(width: tabSize, height: layoutConstraints.maxHeight, child: child),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MultipleSegmentedChild extends StatelessWidget {
  final bool isSelected;
  final bool isDown;
  final int index;
  final BoxConstraints constraints;
  final AppKitSegmentedControlSize size;
  final AppKitSegmentedControlThemeData segmentedControlTheme;
  final double borderRadius;
  final List<String>? labels;
  final List<IconData>? icons;
  final Color accentColor;
  final AppKitSegmentedController controller;
  final bool isDark;
  final bool isMainWindow;
  final bool Function(int index) isTabSelected;

  const _MultipleSegmentedChild({
    required this.isSelected,
    required this.isDown,
    required this.index,
    required this.constraints,
    required this.size,
    required this.segmentedControlTheme,
    required this.borderRadius,
    required this.accentColor,
    required this.controller,
    required this.isTabSelected,
    this.isDark = false,
    this.isMainWindow = true,
    this.labels,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final dividerIndent = size.dividerIndent;
    final double accentColorLuminance = accentColor.computeLuminance();
    return Stack(
      children: [
        if (index > 0 && !isTabSelected(index - 1) && !isSelected) ...[
          VerticalDivider(
            indent: dividerIndent,
            endIndent: dividerIndent,
            width: 1,
            color: segmentedControlTheme.dividerColorMultipleSelection,
            thickness: 1,
          ),
        ],
        DecoratedBox(
          decoration: isSelected
              ? BoxDecoration(
                  color: accentColor,
                  borderRadius: index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          bottomLeft: Radius.circular(borderRadius),
                        )
                      : index == controller.length - 1
                      ? BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        )
                      : const BorderRadius.all(Radius.zero),
                )
              : const BoxDecoration(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDown
                  ? isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)
                  : null,
              gradient: isDown
                  ? null
                  : isSelected
                  ? LinearGradient(
                      colors: [Colors.white.withValues(alpha: 0.17), Colors.white.withValues(alpha: 0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.75],
                    )
                  : null,
              borderRadius: (!isDown || !isSelected)
                  ? null
                  : index == 0
                  ? BorderRadius.only(topLeft: Radius.circular(borderRadius), bottomLeft: Radius.circular(borderRadius))
                  : index == controller.length - 1
                  ? BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    )
                  : const BorderRadius.all(Radius.zero),
            ),
            child: Center(
              child: icons != null
                  ? Icon(
                      icons![index],
                      size: size.iconSize,
                      color: isSelected
                          ? (accentColorLuminance > 0.5
                                ? AppKitColors.text.opaque.primary.color
                                : AppKitColors.text.opaque.primary.darkColor)
                          : isDark
                          ? AppKitColors.text.opaque.primary.darkColor
                          : AppKitColors.text.opaque.primary.color,
                    )
                  : Padding(
                      padding: size.getLabelPaddings(false),
                      child: Text(
                        labels![index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.textSize,
                          color: isSelected
                              ? (accentColorLuminance > 0.5
                                    ? AppKitColors.text.opaque.primary.color
                                    : AppKitColors.text.opaque.primary.darkColor)
                              : isDark
                              ? AppKitColors.text.opaque.primary.darkColor
                              : AppKitColors.text.opaque.primary.color,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SingleSegmentedChild extends StatelessWidget {
  final bool isSelected;
  final bool isDown;
  final int index;
  final BoxConstraints constraints;
  final AppKitSegmentedControlSize size;
  final AppKitThemeData theme;
  final AppKitSegmentedControlThemeData segmentedControlTheme;
  final double borderRadius;
  final List<String> labels;
  final bool isDark;
  final bool isMainWindow;
  final bool Function(int index) isTabSelected;
  final bool Function(int index) isTabDown;

  const _SingleSegmentedChild({
    required this.isSelected,
    required this.isDown,
    required this.index,
    required this.constraints,
    required this.size,
    required this.theme,
    required this.segmentedControlTheme,
    required this.borderRadius,
    required this.labels,
    this.isDark = false,
    this.isMainWindow = true,
    required this.isTabSelected,
    required this.isTabDown,
  });

  @override
  Widget build(BuildContext context) {
    final dividerIndent = size.dividerIndent;
    return Stack(
      children: [
        if (index > 0 && !isTabSelected(index - 1) && !isTabDown(index - 1) && !isTabDown(index) && !isSelected) ...[
          VerticalDivider(
            indent: dividerIndent,
            endIndent: dividerIndent,
            width: 1,
            color: segmentedControlTheme.dividerColorSingleSelection,
            thickness: 1,
          ),
        ],
        SizedBox.expand(
          child: DecoratedBox(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppKitDynamicColor.resolve(
                                  context,
                                  AppKitColors.text.opaque.primary,
                                ).multiplyOpacity(0.5),
                                AppKitDynamicColor.resolve(
                                  context,
                                  AppKitColors.text.opaque.quaternary,
                                ).multiplyOpacity(0.0),
                              ]
                            : [
                                AppKitDynamicColor.resolve(
                                  context,
                                  AppKitColors.text.opaque.tertiary,
                                ).multiplyOpacity(0.6),
                                AppKitDynamicColor.resolve(
                                  context,
                                  AppKitColors.text.opaque.secondary,
                                ).multiplyOpacity(0.6),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                      ),
                      width: 0.5,
                    ),
                    color: segmentedControlTheme.singleSelectionColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppKitColors.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 0.25,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 0.25),
                      ),
                      BoxShadow(
                        color: AppKitColors.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 0.75,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  )
                : const BoxDecoration(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDown
                    ? isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.035)
                    : null,
                borderRadius: (!isDown || !isSelected) ? null : BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Padding(
                  padding: size.getLabelPaddings(true),
                  child: Text(
                    labels[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: size.textSize,
                      color: AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.primary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// An abstract class that extends [ChangeNotifier] to provide
/// a base implementation for segmented controls in the AppKit UI.
///
/// This class should be extended to create custom segmented controls
/// with specific behavior and appearance.
///
/// Classes that extend [AppKitSegmentedController] should implement
/// the necessary methods and properties to manage the state and
/// interaction of the segmented control.
abstract class AppKitSegmentedController extends ChangeNotifier {
  final int length;

  /// A controller for managing the state of an AppKit segmented control.
  ///
  /// The [AppKitSegmentedController] class provides methods to manage the
  /// selection state of a segmented control, including checking if a segment
  /// is selected, toggling the selection state of a segment, and setting
  /// multiple selected indexes.
  ///
  /// The [length] parameter must be greater than 0.
  ///
  /// Properties:
  /// - `length`: The number of segments in the control.
  /// - `selectedIndexes`: A set of indexes representing the currently selected segments.
  /// - `isSingle`: A boolean indicating if only a single segment can be selected.
  ///
  /// Methods:
  /// - `isSelected(int index)`: Returns `true` if the segment at the given index is selected.
  /// - `toggleIndex(int index)`: Toggles the selection state of the segment at the given index.
  /// - `setSelectedIndexes(Set<int> indexes)`: Sets the selected segments to the given indexes.
  AppKitSegmentedController({required this.length}) : assert(length > 0);

  /// Checks if the item at the given index is selected.
  ///
  /// Returns `true` if the item is selected, otherwise `false`.
  ///
  /// - Parameter index: The index of the item to check.
  bool isSelected(int index);

  /// Toggles the selection state of the item at the given index.
  ///
  /// - Parameter index: The index of the item to toggle.
  void toggleIndex(int index);

  /// Sets the selected indexes to the provided set of indexes.
  ///
  /// - Parameter indexes: A set of indexes to be selected.
  void setSelectedIndexes(Set<int> indexes);

  /// Gets the set of currently selected indexes.
  ///
  /// Returns a set of integers representing the selected indexes.
  Set<int> get selectedIndexes;

  /// Checks if the control allows only a single selection.
  ///
  /// Returns `true` if only a single selection is allowed, otherwise `false`.
  bool get isSingle;

  /// Creates a single selection segmented controller.
  ///
  /// This factory constructor returns an instance of [SegmentedControllerSingle]
  /// which allows only one segment to be selected at a time.
  static SegmentedControllerSingle single({int initialSelection = 0, required int length}) {
    return SegmentedControllerSingle(initialIndex: initialSelection, length: length);
  }

  /// Creates a [SegmentedControllerMultiple] instance.
  ///
  /// This factory constructor is used to create a segmented controller
  /// that allows multiple selections.
  static SegmentedControllerMultiple multiple({Set<int>? initialSelection, required int length}) {
    return SegmentedControllerMultiple(initialSelection: initialSelection, length: length);
  }
}

/// A controller for managing a single selection in an AppKit segmented control.
///
/// This class extends the [AppKitSegmentedController] to provide functionality
/// specific to single selection segmented controls.
class SegmentedControllerSingle extends AppKitSegmentedController {
  SegmentedControllerSingle({int initialIndex = 0, required super.length})
    : _index = initialIndex,
      _previousIndex = initialIndex,
      assert(initialIndex >= 0 && initialIndex < length);

  void setIndex(int index) {
    assert(index >= 0 && index < length);
    if (index != _index) {
      _previousIndex = _index;
      _index = index;
      notifyListeners();
    }
  }

  set index(int index) {
    setIndex(index);
  }

  int get count => length;

  void next() {
    setIndex((_index + 1) % length);
  }

  void previous() {
    setIndex((_index - 1) % length);
  }

  @override
  void setSelectedIndexes(Set<int> indexes) {
    assert(indexes.length == 1);
    setIndex(indexes.first);
  }

  int get index => _index;

  int get previousIndex => _previousIndex;

  int _previousIndex = 0;

  int _index = 0;

  @override
  bool isSelected(int index) {
    return _index == index;
  }

  @override
  void toggleIndex(int index) {
    setIndex(index);
  }

  @override
  Set<int> get selectedIndexes {
    return <int>{_index};
  }

  @override
  bool get isSingle => true;
}

/// A controller for managing multiple segments in an AppKit segmented control.
///
/// This class extends the [AppKitSegmentedController] to provide functionality
/// for handling multiple segments within a segmented control. It allows for
/// the selection and management of multiple segments, providing a more
/// flexible and customizable user interface component.
class SegmentedControllerMultiple extends AppKitSegmentedController {
  final Set<int> _selectedIndexes;

  SegmentedControllerMultiple({Set<int>? initialSelection, required super.length})
    : _selectedIndexes = initialSelection ?? <int>{},
      assert(initialSelection == null || initialSelection.length <= length);

  @override
  void toggleIndex(int index) {
    assert(index >= 0 && index < length);
    _selectedIndexes.contains(index) ? _selectedIndexes.remove(index) : _selectedIndexes.add(index);
    notifyListeners();
  }

  void selectIndex(int index) {
    assert(index >= 0 && index < length);
    if (_selectedIndexes.contains(index)) return;
    _selectedIndexes.add(index);
    notifyListeners();
  }

  void deselectIndex(int index) {
    assert(index >= 0 && index < length);
    if (_selectedIndexes.contains(index)) return;
    _selectedIndexes.remove(index);
    notifyListeners();
  }

  @override
  void setSelectedIndexes(Set<int> indexes) {
    assert(indexes.length <= length);
    _selectedIndexes.clear();
    _selectedIndexes.addAll(indexes);
    notifyListeners();
  }

  @override
  bool isSelected(int index) {
    return _selectedIndexes.contains(index);
  }

  @override
  bool get isSingle => false;

  @override
  Set<int> get selectedIndexes {
    final sorted = _selectedIndexes.toList()..sort();
    return <int>{}..addAll(sorted);
  }
}

extension ControlSizeX on AppKitSegmentedControlSize {
  BoxConstraints get constraints {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return const BoxConstraints(minHeight: 14, maxHeight: 14, minWidth: 100);
      case AppKitSegmentedControlSize.small:
        return const BoxConstraints(minHeight: 18, maxHeight: 18, minWidth: 100);
      case AppKitSegmentedControlSize.regular:
        return const BoxConstraints(minHeight: 22, maxHeight: 22, minWidth: 100);
    }
  }

  double get dividerIndent {
    return constraints.maxHeight / 4.8888888889;
  }

  EdgeInsets getLabelPaddings(bool single) {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return single
            ? const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 0.5)
            : const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 0.5);
      case AppKitSegmentedControlSize.small:
        return single
            ? const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 1.5)
            : const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 1.5);
      case AppKitSegmentedControlSize.regular:
        return single
            ? const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 3.0)
            : const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 2.0);
    }
  }

  double getborderRadius(bool single) {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return single ? 4.5 : 3.5;
      case AppKitSegmentedControlSize.small:
        return single ? 5.0 : 4.0;
      case AppKitSegmentedControlSize.regular:
        return single ? 6.0 : 5.0;
    }
  }

  double get textSize {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return 8.5;
      case AppKitSegmentedControlSize.small:
        return 11;
      case AppKitSegmentedControlSize.regular:
        return 13;
    }
  }

  double get iconSize {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return 9;
      case AppKitSegmentedControlSize.small:
        return 12;
      case AppKitSegmentedControlSize.regular:
        return 16;
    }
  }
}
