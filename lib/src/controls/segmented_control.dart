import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AppKitSegmentedControl extends StatefulWidget {
  final AppKitSegmentedControlStyle style;
  final SegmentedController controller;
  final List<Widget> children;
  final List<IconData>? icons;
  final List<String>? labels;
  final ValueChanged<List<int>>? onSelectionChanged;

  const AppKitSegmentedControl({
    super.key,
    required this.style,
    required this.controller,
    required this.children,
    this.icons,
    this.labels,
    this.onSelectionChanged,
  })  : assert(children.length == controller.length),
        assert(style == AppKitSegmentedControlStyle.single
            ? controller is SegmentedControllerSingle
            : controller is SegmentedControllerMultiple),
        assert(icons != null ? labels == null : labels != null),
        assert(icons == null || icons.length == controller.length),
        assert(labels == null || labels.length == controller.length);

  @override
  State<AppKitSegmentedControl> createState() => _AppKitSegmentedControlState();
}

class _AppKitSegmentedControlState extends State<AppKitSegmentedControl> {
  bool get enabled => widget.onSelectionChanged != null;

  bool get multipleSelection => widget.style == AppKitSegmentedControlStyle.multiple;

  bool get singleSelection => widget.style == AppKitSegmentedControlStyle.single;

  final Set<int> _buttonDownIndexes = <int>{};

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('style', widget.style));
    properties.add(DiagnosticsProperty('controller', widget.controller));
    properties.add(IterableProperty('children', widget.children));
    properties.add(ObjectFlagProperty('onSelectionChanged', widget.onSelectionChanged, ifNull: 'disabled'));
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final AppKitThemeData theme = AppKitTheme.of(context);
    final controller = widget.controller as SegmentedControllerMultiple;
    return UiElementColorBuilder(
      builder: (context, colorContainer) {
        final accentColor = theme.accentColor ?? colorContainer.controlAccentColor;
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 20, maxHeight: 22, minWidth: 100),
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: theme.controlBackgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
                boxShadow: [
                  if (multipleSelection) ...[
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
                  ],
                ]),
            child: SizedBox.expand(child: LayoutBuilder(builder: (context, contraints) {
              assert(contraints.hasBoundedWidth);
              final tabSize = contraints.maxWidth / widget.controller.length;
              debugPrint('tabSize: $tabSize');
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(widget.controller.length, (index) {
                  final bool isSelected = controller.selectedIndexes.contains(index);
                  final bool isDown = _buttonDownIndexes.contains(index);
                  return DecoratedBox(
                    decoration: isSelected
                        ? BoxDecoration(
                            color: accentColor,
                            borderRadius: index == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0))
                                : index == widget.controller.length - 1
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0))
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
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0))
                                : index == widget.controller.length - 1
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0))
                                    : const BorderRadius.all(Radius.zero),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: enabled
                            ? (details) {
                                setState(() {
                                  _buttonDownIndexes.add(index);
                                });
                              }
                            : null,
                        onTapUp: enabled
                            ? (details) {
                                setState(() {
                                  _buttonDownIndexes.remove(index);
                                });
                              }
                            : null,
                        onTapCancel: enabled
                            ? () {
                                setState(() {
                                  _buttonDownIndexes.remove(index);
                                });
                              }
                            : null,
                        onTap: enabled
                            ? () {
                                setState(() {
                                  controller.toggleIndex(index);
                                  widget.onSelectionChanged?.call(controller.selectedIndexes.toList());
                                });
                              }
                            : null,
                        child: SizedBox(
                            width: tabSize,
                            height: contraints.maxHeight,
                            child: Stack(
                              children: [
                                if (index > 0 && !controller.selectedIndexes.contains(index - 1) && !isSelected) ...[
                                  const VerticalDivider(
                                    indent: 4,
                                    endIndent: 4,
                                    width: 1,
                                    color: Color(0xFFE8E8E8),
                                    thickness: 1,
                                  ),
                                ],
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                  child: Icon(widget.icons![index],
                                      size: 16,
                                      color: isSelected
                                          ? AppKitColors.text.opaque.primary.darkColor
                                          : AppKitColors.text.opaque.primary),
                                )),
                              ],
                            )),
                      ),
                    ),
                  );
                }),
              );
            })),
          ),
        );
      },
    );
  }
}

abstract class SegmentedController extends ChangeNotifier {
  final int length;

  SegmentedController({required this.length}) : assert(length > 0);

  static SegmentedControllerSingle single({int initialIndex = 0, required int length}) {
    return SegmentedControllerSingle(initialIndex: initialIndex, length: length);
  }

  static SegmentedControllerMultiple multiple({Set<int>? initialSelection, required int length}) {
    return SegmentedControllerMultiple(initialSelection: initialSelection, length: length);
  }
}

class SegmentedControllerSingle extends SegmentedController {
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
}

class SegmentedControllerMultiple extends SegmentedController {
  final Set<int> _selectedIndexes;

  SegmentedControllerMultiple({Set<int>? initialSelection, required super.length})
      : _selectedIndexes = initialSelection ?? <int>{},
        assert(initialSelection == null || initialSelection.length <= length);

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

  bool isSelected(int index) {
    assert(index >= 0 && index < length);
    return _selectedIndexes.contains(index);
  }

  List<int> get selectedIndexes {
    return _selectedIndexes.toList();
  }
}
