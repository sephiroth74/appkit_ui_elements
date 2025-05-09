import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

/// A custom combo box widget with customizable properties.
///
/// The [AppKitComboBox] widget allows users to select a value from a dropdown list
/// or enter a custom value. The appearance and behavior of the combo box can be
/// customized using various properties.
///
/// Example usage:
/// ```dart
/// AppKitComboBox(
///   value: 'Option 1',
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   onChanged: (newValue) {
///     print('Selected value: $newValue');
///   },
/// )
/// ```
class AppKitComboBox extends StatefulWidget {
  /// The size of the control.
  ///
  /// Determines the overall dimensions of the combo box.
  final AppKitControlSize controlSize;

  /// The list of items to display in the dropdown.
  ///
  /// Must not be null.
  final List<String>? items;

  /// The placeholder text to display when no value is selected.
  ///
  /// If null, no placeholder will be displayed.
  final String? placeholder;

  /// The current value of the combo box.
  ///
  /// Must be one of the items in the [items] list or a custom value.
  final String? value;

  /// The style of the combo box.
  ///
  /// Determines the visual appearance of the combo box.
  final AppKitComboBoxStyle style;

  /// The color of the combo box.
  ///
  /// If null, a default color will be used.
  final Color? color;

  /// The alignment of the text inside the combo box.
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// The semantic label for the combo box.
  ///
  /// Used by accessibility tools to describe the combo box.
  final String? semanticLabel;

  /// The focus node for the combo box.
  ///
  /// If null, a new focus node will be created.
  final FocusNode? focusNode;

  /// Whether the combo box can request focus.
  ///
  /// Defaults to true.
  final bool canRequestFocus;

  /// Whether the combo box should automatically focus when first displayed.
  ///
  /// Defaults to false.
  final bool autofocus;

  /// Whether the combo box should autocomplete user input.
  ///
  /// Defaults to true.
  final bool autocompletes;

  /// Called when the user changes the combo box's value.
  ///
  /// If null, the combo box will be disabled.
  final ValueChanged<String>? onChanged;

  /// The behavior of the text field inside the combo box.
  ///
  /// Determines how the text field behaves.
  final AppKitTextFieldBehavior behavior;

  /// The maximum length of the input.
  ///
  /// If null, no maximum length is enforced.
  final int? maxLength;

  /// The enforcement policy for the maximum length.
  ///
  /// If null, no enforcement policy is applied.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// The input formatters for the text field.
  ///
  /// If null, no input formatters are applied.
  final List<TextInputFormatter>? inputFormatters;

  /// The type of input for the text field.
  ///
  /// Defaults to [TextInputType.text].
  final TextInputType inputType;

  /// Whether the combo box is enabled.
  ///
  /// Defaults to true.
  final bool enabled;

  /// The maximum height of the dropdown menu.
  ///
  /// If null, the height will be determined by the number of items.
  final double? maxItemsMenuHeight;

  /// Creates an [AppKitComboBox] widget.
  ///
  /// The [value] and [items] parameters must not be null.
  const AppKitComboBox({
    super.key,
    this.controlSize = AppKitControlSize.regular,
    this.items,
    this.placeholder,
    this.value,
    this.style = AppKitComboBoxStyle.bordered,
    this.color,
    this.textAlign = TextAlign.start,
    this.semanticLabel,
    this.focusNode,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.autocompletes = false,
    this.onChanged,
    this.enabled = true,
    this.behavior = AppKitTextFieldBehavior.editable,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.inputType = TextInputType.text,
    this.maxItemsMenuHeight,
  });

  @override
  State<AppKitComboBox> createState() => _AppKitComboBoxState();
}

class _AppKitComboBoxState extends State<AppKitComboBox> {
  FocusNode? _focusNode;

  bool _isHovered = false;

  bool _isMenuOpened = false;

  bool get enabled => widget.enabled;

  AppKitComboBoxStyle get style => widget.style;

  AppKitControlSize get controlSize => widget.controlSize;

  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ??
      (_focusNode ??= FocusNode(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _handleTap();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (event is KeyDownEvent) {
              final currentSelection = _controller.selection;
              setState(() {
                if (currentSelection.isCollapsed) {
                  if (currentSelection.end > 0) {
                    _controller.text = _controller.text
                            .substring(0, currentSelection.end - 1) +
                        _controller.text.substring(
                            currentSelection.end, _controller.text.length);
                    _controller.selection = TextSelection.collapsed(
                        offset: currentSelection.end - 1);
                  }
                } else {
                  _controller.text =
                      _controller.text.substring(0, currentSelection.start) +
                          _controller.text.substring(
                              currentSelection.end, _controller.text.length);
                  _controller.selection =
                      TextSelection.collapsed(offset: currentSelection.start);
                }
                widget.onChanged?.call(_controller.text);
              });
            }

            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.delete) {
            if (event is KeyDownEvent) {
              final currentSelection = _controller.selection;
              setState(() {
                if (currentSelection.isCollapsed) {
                  if (currentSelection.end < _controller.text.length) {
                    _controller.text = _controller.text
                            .substring(0, currentSelection.end) +
                        _controller.text.substring(
                            currentSelection.end + 1, _controller.text.length);
                    _controller.selection =
                        TextSelection.collapsed(offset: currentSelection.end);
                  }
                } else {
                  _controller.text =
                      _controller.text.substring(0, currentSelection.start) +
                          _controller.text.substring(
                              currentSelection.end, _controller.text.length);
                  _controller.selection =
                      TextSelection.collapsed(offset: currentSelection.start);
                }
                widget.onChanged?.call(_controller.text);
              });
            }

            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      ));

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.canRequestFocus = widget.canRequestFocus && enabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(AppKitComboBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlSize != widget.controlSize) {
      _textFieldSize.value = null;
    }
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  void _handleMouseEnter(_) {
    setState(() {
      _isHovered = true;
    });
  }

  void _handleMouseExit(_) {
    setState(() {
      _isHovered = false;
    });
  }

  void _handleFocusChanged() {
    if (!_effectiveFocusNode.hasFocus && !_isMenuOpened) {
      _controller.clearSelection();
      widget.onChanged?.call(_controller.text);
    }
  }

  void _handleTap() async {
    final itemRect = context.getWidgetBounds();

    if (null != itemRect) {
      final menu = _buildContextMenu(context, itemRect).copyWith(
        position: AppKitMenuEdge.bottom.getRectPosition(itemRect),
        maxHeight: widget.maxItemsMenuHeight,
      );

      setState(() {
        _isMenuOpened = true;
        if (_effectiveFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_effectiveFocusNode);
        }
      });

      final value = await showContextMenu<String>(context,
          contextMenu: menu,
          transitionDuration: kContextMenuTrasitionDuration,
          barrierDismissible: true,
          enableWallpaperTinting: false,
          opaque: false,
          selectedItem:
              (menu.entries.firstOrNull as AppKitContextMenuItem<String>?)
                  ?.value,
          menuEdge: AppKitMenuEdge.bottom);

      setState(() {
        if (value?.value != null) {
          _controller.text = value!.value!;
          widget.onChanged?.call(value.value!);
        }

        _isMenuOpened = false;
      });
    }
  }

  void _handleTextChanged(String value) {
    if (widget.autocompletes && widget.items != null && value.isNotEmpty) {
      final item = widget.items!.firstWhereOrNull(
          (e) => e.toLowerCase().startsWith(value.toLowerCase()));
      if (item != null) {
        setState(() {
          TextSelection? currentSelection = _controller.selection;

          _controller.text = item;

          if (currentSelection.isCollapsed &&
              currentSelection.end == value.length) {
            _controller.selection = TextSelection(
                baseOffset: value.length, extentOffset: item.length);
          }
          widget.onChanged?.call(item);
        });
      }
    }
  }

  void _handleEditingComplete() {}

  void _handleSubmitted(String value) {
    widget.onChanged?.call(value);
  }

  AppKitContextMenu<String> _buildContextMenu(
      BuildContext context, Rect? itemRect) {
    return AppKitContextMenu(
      minWidth: itemRect?.width ?? 50,
      maxWidth: itemRect?.width ?? 150,
      entries: widget.items
              ?.map((e) =>
                  AppKitContextMenuItem<String>(value: e, child: Text(e)))
              .toList() ??
          [],
    );
  }

  final ValueNotifier<Size?> _textFieldSize = ValueNotifier<Size?>(null);

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return ValueListenableBuilder(
        valueListenable: _textFieldSize,
        builder: (BuildContext context, Size? textFieldSize, Widget? child) {
          return Builder(builder: (context) {
            return MouseRegion(
              onEnter: enabled ? _handleMouseEnter : null,
              onExit: enabled ? _handleMouseExit : null,
              child: GestureDetector(
                child: Consumer<MainWindowModel>(builder: (context, model, _) {
                  final isMainWindow = model.isMainWindow;
                  final theme = AppKitTheme.of(context);
                  final suffix = textFieldSize != null
                      ? _buildPullDownWidget(
                          isMainWindow: isMainWindow,
                          isHovered: _isHovered,
                          textFieldSize: textFieldSize,
                        )
                      : null;

                  final textField = _buildTextField(
                    style: style,
                    context: context,
                    suffix: suffix,
                    isMainWindow: isMainWindow,
                    isHovered: _isHovered,
                    isFocused: _effectiveFocusNode.hasFocus,
                    isMenuOpened: _isMenuOpened,
                    theme: theme,
                  );

                  return Opacity(
                    opacity: textFieldSize == null ? 0.0 : 1.0,
                    child: AppKitMeasureSingleChildWidget(
                        onSizeChanged: textFieldSize == null
                            ? (value) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  _textFieldSize.value = value;
                                });
                              }
                            : null,
                        child: textField),
                  );
                }),
              ),
            );
          });
        });
  }

  Widget _buildPullDownWidget({
    required bool isMainWindow,
    required bool isHovered,
    required Size textFieldSize,
  }) {
    switch (widget.style) {
      case AppKitComboBoxStyle.bordered:
        return _buildPushButton(
            isMainWindow: isMainWindow, textFieldSize: textFieldSize);
      case AppKitComboBoxStyle.plain:
        return _buildPlainButton(
            isMainWindow: isMainWindow,
            isHovered: isHovered,
            textFieldSize: textFieldSize);
    }
  }

  Widget _buildPushButton({
    required bool isMainWindow,
    required Size textFieldSize,
  }) {
    return _PushButtonStyleWidget(
      color: widget.color,
      isMainWindow: isMainWindow,
      controlSize: widget.controlSize,
      isMenuOpened: _isMenuOpened,
      enabled: enabled,
      textFieldSize: textFieldSize,
      onTap: enabled ? _handleTap : null,
    );
  }

  Widget _buildPlainButton({
    required bool isMainWindow,
    required bool isHovered,
    required Size textFieldSize,
  }) {
    return _PlainButtonStyleWidget(
        enabled: enabled,
        contextMenuOpened: _isMenuOpened,
        isMainWindow: isMainWindow,
        isHovered: isHovered,
        textFieldSize: textFieldSize,
        onTap: enabled ? _handleTap : null,
        controlSize: controlSize);
  }

  Widget _buildTextField({
    required AppKitComboBoxStyle style,
    required BuildContext context,
    required Widget? suffix,
    required bool isMainWindow,
    required bool isHovered,
    required bool isFocused,
    required bool isMenuOpened,
    required AppKitThemeData theme,
  }) {
    BoxDecoration? decoration;
    final borderRadius = style.getBorderRadius(controlSize: controlSize);
    final theme = AppKitTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (style == AppKitComboBoxStyle.plain) {
      decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isMainWindow && (isHovered || isFocused || isMenuOpened)
              ? isDark
                  ? theme.controlColor.withValues(alpha: 0.1)
                  : theme.controlColor
              : Colors.transparent);
    }

    return AppKitTextField(
      autocorrect: widget.autocompletes,
      autofocus: widget.autofocus,
      behavior: widget.behavior,
      borderStyle: widget.style.borderStyle,
      clearButtonMode: null,
      continuous: true,
      enabled: enabled,
      padding: controlSize.padding,
      focusNode: _effectiveFocusNode,
      inputFormatters: widget.inputFormatters,
      keyboardType: TextInputType.text,
      maxLength: widget.maxLength,
      maxLengthEnforcement: _effectiveMaxLengthEnforcement,
      minLines: 1,
      maxLines: 1,
      borderRadius: borderRadius,
      controller: _controller,
      onChanged: enabled ? _handleTextChanged : null,
      onEditingComplete: enabled ? _handleEditingComplete : null,
      onSubmitted: enabled ? _handleSubmitted : null,
      placeholder: widget.placeholder,
      placeholderStyle: widget.controlSize.textStyle,
      prefixMode: AppKitOverlayVisibilityMode.never,
      textAlign: widget.textAlign,
      suffix: suffix,
      suffixMode: AppKitOverlayVisibilityMode.always,
      decoration: decoration,
      style: widget.controlSize.textStyle,
    );
  }
}

class _PushButtonStyleWidget extends StatelessWidget {
  final Color? color;
  final bool isMainWindow;
  final bool isMenuOpened;
  final bool enabled;
  final AppKitControlSize controlSize;
  final VoidCallback? onTap;
  final AppKitComboBoxStyle style = AppKitComboBoxStyle.bordered;
  final Size textFieldSize;

  const _PushButtonStyleWidget({
    this.color,
    required this.isMainWindow,
    required this.controlSize,
    required this.isMenuOpened,
    required this.enabled,
    required this.onTap,
    required this.textFieldSize,
  });

  static const caretButtonPadding = 1.5;

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final enabledFactor = enabled ? 1.0 : 0.5;
    final borderRadius = style.getBorderRadius(controlSize: controlSize) - 1;

    Color caretBackgroundColor;
    Color arrowsColor;

    caretBackgroundColor = isMainWindow && enabled
        ? (color ?? theme.activeColor)
        : theme.controlColor;

    final carteBackgroundColorLiminance =
        caretBackgroundColor.computeLuminance();

    arrowsColor = isMainWindow && enabled
        ? carteBackgroundColorLiminance > 0.5
            ? Colors.black.withValues(alpha: enabledFactor)
            : Colors.white.withValues(alpha: enabledFactor)
        : isDark
            ? Colors.white.withValues(alpha: enabledFactor)
            : Colors.black.withValues(alpha: enabledFactor);

    if (isMenuOpened) {
      caretBackgroundColor = caretBackgroundColor.multiplyLuminance(0.9);
    }

    if (!enabled) {
      caretBackgroundColor = caretBackgroundColor.multiplyOpacity(0.5);
    }

    final caretButtonSize = textFieldSize.height - (caretButtonPadding * 2);

    return FocusScope(
      canRequestFocus: false,
      child: TapRegion(
        behavior: HitTestBehavior.opaque,
        consumeOutsideTaps: false,
        enabled: enabled,
        onTapInside: enabled ? (_) => onTap?.call() : null,
        child: Center(
          child: SizedBox.square(
            dimension: textFieldSize.height,
            child: Padding(
              padding: const EdgeInsets.all(caretButtonPadding),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: isMainWindow && enabled
                        ? GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      AppKitDynamicColor.resolve(context,
                                              AppKitColors.text.opaque.primary)
                                          .multiplyOpacity(0.5),
                                      AppKitDynamicColor.resolve(
                                              context,
                                              AppKitColors
                                                  .text.opaque.quaternary)
                                          .multiplyOpacity(0.0)
                                    ]
                                  : [
                                      AppKitDynamicColor.resolve(context,
                                              AppKitColors.text.opaque.tertiary)
                                          .multiplyOpacity(0.5),
                                      AppKitDynamicColor.resolve(
                                              context,
                                              AppKitColors
                                                  .text.opaque.secondary)
                                          .multiplyOpacity(0.5)
                                    ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops:
                                  isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                            ),
                            width: 0.5,
                          )
                        : null,
                    color:
                        isMainWindow && enabled ? caretBackgroundColor : null,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      if (isMainWindow && enabled) ...[
                        BoxShadow(
                          color: theme.activeColor.withValues(alpha: 0.5),
                          blurRadius: 0.5,
                          spreadRadius: 0,
                          offset: const Offset(0, 0.5),
                        ),
                      ],
                    ]),
                child: DecoratedBox(
                  decoration: isMainWindow && enabled
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius - 1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white
                                  .withValues(alpha: isDark ? 0.05 : 0.17),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        )
                      : const BoxDecoration(),
                  child: Center(
                    child: SizedBox(
                      width: caretButtonSize,
                      height: caretButtonSize,
                      child: CustomPaint(
                        painter: IconButtonPainter(
                          icon: AppKitControlButtonIcon.disclosureDown,
                          size: caretButtonSize,
                          color: arrowsColor,
                          // strokeWidth: style.getCaretStrokeWidth(theme: popupButtonTheme, controlSize: controlSize),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlainButtonStyleWidget extends StatelessWidget {
  final bool enabled;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final bool isHovered;
  final AppKitControlSize controlSize;
  final VoidCallback? onTap;
  final Size textFieldSize;
  final AppKitComboBoxStyle style = AppKitComboBoxStyle.plain;

  static const caretButtonPadding = 1.5;

  const _PlainButtonStyleWidget({
    required this.enabled,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.onTap,
    required this.textFieldSize,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabledFactor = enabled ? 1.0 : 0.5;

    final Color caretBackgroundColor;
    final caretButtonSize = textFieldSize.height - (caretButtonPadding * 2);
    final arrowsColor =
        AppKitDynamicColor.resolve(context, AppKitColors.labelColor)
            .multiplyOpacity(enabledFactor);
    final borderRadius = style.getBorderRadius(controlSize: controlSize) - 1;

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : AppKitDynamicColor.resolve(
                  context, AppKitColors.text.opaque.quaternary)
              .multiplyOpacity(enabledFactor);
    }

    return FocusScope(
      canRequestFocus: false,
      child: TapRegion(
        behavior: HitTestBehavior.opaque,
        consumeOutsideTaps: false,
        enabled: enabled,
        onTapInside: enabled ? (_) => onTap?.call() : null,
        child: Padding(
          padding: const EdgeInsets.all(caretButtonPadding),
          child: SizedBox.square(
            dimension: textFieldSize.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isMainWindow && enabled ? caretBackgroundColor : null,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: IconButtonPainter(
                      icon: AppKitControlButtonIcon.arrows,
                      size: caretButtonSize,
                      color: arrowsColor,
                      // strokeWidth: style.getCaretStrokeWidth(theme: popupButtonTheme, controlSize: controlSize),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension _ControlSizeX on AppKitControlSize {
  EdgeInsets get padding {
    switch (this) {
      case AppKitControlSize.mini:
        return const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.5);
      case AppKitControlSize.small:
        return const EdgeInsets.symmetric(horizontal: 7.0, vertical: 1.5);
      case AppKitControlSize.regular:
        return const EdgeInsets.only(left: 8, right: 8, top: 2.0, bottom: 3.25);

      case AppKitControlSize.large:
        return const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 3.5, bottom: 5.5);
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case AppKitControlSize.mini:
        return const TextStyle(fontSize: 9.5);
      case AppKitControlSize.small:
        return const TextStyle(fontSize: 11.0);
      case AppKitControlSize.regular:
        return const TextStyle(fontSize: 13.0);
      case AppKitControlSize.large:
        return const TextStyle(fontSize: 16.0);
    }
  }
}

extension _AppKitComboBoxStyleX on AppKitComboBoxStyle {
  double getBorderRadius({
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitComboBoxStyle.bordered:
      case AppKitComboBoxStyle.plain:
        switch (controlSize) {
          case AppKitControlSize.mini:
            return 3.5;
          case AppKitControlSize.small:
            return 4.5;
          case AppKitControlSize.regular:
            return 5.5;
          case AppKitControlSize.large:
            return 6.0;
        }
    }
  }

  AppKitTextFieldBorderStyle get borderStyle {
    switch (this) {
      case AppKitComboBoxStyle.bordered:
        return AppKitTextFieldBorderStyle.rounded;
      case AppKitComboBoxStyle.plain:
        return AppKitTextFieldBorderStyle.rounded;
    }
  }
}
