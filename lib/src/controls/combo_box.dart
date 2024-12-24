import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AppKitComboBox extends StatefulWidget {
  final AppKitControlSize controlSize;
  final List<String>? items;
  final String? placeholder;
  final String? title;
  final AppKitComboBoxStyle style;
  final Color? color;
  final TextAlign textAlign;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final bool autofocus;
  final bool autocompletes;
  final ValueChanged<String>? onChanged;
  final AppKitTextFieldBehavior behavior;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType inputType;
  final bool enabled;
  final double? maxItemsMenuHeight;

  const AppKitComboBox({
    super.key,
    this.controlSize = AppKitControlSize.regular,
    this.items,
    this.placeholder,
    this.title,
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

  final TextEditingController _controller = TextEditingController();

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ??
      (_focusNode ??= FocusNode(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _handleTap();
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
              menu.entries.firstOrNull as AppKitContextMenuItem<String>?,
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
          _controller.text = item;
          _controller.selection = TextSelection(
              baseOffset: value.length, extentOffset: item.length);
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
              ?.map((e) => AppKitContextMenuItem<String>(value: e, title: e))
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
                child:
                    UiElementColorBuilder(builder: (context, colorContainer) {
                  final isMainWindow =
                      MainWindowStateListener.instance.isMainWindow.value;

                  final suffix = textFieldSize != null
                      ? _buildPullDownWidget(
                          colorContainer: colorContainer,
                          isMainWindow: isMainWindow,
                          isHovered: _isHovered,
                          textFieldSize: textFieldSize,
                        )
                      : null;

                  final textField = _buildTextField(
                    colorContainer: colorContainer,
                    style: style,
                    context: context,
                    suffix: suffix,
                    isMainWindow: isMainWindow,
                    isHovered: _isHovered,
                    isFocused: _effectiveFocusNode.hasFocus,
                    isMenuOpened: _isMenuOpened,
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
    required UiElementColorContainer colorContainer,
    required bool isMainWindow,
    required bool isHovered,
    required Size textFieldSize,
  }) {
    switch (widget.style) {
      case AppKitComboBoxStyle.bordered:
        return _buildPushButton(
            colorContainer: colorContainer,
            isMainWindow: isMainWindow,
            textFieldSize: textFieldSize);
      case AppKitComboBoxStyle.plain:
        return _buildPlainButton(
            colorContainer: colorContainer,
            isMainWindow: isMainWindow,
            isHovered: isHovered,
            textFieldSize: textFieldSize);
    }
  }

  Widget _buildPushButton({
    required UiElementColorContainer colorContainer,
    required bool isMainWindow,
    required Size textFieldSize,
  }) {
    return _PushButtonStyleWidget(
      colorContainer: colorContainer,
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
    required UiElementColorContainer colorContainer,
    required bool isMainWindow,
    required bool isHovered,
    required Size textFieldSize,
  }) {
    return _PlainButtonStyleWidget(
        enabled: enabled,
        colorContainer: colorContainer,
        contextMenuOpened: _isMenuOpened,
        isMainWindow: isMainWindow,
        isHovered: isHovered,
        textFieldSize: textFieldSize,
        onTap: enabled ? _handleTap : null,
        controlSize: controlSize);
  }

  Widget _buildTextField({
    required UiElementColorContainer colorContainer,
    required AppKitComboBoxStyle style,
    required BuildContext context,
    required Widget? suffix,
    required bool isMainWindow,
    required bool isHovered,
    required bool isFocused,
    required bool isMenuOpened,
  }) {
    BoxDecoration? decoration;
    final borderRadius = style.getBorderRadius(controlSize: controlSize);

    if (style == AppKitComboBoxStyle.plain) {
      decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isMainWindow && (isHovered || isFocused || isMenuOpened)
              ? colorContainer.controlBackgroundColor
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
  final UiElementColorContainer colorContainer;
  final Color? color;
  final bool isMainWindow;
  final bool isMenuOpened;
  final bool enabled;
  final AppKitControlSize controlSize;
  final VoidCallback? onTap;
  final AppKitComboBoxStyle style = AppKitComboBoxStyle.bordered;
  final Size textFieldSize;

  const _PushButtonStyleWidget({
    required this.colorContainer,
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
    final enabledFactor = enabled ? 1.0 : 0.5;
    final borderRadius = style.getBorderRadius(controlSize: controlSize) - 1;

    Color caretBackgroundColor;
    Color arrowsColor;

    caretBackgroundColor = isMainWindow && enabled
        ? (color ?? theme.primaryColor ?? colorContainer.controlAccentColor)
        : colorContainer.controlBackgroundColor;

    final carteBackgroundColorLiminance =
        caretBackgroundColor.computeLuminance();

    arrowsColor = isMainWindow && enabled
        ? carteBackgroundColorLiminance > 0.5
            ? Colors.black.withOpacity(enabledFactor)
            : Colors.white.withOpacity(enabledFactor)
        : Colors.black.withOpacity(enabledFactor);

    if (isMenuOpened) {
      caretBackgroundColor = caretBackgroundColor.multiplyLuminance(0.9);
    }

    if (!enabled) {
      caretBackgroundColor = caretBackgroundColor.multiplyOpacity(0.5);
    }

    final shadowColor = isMainWindow && enabled
        ? colorContainer.controlAccentColor
        : colorContainer.shadowColor;
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
                    border: !isMainWindow || !enabled
                        ? GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                AppKitColors.text.opaque.tertiary
                                    .multiplyOpacity(0.6),
                                AppKitColors.text.opaque.secondary
                                    .multiplyOpacity(0.75)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.9, 1.0],
                            ),
                            width: 0.5)
                        : null,
                    color: caretBackgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      if (isMainWindow && enabled) ...[
                        BoxShadow(
                          color: shadowColor.withOpacity(0.06),
                          blurRadius: 1.5,
                          spreadRadius: 0.0,
                          offset: const Offset(0, 0.5),
                        ),
                        BoxShadow(
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 1.0,
                          spreadRadius: 0.0,
                          color: shadowColor.withOpacity(0.06),
                        ),
                      ],
                      BoxShadow(
                        offset: const Offset(0.0, 0.5),
                        blurRadius: 0.5,
                        spreadRadius: 0.0,
                        color: shadowColor.withOpacity(0.12),
                      )
                    ]),
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
    );
  }
}

class _PlainButtonStyleWidget extends StatelessWidget {
  final bool enabled;
  final UiElementColorContainer colorContainer;
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
    required this.colorContainer,
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
    final arrowsColor = AppKitColors.labelColor
        .resolveFrom(context)
        .multiplyOpacity(enabledFactor);
    final borderRadius = style.getBorderRadius(controlSize: controlSize) - 1;

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : AppKitColors.text.opaque.quaternary.multiplyOpacity(enabledFactor);
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
                color: caretBackgroundColor,
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
