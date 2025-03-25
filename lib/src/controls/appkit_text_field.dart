import 'dart:async';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

const int _kiOSHorizontalCursorOffsetPixels = -2;
const int _kChangedTimerDuration = 500;

/// A custom text field widget for the AppKit UI library.
///
/// This widget extends [StatefulWidget] to provide a text input field with
/// additional functionality and customization options.
///
/// Usage:
/// ```dart
/// AppKitTextField(
///   // Add your parameters here
/// )
/// ```
///
/// See also:
/// - [AppKitSearchField], which is the underlying widget used for text input.
class AppKitTextField extends StatefulWidget {
  /// The controller for the text field.
  ///
  /// This controller can be used to manipulate the text being edited.
  /// If null, a default controller will be created and used.
  final TextEditingController? controller;

  /// The focus node for the text field, which allows control over the focus state.
  ///
  /// If null, the text field will create its own FocusNode.
  final FocusNode? focusNode;

  /// The padding around the text field content.
  final EdgeInsets padding;

  /// The placeholder text displayed when the text field is empty.
  final String? placeholder;

  /// The title of the text field, typically used as a label.
  final String? title;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// The style to use for the placeholder text.
  final TextStyle? placeholderStyle;

  /// The type of keyboard to use for editing the text.
  final TextInputType keyboardType;

  /// The action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the text should be capitalized.
  final TextCapitalization textCapitalization;

  /// The strut style to use for the text in the text field.
  ///
  /// This defines the minimum height of the line boxes, as well as the vertical
  /// alignment of the text within those boxes.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  ///
  /// This can be used to align the text to the left, right, center, or justify.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  ///
  /// This can be used to align the text to the top, center, or bottom.
  final TextAlignVertical textAlignVertical;

  /// Whether the text field should automatically gain focus when the widget is
  /// first created.
  final bool autofocus;

  /// Whether to enable autocorrect for the text field.
  ///
  /// If true, the text field will attempt to correct misspelled words.
  final bool autocorrect;

  /// The type of smart dashes to use for the text field.
  ///
  /// This can be used to automatically convert double hyphens into em dashes.
  final SmartDashesType smartDashesType;

  /// The type of smart quotes to use for the text field.
  ///
  /// This can be used to automatically convert straight quotes into curly quotes.
  final SmartQuotesType smartQuotesType;

  /// The maximum number of lines the text field can have.
  ///
  /// If null, there is no limit to the number of lines.
  final int? maxLines;

  /// The minimum number of lines the text field can have.
  ///
  /// If null, the text field will have a single line by default.
  final int? minLines;

  /// The maximum number of characters the text field can have.
  ///
  /// If null, there is no limit to the number of characters.
  final int? maxLength;

  /// Whether the text field should expand to fill its parent.
  ///
  /// If true, the text field will expand to fill the available space.
  final bool expands;

  /// The maximum length enforcement for the text field.
  ///
  /// This determines how the text field should enforce the maximum length
  /// constraint. If null, the default behavior is used.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// A list of input formatters to apply to the text field.
  ///
  /// These formatters can be used to restrict the input to certain patterns
  /// or formats.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether the text field is enabled or not.
  ///
  /// If false, the text field will be disabled and not respond to user input.
  final bool enabled;

  /// The height style to use for the selection highlight.
  ///
  /// This determines how the height of the selection highlight is calculated.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// The width style to use for the selection highlight.
  ///
  /// This determines how the width of the selection highlight is calculated.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The amount of padding to apply when scrolling the text field.
  ///
  /// This padding is applied to the scrollable area of the text field.
  final EdgeInsets scrollPadding;

  /// Whether interactive selection is enabled for the text field.
  ///
  /// If false, the user will not be able to interactively select text.
  final bool enableInteractiveSelection;

  /// The selection controls to use for the text field.
  ///
  /// These controls determine the behavior of text selection, such as
  /// copy, paste, and cut actions.
  final TextSelectionControls? selectionControls;

  /// The behavior to use when starting a drag gesture.
  ///
  /// This determines how the text field responds to drag gestures.
  final DragStartBehavior dragStartBehavior;

  /// The scroll controller to use for the text field.
  ///
  /// This controller can be used to control the scrolling behavior of the
  /// text field.
  final ScrollController? scrollController;

  /// The scroll physics to use for the text field.
  ///
  /// These physics determine the behavior of the scrolling, such as
  /// how the scroll view responds to user input.
  final ScrollPhysics? scrollPhysics;

  /// The autofill hints to use for the text field.
  ///
  /// These hints provide suggestions to the autofill service about the
  /// expected content of the text field.
  final Iterable<String>? autofillHints;

  /// An optional identifier for the restoration scope of this text field.
  final String? restorationId;

  /// A widget to display after the editable part of the text field.
  final Widget? suffix;

  /// Controls the visibility of the suffix widget.
  final AppKitOverlayVisibilityMode? suffixMode;

  /// Controls the visibility of the clear button within the text field.
  final AppKitOverlayVisibilityMode? clearButtonMode;

  /// The character used for obscuring text in the text field.
  final String obscuringCharacter;

  /// Whether to obscure the text being edited (e.g., for passwords).
  final bool obscureText;

  /// A widget to display before the editable part of the text field.
  final Widget? prefix;

  /// Padding for the prefix widget.
  final EdgeInsets prefixPadding;

  /// Controls the visibility of the prefix widget.
  final AppKitOverlayVisibilityMode prefixMode;

  /// The color of the cursor in the text field.
  final Color? cursorColor;

  /// The width of the cursor in the text field.
  final double cursorWidth;

  /// The height of the cursor in the text field.
  final double? cursorHeight;

  /// Indicates whether the cursor should be shown.
  final bool showCursor;

  /// Defines the style of the border for the text field.
  final AppKitTextFieldBorderStyle borderStyle;

  /// Specifies the radius of the cursor.
  final Radius cursorRadius;

  /// Specifies the offset of the cursor.
  final Offset? cursorOffset;

  /// A builder for creating a custom context menu for the text field.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Defines the behavior of the text field.
  final AppKitTextFieldBehavior behavior;

  /// The background color of the text field.
  final Color? backgroundColor;

  /// A decoration to be applied to the text field.
  final BoxDecoration? decoration;

  /// Indicates whether the text field should have continuous behavior.
  final bool continuous;

  /// The border radius of the text field.
  final double? borderRadius;

  /// Callback that is called when the text field's value changes.
  ///
  /// The `value` parameter is the current value of the text field.
  final ValueChanged<String>? onChanged;

  /// Callback that is called when the user submits the text field's value.
  ///
  /// The `value` parameter is the value that was submitted.
  final ValueChanged<String>? onSubmitted;

  /// Callback that is called when the user has completed editing the text field.
  final VoidCallback? onEditingComplete;

  /// Callback that is called when the text field is tapped.
  final GestureTapCallback? onTap;

  bool get selectionEnabled => enableInteractiveSelection;

  const AppKitTextField({
    super.key,
    this.keyboardType = TextInputType.text,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.autocorrect = false,
    this.autofillHints,
    this.autofocus = false,
    this.backgroundColor,
    this.behavior = AppKitTextFieldBehavior.editable,
    this.borderStyle = AppKitTextFieldBorderStyle.line,
    this.clearButtonMode = AppKitOverlayVisibilityMode.never,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.continuous = true,
    this.controller,
    this.cursorColor,
    this.cursorHeight,
    this.cursorOffset,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorWidth = 2.0,
    this.decoration,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enabled = true,
    this.enableInteractiveSelection = true,
    this.expands = false,
    this.focusNode,
    this.inputFormatters,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.padding =
        const EdgeInsets.only(left: 5, right: 5, top: 5.0, bottom: 6.0),
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode = AppKitOverlayVisibilityMode.never,
    this.prefixPadding =
        const EdgeInsets.only(top: 1.0, bottom: 3.0, left: 6.0, right: 6.0),
    this.restorationId,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.scrollPhysics,
    this.selectionControls,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.showCursor = true,
    this.strutStyle,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.top,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.suffix,
    this.suffixMode = AppKitOverlayVisibilityMode.always,
    this.title,
    this.borderRadius,
  })  : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(suffix != null ? suffixMode != null : true),
        assert(suffix != null ? clearButtonMode == null : true);

  @override
  State<AppKitTextField> createState() => _AppKitTextFieldState();
}

class _AppKitTextFieldState extends State<AppKitTextField>
    with RestorationMixin, AutomaticKeepAliveClientMixin<AppKitTextField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey _clearGlobalKey = GlobalKey();

  FocusNode? _focusNode;

  RestorableTextEditingController? _controller;

  bool _showSelectionHandles = false;

  Timer? _timer;

  final TextSelectionControls cupertinoDesktopTextSelectionControls =
      CupertinoDesktopTextSelectionControls();

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  EditableTextState get _editableText => editableTextKey.currentState!;

  bool get enabled => widget.enabled;

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  TextAlignVertical get textAlignVertical => widget.textAlignVertical;

  bool get _hasDecoration {
    return widget.placeholder != null ||
        widget.clearButtonMode != AppKitOverlayVisibilityMode.never ||
        (widget.suffix != null &&
            widget.suffixMode != AppKitOverlayVisibilityMode.never);
  }

  late final _TextFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder =
      _TextFieldSelectionGestureDetectorBuilder(state: this);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    }
    _effectiveFocusNode.canRequestFocus =
        widget.enabled && widget.behavior.canRequestFocus;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller?.dispose();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }
    _effectiveFocusNode.canRequestFocus =
        widget.enabled && widget.behavior.canRequestFocus;
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
    _controller!.value.addListener(updateKeepAlive);
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  void _requestKeyboard() {
    _editableText.requestKeyboard();
  }

  bool _shouldShowAttachment({
    required AppKitOverlayVisibilityMode attachment,
    required bool hasText,
  }) {
    switch (attachment) {
      case AppKitOverlayVisibilityMode.never:
        return false;
      case AppKitOverlayVisibilityMode.always:
        return true;
      case AppKitOverlayVisibilityMode.editing:
        return hasText && _effectiveFocusNode.hasFocus;
      case AppKitOverlayVisibilityMode.notEditing:
        return !_effectiveFocusNode.hasFocus;
    }
  }

  bool _showPrefixWidget(TextEditingValue text) {
    return widget.prefix != null &&
        _shouldShowAttachment(
          attachment: widget.prefixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showClearButton(TextEditingValue text) {
    return widget.clearButtonMode != null &&
        _shouldShowAttachment(
          attachment: widget.clearButtonMode!,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showSuffixWidget(TextEditingValue text) {
    return widget.suffix != null &&
        _shouldShowAttachment(
          attachment: widget.suffixMode!,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    // On macOS, we don't show handles when the selection is collapsed.
    if (_effectiveController.selection.isCollapsed) return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (_effectiveController.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    if (cause == SelectionChangedCause.longPress) {
      _editableText.bringIntoView(selection.base);
    }
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }
  }

  void _handleChanged(String value) {
    if (widget.onChanged != null) {
      if (widget.continuous) {
        widget.onChanged!(value);
      } else {
        _timer?.cancel();
        _timer =
            Timer(const Duration(milliseconds: _kChangedTimerDuration), () {
          widget.onChanged!(value);
        });
      }
    }
  }

  void _handleClearButtonTap() {
    // Special handle onChanged for ClearButton
    // Also call onChanged when the clear button is tapped.
    final bool textChanged = _effectiveController.text.isNotEmpty;
    _effectiveController.clear();
    if (widget.onChanged != null && textChanged) {
      widget.onChanged!(_effectiveController.text);
    }
    FocusScope.of(context).requestFocus(_effectiveFocusNode);
    // FocusScope.of(context).unfocus();
    // _effectiveFocusNode.unfocus();
  }

  void _handleSubmitted(String value) {
    setState(() {
      _effectiveController.selectAll();
    });
    widget.onSubmitted?.call(value);
  }

  Widget _addTextDependentAttachments({
    required Widget editableText,
    required TextStyle textStyle,
    required TextStyle placeholderStyle,
  }) {
    // If there are no surrounding widgets, just return the core editable text
    // part.
    if (!_hasDecoration) {
      return editableText;
    }

    Color iconsColor =
        AppKitDynamicColor.resolve(context, AppKitColors.secondaryLabelColor)
            .multiplyOpacity(enabled ? 1.0 : 0.5);

    if (!enabled) {
      iconsColor = iconsColor.withValues(alpha: 0.2);
    }

    // Otherwise, listen to the current state of the text entry.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      child: editableText,
      builder: (BuildContext context, TextEditingValue? text, Widget? child) {
        final multiline = widget.maxLines == null || widget.maxLines! > 1;
        return Row(
          crossAxisAlignment:
              multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            // Insert a prefix at the front if the prefix visibility mode matches
            // the current text state.
            if (_showPrefixWidget(text!))
              Padding(
                padding: widget.prefixPadding,
                child: widget.prefix!,
              ),
            // In the middle part, stack the placeholder on top of the main EditableText
            // if needed.
            Expanded(
              child: Stack(
                fit: StackFit.passthrough,
                alignment: widget.maxLines == null || widget.maxLines! > 1
                    ? Alignment.topCenter
                    : Alignment.center,
                children: <Widget>[
                  if (widget.placeholder != null && text.text.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: widget.padding,
                        child: Text(
                          widget.placeholder!,
                          maxLines: widget.maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: placeholderStyle,
                          textAlign: widget.textAlign,
                        ),
                      ),
                    ),
                  child!,
                ],
              ),
            ),
            // First add the explicit suffix if the suffix visibility mode matches.

            Builder(builder: (context) {
              final clearButtonSize =
                  textStyle.fontSize != null ? textStyle.fontSize! + 3 : 16.0;

              if (_showSuffixWidget(text)) {
                return widget.suffix!;
              }

              final showClearButton = _showClearButton(text);

              return enabled && showClearButton
                  ? FocusScope(
                      canRequestFocus: false,
                      child: TapRegion(
                        behavior: HitTestBehavior.opaque,
                        consumeOutsideTaps: false,
                        enabled: enabled && showClearButton,
                        onTapInside: (event) {
                          _handleClearButtonTap();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.basic,
                          child: GestureDetector(
                            key: _clearGlobalKey,
                            child: Padding(
                              padding: EdgeInsets.only(
                                // bottom: widget.padding.bottom - 0.5,
                                top: multiline ? widget.padding.top - 0.5 : 0.0,
                                left: 6.0,
                                right: 6.0,
                              ),
                              child: SizedBox(
                                height: clearButtonSize,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: showClearButton
                                      ? Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: iconsColor,
                                        )
                                      : SizedBox(
                                          height: clearButtonSize,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: clearButtonSize);
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assert(debugCheckHasAppKitTheme(context));

    final TextEditingController controller = _effectiveController;
    TextSelectionControls? textSelectionControls =
        widget.selectionControls ?? cupertinoDesktopTextSelectionControls;

    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    TextStyle? resolvedPlaceholderStyle = widget.placeholderStyle;
    TextStyle? resolvedStyle = widget.style;

    return Consumer<MainWindowModel>(builder: (context, model, _) {
      final theme = AppKitTheme.of(context);
      Color textColor = theme.typography.body.color ??
          AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.primary);

      final textStyle = theme.typography.body
          .copyWith(color: textColor.multiplyOpacity(enabled ? 1.0 : 0.5))
          .merge(resolvedStyle);

      final placeholderStyle = theme.typography.body
          .copyWith(
              color: AppKitDynamicColor.resolve(
                      context, AppKitColors.placeholderTextColor)
                  .multiplyOpacity(enabled ? 1.0 : 0.5))
          .merge(resolvedPlaceholderStyle);

      final Color selectionColor = theme.selectedTextBackgroundColor;

      final Color cursorColor =
          widget.cursorColor ?? theme.activeColor.multiplyLuminance(1.1);

      final Offset cursorOffset = widget.cursorOffset ??
          Offset(
            _kiOSHorizontalCursorOffsetPixels /
                MediaQuery.of(context).devicePixelRatio,
            0,
          );

      final decoration = _getBoxDecoration(context,
          theme: theme, fontSize: textStyle.fontSize);

      final Widget paddedEditable = Padding(
        padding: widget.padding,
        child: RepaintBoundary(
          child: UnmanagedRestorationScope(
            bucket: bucket,
            child: EditableText(
              key: editableTextKey,
              controller: controller,
              readOnly: widget.behavior.readOnly,
              showCursor: widget.showCursor && !widget.behavior.readOnly,
              showSelectionHandles: _showSelectionHandles,
              focusNode: _effectiveFocusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              style: textStyle,
              strutStyle: widget.strutStyle,
              textAlign: widget.textAlign,
              autofocus: widget.autofocus &&
                  widget.enabled &&
                  _effectiveFocusNode.canRequestFocus &&
                  widget.behavior != AppKitTextFieldBehavior.none,
              obscuringCharacter: widget.obscuringCharacter,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              smartDashesType: widget.smartDashesType,
              smartQuotesType: widget.smartQuotesType,
              enableSuggestions: false,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              expands: widget.expands,
              selectionColor: selectionColor,
              selectionControls:
                  selectionEnabled ? textSelectionControls : null,
              onChanged: enabled ? _handleChanged : null,
              onSelectionChanged: _handleSelectionChanged,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: enabled ? _handleSubmitted : null,
              inputFormatters: formatters,
              rendererIgnoresPointer: true,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorColor: cursorColor,
              cursorOpacityAnimates: true,
              cursorOffset: cursorOffset,
              paintCursorAboveText: true,
              autocorrectionTextRectColor: selectionColor,
              backgroundCursorColor:
                  AppKitDynamicColor.resolve(context, AppKitColors.systemGray),
              selectionHeightStyle: widget.selectionHeightStyle,
              selectionWidthStyle: widget.selectionWidthStyle,
              scrollPadding: widget.scrollPadding,
              // keyboardAppearance: keyboardAppearance,
              dragStartBehavior: widget.dragStartBehavior,
              scrollController: widget.scrollController,
              scrollPhysics: widget.scrollPhysics,
              enableInteractiveSelection: widget.enableInteractiveSelection &&
                  widget.behavior != AppKitTextFieldBehavior.none,
              autofillHints: widget.autofillHints,
              restorationId: 'editable',
              mouseCursor: SystemMouseCursors.text,
              contextMenuBuilder: widget.contextMenuBuilder,
            ),
          ),
        ),
      );

      return Semantics(
        enabled: enabled,
        onTap: !enabled || widget.behavior.readOnly
            ? null
            : () {
                if (!controller.selection.isValid) {
                  controller.selection =
                      TextSelection.collapsed(offset: controller.text.length);
                }
                _requestKeyboard();
              },
        child: IgnorePointer(
          ignoring: !enabled || !widget.behavior.canRequestFocus,
          child: AppKitFocusContainer(
            borderRadius: decoration.borderRadius,
            textField: true,
            focusNode: _effectiveFocusNode,
            enabled: enabled && _effectiveFocusNode.canRequestFocus,
            child: Container(
              decoration: decoration,
              child: _selectionGestureDetectorBuilder.buildGestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Align(
                  alignment: Alignment(-1.0, textAlignVertical.y),
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: _addTextDependentAttachments(
                    editableText: paddedEditable,
                    textStyle: textStyle,
                    placeholderStyle: placeholderStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  BoxDecoration _getBoxDecoration(BuildContext context,
      {required AppKitThemeData theme, double? fontSize}) {
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ??
        (enabled
            ? theme.controlColor.withValues(alpha: isDark ? 0.1 : 1.0)
            : theme.controlColor.withValues(alpha: isDark ? 0.25 : 0.5));
    const borderWidth = 0.5;

    final borderRadius =
        widget.borderStyle.getBorderRadius(widget.borderRadius);

    if (widget.decoration != null) {
      return widget.decoration!;
    }

    switch (widget.borderStyle) {
      case AppKitTextFieldBorderStyle.none:
        return BoxDecoration(color: backgroundColor);

      case AppKitTextFieldBorderStyle.line:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: isDark
                ? AppKitColors.controlColor.darkColor
                : AppKitColors.shadowColor.withValues(alpha: 0.3),
            width: borderWidth,
          ),
        );

      case AppKitTextFieldBorderStyle.bezel:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: GradientBoxBorder(
              gradient: LinearGradient(
                colors: [
                  isDark
                      ? AppKitColors.text.opaque.tertiary.darkColor
                          .multiplyOpacity(0.6)
                      : AppKitColors.text.opaque.tertiary.multiplyOpacity(0.6),
                  isDark
                      ? AppKitColors.text.opaque.secondary.darkColor
                          .multiplyOpacity(0.75)
                      : AppKitColors.text.opaque.secondary.multiplyOpacity(0.75)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.9, 1.0],
              ),
              width: borderWidth),
        );

      case AppKitTextFieldBorderStyle.rounded:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppKitColors.shadowColor.withValues(alpha: 0.05),
          //     blurRadius: 1.25,
          //     offset: const Offset(0, 0.25),
          //     blurStyle: BlurStyle.outer,
          //   ),
          // ],
          border: isDark
              ? GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      AppKitDynamicColor.resolve(
                              context, AppKitColors.text.opaque.tertiary)
                          .multiplyOpacity(0.5),
                      AppKitDynamicColor.resolve(
                              context, AppKitColors.text.opaque.primary)
                          .multiplyOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.8, 1.0],
                  ),
                  width: borderWidth,
                )
              : GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      AppKitColors.text.opaque.tertiary.multiplyOpacity(0.6),
                      AppKitColors.text.opaque.secondary.multiplyOpacity(0.75)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.9, 1.0],
                  ),
                  width: borderWidth),
        );
    }
  }

  @override
  GlobalKey<EditableTextState> editableTextKey = GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => true;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'controller', widget.controller,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', widget.focusNode,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', widget.padding));
    properties.add(StringProperty('placeholder', widget.placeholder));
    properties.add(StringProperty('title', widget.title));
    properties.add(DiagnosticsProperty<TextStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<TextStyle>(
        'placeholderStyle', widget.placeholderStyle));
    properties.add(EnumProperty<TextAlign>('textAlign', widget.textAlign));
    properties.add(DiagnosticsProperty<TextAlignVertical>(
        'textAlignVertical', widget.textAlignVertical));
    properties.add(DiagnosticsProperty<TextInputType>(
        'keyboardType', widget.keyboardType));
    properties.add(DiagnosticsProperty<TextInputAction>(
        'textInputAction', widget.textInputAction));
    properties.add(EnumProperty<TextCapitalization>(
        'textCapitalization', widget.textCapitalization));
    properties
        .add(DiagnosticsProperty<StrutStyle>('strutStyle', widget.strutStyle));
    properties.add(DiagnosticsProperty<bool>('autofocus', widget.autofocus));
    properties
        .add(DiagnosticsProperty<bool>('autocorrect', widget.autocorrect));
    properties.add(DiagnosticsProperty<SmartDashesType>(
        'smartDashesType', widget.smartDashesType));
    properties.add(DiagnosticsProperty<SmartQuotesType>(
        'smartQuotesType', widget.smartQuotesType));
    properties.add(DiagnosticsProperty<int>('maxLines', widget.maxLines));
    properties.add(DiagnosticsProperty<int>('minLines', widget.minLines));
    properties.add(DiagnosticsProperty<int>('maxLength', widget.maxLength));
    properties.add(DiagnosticsProperty<bool>('expands', widget.expands));
    properties.add(DiagnosticsProperty<MaxLengthEnforcement>(
        'maxLengthEnforcement', widget.maxLengthEnforcement));
    properties.add(IterableProperty<TextInputFormatter>(
        'inputFormatters', widget.inputFormatters));
    properties.add(DiagnosticsProperty<bool>('enabled', widget.enabled));
    properties.add(EnumProperty<ui.BoxHeightStyle>(
        'selectionHeightStyle', widget.selectionHeightStyle));
    properties.add(EnumProperty<ui.BoxWidthStyle>(
        'selectionWidthStyle', widget.selectionWidthStyle));
    properties.add(
        DiagnosticsProperty<EdgeInsets>('scrollPadding', widget.scrollPadding));
    properties.add(DiagnosticsProperty<bool>(
        'enableInteractiveSelection', widget.enableInteractiveSelection));
    properties.add(DiagnosticsProperty<TextSelectionControls>(
        'selectionControls', widget.selectionControls));
    properties.add(EnumProperty<DragStartBehavior>(
        'dragStartBehavior', widget.dragStartBehavior));
    properties.add(DiagnosticsProperty<ScrollController>(
        'scrollController', widget.scrollController));
    properties.add(DiagnosticsProperty<ScrollPhysics>(
        'scrollPhysics', widget.scrollPhysics));
    properties
        .add(IterableProperty<String>('autofillHints', widget.autofillHints));
    properties.add(StringProperty('restorationId', widget.restorationId));
    properties.add(EnumProperty<AppKitOverlayVisibilityMode>(
        'clearButtonMode', widget.clearButtonMode));
    properties
        .add(StringProperty('obscuringCharacter', widget.obscuringCharacter));
    properties
        .add(DiagnosticsProperty<bool>('obscureText', widget.obscureText));
    properties.add(DiagnosticsProperty<Widget>('prefix', widget.prefix));
    properties.add(EnumProperty<AppKitOverlayVisibilityMode>(
        'prefixMode', widget.prefixMode));
    properties
        .add(DiagnosticsProperty<Color>('cursorColor', widget.cursorColor));
    properties.add(DoubleProperty('cursorWidth', widget.cursorWidth));
    properties.add(DoubleProperty('cursorHeight', widget.cursorHeight));
    properties.add(DiagnosticsProperty<bool>('showCursor', widget.showCursor));
    properties.add(EnumProperty<AppKitTextFieldBorderStyle>(
        'borderStyle', widget.borderStyle));
    properties
        .add(DiagnosticsProperty<Radius>('cursorRadius', widget.cursorRadius));
    properties
        .add(DiagnosticsProperty<Offset>('cursorOffset', widget.cursorOffset));
    properties.add(DiagnosticsProperty<EditableTextContextMenuBuilder>(
        'contextMenuBuilder', widget.contextMenuBuilder));
    properties.add(DiagnosticsProperty<AppKitTextFieldBehavior>(
        'behavior', widget.behavior));
    properties.add(
        DiagnosticsProperty<Color>('backgroundColor', widget.backgroundColor));
    properties.add(
        DiagnosticsProperty<BoxDecoration>('decoration', widget.decoration));
  }

  @override
  bool get wantKeepAlive => _controller?.value.text.isNotEmpty == true;

  @override
  bool get selectionEnabled => widget.selectionEnabled;
}

class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _TextFieldSelectionGestureDetectorBuilder({
    required _AppKitTextFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _AppKitTextFieldState _state;

  @override
  void onSingleTapUp(TapDragUpDetails details) {
    // Because TextSelectionGestureDetector listens to taps that happen on
    // widgets in front of it, tapping the clear button will also trigger
    // this handler. If the clear button widget recognizes the up event,
    // then do not handle it.
    if (_state._clearGlobalKey.currentContext != null) {
      final RenderBox renderBox = _state._clearGlobalKey.currentContext!
          .findRenderObject()! as RenderBox;
      final Offset localOffset =
          renderBox.globalToLocal(details.globalPosition);

      if (renderBox.hitTest(BoxHitTestResult(), position: localOffset)) {
        return;
      }
    }
    if (delegate.selectionEnabled) {
      renderEditable.selectPosition(cause: SelectionChangedCause.tap);
    }
    _state._requestKeyboard();
    if (_state.widget.onTap != null) _state.widget.onTap!();

    super.onSingleTapUp(details);
  }

  @override
  void onDragSelectionEnd(TapDragEndDetails details) {
    _state._requestKeyboard();
    super.onDragSelectionEnd(details);
  }
}

Widget _defaultContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return CupertinoAdaptiveTextSelectionToolbar.editableText(
    editableTextState: editableTextState,
  );
}
