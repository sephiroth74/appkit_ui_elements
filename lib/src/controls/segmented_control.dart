import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:macos_ui/macos_ui.dart';

class AppKitSegmentedControl extends StatefulWidget {
  final AppKitSegmentedController controller;
  final List<IconData>? icons;
  final List<String>? labels;
  final ValueChanged<List<int>>? onSelectionChanged;
  final AppKitSegmentedControlSize size;

  const AppKitSegmentedControl({
    super.key,
    required this.controller,
    this.icons,
    this.labels,
    this.onSelectionChanged,
    this.size = AppKitSegmentedControlSize.regular,
  })  : assert(icons != null ? labels == null : labels != null),
        assert(icons == null || icons.length == controller.length),
        assert(labels == null || labels.length == controller.length);

  @override
  State<AppKitSegmentedControl> createState() => _AppKitSegmentedControlState();
}

class _AppKitSegmentedControlState extends State<AppKitSegmentedControl> {
  bool get enabled => widget.onSelectionChanged != null;

  bool get multipleSelection => !widget.controller.isSingle;

  bool get singleSelection => widget.controller.isSingle;

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
    widget.onSelectionChanged!(widget.controller.selectedIndexes);
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
    final AppKitThemeData theme = AppKitTheme.of(context);
    final segmentedControlTheme = AppKitSegmentedControlTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return UiElementColorBuilder(
      builder: (context, colorContainer) {
        final accentColor = theme.accentColor ?? colorContainer.controlAccentColor;
        final backgroundColor =
            multiSelectionStyle ? theme.controlBackgroundColor : AppKitColors.fills.opaque.quinaryInverted;
        final borderRadius = widget.size.getborderRadius(singleSelectionStyle);
        final constraints = widget.size.constraints;
        return Container(
          padding: multiSelectionStyle ? const EdgeInsets.symmetric(vertical: 1) : EdgeInsets.zero,
          constraints: constraints,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius), boxShadow: [
              if (multiSelectionStyle) ...[
                BoxShadow(
                  color: colorContainer.shadowColor.withOpacity(0.35),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 2,
                  spreadRadius: -0.5,
                  offset: const Offset(0, 0.5),
                ),
                BoxShadow(
                  color: colorContainer.shadowColor.withOpacity(0.05),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 0.0,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 0),
                ),
              ] else ...[
                BoxShadow(
                  color: colorContainer.shadowColor.withOpacity(0.125),
                ),
                BoxShadow(
                  color: AppKitColors.fills.opaque.quinary.darkColor.withOpacity(0.475),
                  spreadRadius: -1.0,
                  blurRadius: 1.0,
                ),
              ],
            ]),
            child: SizedBox.expand(child: LayoutBuilder(builder: (context, layoutConstraints) {
              assert(layoutConstraints.hasBoundedWidth);
              final tabSize = (layoutConstraints.maxWidth - (singleSelectionStyle ? 1 : 0)) / widget.controller.length;
              return Padding(
                padding: singleSelectionStyle ? const EdgeInsets.all(0.5) : const EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(widget.controller.length, (index) {
                    final bool isSelected = _isTabSelected(index);
                    final bool isDown = _isTabDown(index);

                    Widget child;

                    if (multiSelectionStyle) {
                      // multiple selection style
                      child = Stack(
                        children: [
                          if (index > 0 && !_isTabSelected(index - 1) && !isSelected) ...[
                            VerticalDivider(
                              indent: (constraints.maxHeight - 12) / 2,
                              endIndent: (constraints.maxHeight - 12) / 2,
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
                                            bottomLeft: Radius.circular(borderRadius))
                                        : index == widget.controller.length - 1
                                            ? BorderRadius.only(
                                                topRight: Radius.circular(borderRadius),
                                                bottomRight: Radius.circular(borderRadius))
                                            : const BorderRadius.all(Radius.zero),
                                  )
                                : const BoxDecoration(),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isDown ? MacosColors.black.withOpacity(0.1) : null,
                                gradient: isDown
                                    ? null
                                    : isSelected
                                        ? LinearGradient(colors: [
                                            MacosColors.white.withOpacity(0.17),
                                            MacosColors.white.withOpacity(0.0),
                                          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                                        : null,
                                borderRadius: (!isDown || !isSelected)
                                    ? null
                                    : index == 0
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(borderRadius),
                                            bottomLeft: Radius.circular(borderRadius))
                                        : index == widget.controller.length - 1
                                            ? BorderRadius.only(
                                                topRight: Radius.circular(borderRadius),
                                                bottomRight: Radius.circular(borderRadius))
                                            : const BorderRadius.all(Radius.zero),
                              ),
                              child: Center(
                                  child: widget.icons != null
                                      ? Icon(widget.icons![index],
                                          size: widget.size.iconSize,
                                          color: isSelected
                                              ? AppKitColors.text.opaque.primary.darkColor
                                              : AppKitColors.text.opaque.primary)
                                      : Padding(
                                          padding: const EdgeInsets.only(bottom: 2.0),
                                          child: Text(
                                            widget.labels![index],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: widget.size.textSize,
                                                color: isSelected
                                                    ? AppKitColors.text.opaque.primary.darkColor
                                                    : AppKitColors.text.opaque.primary),
                                          ),
                                        )),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // single selection style
                      child = Stack(
                        children: [
                          if (index > 0 &&
                              !_isTabSelected(index - 1) &&
                              !_isTabDown(index - 1) &&
                              !_isTabDown(index) &&
                              !isSelected) ...[
                            VerticalDivider(
                              indent: (constraints.maxHeight - 13) / 2,
                              endIndent: (constraints.maxHeight - 13) / 2,
                              width: 1,
                              color: segmentedControlTheme.dividerColorSingleSelection,
                              thickness: 1,
                            ),
                          ],
                          SizedBox.expand(
                            child: DecoratedBox(
                              decoration: isSelected || isDown
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(borderRadius),
                                      border: GradientBoxBorder(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.225),
                                              Colors.black.withOpacity(0.35),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          width: 0.5),
                                      color: Colors.white,
                                      boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 0.25,
                                            spreadRadius: 0.0,
                                            offset: const Offset(0, 0.25),
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 0.75,
                                            spreadRadius: 0.0,
                                            offset: const Offset(0, 0.5),
                                          ),
                                        ])
                                  : const BoxDecoration(),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: isDown ? MacosColors.black.withOpacity(0.035) : null,
                                  borderRadius: (!isDown || !isSelected) ? null : BorderRadius.circular(borderRadius),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      widget.labels![index],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: widget.size.textSize, color: AppKitColors.text.opaque.primary),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
            })),
          ),
        );
      },
    );
  }
}

abstract class AppKitSegmentedController extends ChangeNotifier {
  final int length;

  AppKitSegmentedController({required this.length}) : assert(length > 0);

  bool isSelected(int index);

  void toggleIndex(int index);

  List<int> get selectedIndexes;

  bool get isSingle;

  static SegmentedControllerSingle single({int initialSelection = 0, required int length}) {
    return SegmentedControllerSingle(initialIndex: initialSelection, length: length);
  }

  static SegmentedControllerMultiple multiple({Set<int>? initialSelection, required int length}) {
    return SegmentedControllerMultiple(initialSelection: initialSelection, length: length);
  }
}

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
  List<int> get selectedIndexes => [_index];

  @override
  bool get isSingle => true;
}

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
  bool isSelected(int index) {
    return _selectedIndexes.contains(index);
  }

  @override
  bool get isSingle => false;

  @override
  List<int> get selectedIndexes {
    return _selectedIndexes.toList();
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

  double getborderRadius(bool single) {
    return single ? 6.0 : 5.0;
  }

  double get textSize {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return 10;
      case AppKitSegmentedControlSize.small:
        return 11;
      case AppKitSegmentedControlSize.regular:
        return 13;
    }
  }

  double get iconSize {
    switch (this) {
      case AppKitSegmentedControlSize.mini:
        return 10;
      case AppKitSegmentedControlSize.small:
        return 13;
      case AppKitSegmentedControlSize.regular:
        return 16;
    }
  }
}
