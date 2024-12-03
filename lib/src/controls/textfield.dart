import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart' hide BrightnessX;

class AppKitTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets padding;
  final String? placeholder;
  final String? title;
  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool readOnly;
  final bool autofocus;
  final bool canRequestFocus;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final AppKitOverlayVisibilityMode clearButtonMode;
  final String obscuringCharacter;
  final bool obscureText;
  final Widget? prefix;
  final AppKitOverlayVisibilityMode prefixMode;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;

  bool get selectionEnabled => enableInteractiveSelection;

  const AppKitTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.padding = const EdgeInsets.all(8.0),
    this.placeholder,
    this.title,
    this.style,
    this.placeholderStyle,
    required this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.top,
    this.readOnly = false,
    this.autofocus = true,
    this.canRequestFocus = true,
    this.autocorrect = false,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.enabled = true,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.clearButtonMode = AppKitOverlayVisibilityMode.never,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.prefix,
    this.prefixMode = AppKitOverlayVisibilityMode.never,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
  })  : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled);

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
        widget.clearButtonMode != AppKitOverlayVisibilityMode.never;
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
        widget.enabled && widget.canRequestFocus;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller?.dispose();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
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
        widget.enabled && widget.canRequestFocus;
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
        return hasText;
      case AppKitOverlayVisibilityMode.notEditing:
        return !hasText;
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
    return _shouldShowAttachment(
      attachment: widget.clearButtonMode,
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

  Widget _addTextDependentAttachments({
    required Widget editableText,
    required TextStyle textStyle,
    required TextStyle placeholderStyle,
    required UiElementColorContainer colorContainer,
  }) {
    // If there are no surrounding widgets, just return the core editable text
    // part.
    if (!_hasDecoration) {
      return editableText;
    }

    Color iconsColor = colorContainer.controlTextColor;

    if (!enabled) {
      iconsColor = iconsColor.withOpacity(0.2);
    }

    // Otherwise, listen to the current state of the text entry.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      child: editableText,
      builder: (BuildContext context, TextEditingValue? text, Widget? child) {
        return Row(
          crossAxisAlignment: widget.maxLines == null || widget.maxLines! > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            // Insert a prefix at the front if the prefix visibility mode matches
            // the current text state.
            if (_showPrefixWidget(text!))
              Padding(
                padding: EdgeInsets.only(
                  top: widget.padding.top,
                  bottom: widget.padding.bottom,
                  left: 6.0,
                  right: 6.0,
                ),
                child: MacosIconTheme(
                  data: MacosIconThemeData(
                    color: iconsColor,
                    size: 16.0,
                  ),
                  child: widget.prefix!,
                ),
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
            if (_showClearButton(text))
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  key: _clearGlobalKey,
                  onTap: enabled
                      ? () {
                          // Special handle onChanged for ClearButton
                          // Also call onChanged when the clear button is tapped.
                          final bool textChanged =
                              _effectiveController.text.isNotEmpty;
                          _effectiveController.clear();
                          if (widget.onChanged != null && textChanged) {
                            widget.onChanged!(_effectiveController.text);
                          }
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 6.0,
                      right: 6.0,
                      top: widget.padding.top,
                      bottom: widget.padding.bottom,
                    ),
                    child: Icon(
                      CupertinoIcons.clear_thick_circled,
                      size: 16.0,
                      color: iconsColor,
                    ),
                  ),
                ),
              ),
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

    final theme = AppKitTheme.of(context);

    TextStyle? resolvedStyle = widget.style;
    final textStyle = theme.typography.body.merge(resolvedStyle);

    return UiElementColorBuilder(builder: (context, colorContainer) {
      final placeholderStyle = widget.placeholderStyle ??
          theme.typography.body
              .copyWith(color: colorContainer.placeholderTextColor);
      final Color selectionColor = colorContainer.selectedTextBackgroundColor;
      final Color cursorColor = widget.cursorColor ??
          (theme.brightness.isDark ? Colors.white : Colors.black);

      final Widget paddedEditable = Padding(
        padding: widget.padding,
        child: RepaintBoundary(
          child: UnmanagedRestorationScope(
            bucket: bucket,
            child: EditableText(
              key: editableTextKey,
              controller: controller,
              readOnly: widget.readOnly,
              showCursor: true, // widget.showCursor
              showSelectionHandles: _showSelectionHandles,
              focusNode: _effectiveFocusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              style: textStyle,
              strutStyle: widget.strutStyle,
              textAlign: widget.textAlign,
              autofocus: widget.autofocus,
              obscuringCharacter: widget.obscuringCharacter,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              smartDashesType: widget.smartDashesType,
              smartQuotesType: widget.smartQuotesType,
              enableSuggestions: widget.enableSuggestions,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              expands: widget.expands,
              selectionColor: selectionColor,
              selectionControls:
                  selectionEnabled ? textSelectionControls : null,
              onChanged: widget.onChanged,
              onSelectionChanged: _handleSelectionChanged,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: widget.onSubmitted,
              inputFormatters: formatters,
              rendererIgnoresPointer: true,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              // cursorRadius: widget.cursorRadius,
              cursorColor: cursorColor,
              cursorOpacityAnimates: true,
              // cursorOffset: cursorOffset,
              paintCursorAboveText: true,
              autocorrectionTextRectColor: selectionColor,
              backgroundCursorColor: const Color(
                  0x00cccccc), //AppKitColors.systemGray.resolveFrom(context),
              selectionHeightStyle: widget.selectionHeightStyle,
              selectionWidthStyle: widget.selectionWidthStyle,
              scrollPadding: widget.scrollPadding,
              // keyboardAppearance: keyboardAppearance,
              dragStartBehavior: widget.dragStartBehavior,
              scrollController: widget.scrollController,
              scrollPhysics: widget.scrollPhysics,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              autofillHints: widget.autofillHints,
              restorationId: 'editable',
              mouseCursor: SystemMouseCursors.text,
              // contextMenuBuilder: widget.contextMenuBuilder,
            ),
          ),
        ),
      );

      return Semantics(
        enabled: enabled,
        onTap: !enabled || widget.readOnly
            ? null
            : () {
                if (!controller.selection.isValid) {
                  controller.selection =
                      TextSelection.collapsed(offset: controller.text.length);
                }
                _requestKeyboard();
              },
        child: IgnorePointer(
          ignoring: !enabled,
          child: AppKitFocusContainer(
            borderRadius: 0.0,
            textField: true,
            canRequestFocus: _effectiveFocusNode.canRequestFocus && enabled,
            autofocus: widget.autofocus && enabled,
            descendantsAreFocusable: true,
            focusNode: _effectiveFocusNode,
            child: Container(
              decoration: const BoxDecoration(),
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
                    colorContainer: colorContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
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
  bool get wantKeepAlive => _controller?.value.text.isNotEmpty == true;

  @override
  bool get selectionEnabled => widget.selectionEnabled;
}

enum AppKitOverlayVisibilityMode {
  never,
  editing,
  notEditing,
  always,
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
