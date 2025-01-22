import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// A custom search field widget for the AppKit UI library.
///
/// This widget provides a search input field with additional functionality
/// and customization options.
///
/// To use this widget, simply include it in your widget tree and provide
/// any necessary parameters.
///
/// Example usage:
///
/// ```dart
/// AppKitSearchField(
///   // Add your parameters here
/// )
/// ```
///
/// This widget is stateful, meaning it maintains its own state and can
/// update dynamically based on user input or other interactions.
class AppKitSearchField extends StatefulWidget {
  /// A builder function for creating a custom context menu for the search field.
  final ContextMenuBuilder<String>? contextMenuBuilder;

  /// A list of suggestions to display in the search field.
  final List<String>? suggestions;

  /// A controller for the text being edited.
  final TextEditingController? controller;

  /// A focus node for managing the focus of the search field.
  final FocusNode? focusNode;

  /// The padding around the search field.
  final EdgeInsets? padding;

  /// A placeholder text to display when the search field is empty.
  final String? placeholder;

  /// The style to use for the placeholder text.
  final TextStyle? placeholderStyle;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether the search field should automatically get focus when the widget is built.
  final bool autofocus;

  /// The maximum number of characters that can be entered.
  final int? maxLength;

  /// The enforcement strategy for the maximum length limit.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Called when the text being edited changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the text.
  final ValueChanged<String>? onSubmitted;

  /// Called when the user finishes editing the text.
  final VoidCallback? onEditingComplete;

  /// Called when the search field is tapped.
  final GestureTapCallback? onTap;

  /// A list of [TextInputFormatter]s that will be applied to the input field.
  /// This can be used to restrict or format the text input.
  final List<TextInputFormatter>? inputFormatters;

  /// The type of keyboard to use for text input. This can be used to specify
  /// different keyboard layouts, such as numeric or email keyboards.
  final TextInputType inputType;

  /// The style of the border around the text field. This can be used to customize
  /// the appearance of the text field's border.
  final AppKitTextFieldBorderStyle borderStyle;

  /// Whether the text field is enabled or disabled. If false, the text field
  /// will be read-only and not respond to user input.
  final bool enabled;

  /// Whether the text field should continuously update its value as the user
  /// types. If false, the value will only be updated when the user finishes
  /// editing.
  final bool continuous;

  /// The size of the control. This can be used to adjust the overall size of
  /// the text field, such as making it larger or smaller.
  final AppKitControlSize controlSize;

  /// The visibility mode of the clear button. This can be used to control when
  /// the clear button is shown, such as always, while editing, or never.
  final AppKitOverlayVisibilityMode clearButtonMode;

  /// The behavior of the text field. This can be used to customize how the text
  /// field behaves in different situations, such as when it gains or loses focus.
  final AppKitTextFieldBehavior behavior;

  /// Creates an instance of [AppKitSearchField].
  ///
  /// This widget provides a search field with customizable properties.
  ///
  /// Example usage:
  /// ```dart
  /// AppKitSearchField(
  ///   // Add your parameters here
  /// );
  /// ```
  ///
  /// You can customize the appearance and behavior of the search field
  /// by providing the appropriate parameters.
  const AppKitSearchField({
    super.key,
    this.contextMenuBuilder,
    this.suggestions,
    this.controller,
    this.focusNode,
    this.padding,
    this.placeholder = 'Search...',
    this.placeholderStyle,
    this.style,
    this.textAlign = TextAlign.start,
    this.autocorrect = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.inputFormatters,
    this.enabled = true,
    this.continuous = false,
    this.inputType = TextInputType.text,
    this.borderStyle = AppKitTextFieldBorderStyle.rounded,
    this.controlSize = AppKitControlSize.regular,
    this.clearButtonMode = AppKitOverlayVisibilityMode.editing,
    this.behavior = AppKitTextFieldBehavior.editable,
  }) : assert(contextMenuBuilder != null ? suggestions == null : true,
            'Suggestions must be null when contextMenuBuilder is provided');

  bool get hasSuggestions =>
      (suggestions != null && suggestions!.isNotEmpty) ||
      contextMenuBuilder != null;

  AppKitContextMenu<String>? _defaultMenuBuilder(BuildContext context) {
    return contextMenuBuilder != null
        ? contextMenuBuilder?.call(context)
        : suggestions != null
            ? AppKitContextMenu<String>(
                entries: suggestions!
                    .map(
                        (e) => AppKitContextMenuItem<String>.plain(e, value: e))
                    .toList())
            : null;
  }

  @override
  State<AppKitSearchField> createState() => _AppKitSearchFieldState();
}

class _AppKitSearchFieldState extends State<AppKitSearchField> {
  FocusNode? _focusNode;
  TextEditingController? _controller;

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  bool get enabled => widget.enabled;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    } else {
      _focusNode = FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller!.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handlePrefixTap() async {
    final itemRect = context.getWidgetBounds();

    if (null != itemRect && widget.hasSuggestions) {
      final menu = widget
          ._defaultMenuBuilder(context)!
          .copyWith(position: AppKitMenuEdge.auto.getRectPosition(itemRect));

      setState(() {
        if (_focusNode!.canRequestFocus) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
        //_isMenuOpened = true;
      });

      final value = await showContextMenu<String>(
        context,
        contextMenu: menu,
        transitionDuration: kContextMenuTrasitionDuration,
        barrierDismissible: true,
        opaque: false,
        menuEdge: AppKitMenuEdge.auto,
        enableWallpaperTinting: false,
      );

      if (value?.value != null) {
        setState(() {
          _controller!.text = value!.value!;
          _controller!.selectAll();
          FocusScope.of(context).requestFocus(_focusNode);

          widget.onChanged?.call(_controller!.text);
          widget.onSubmitted?.call(_controller!.text);

          // _isMenuOpened = false;
        });
      }

      // widget.onItemSelected?.call(value);
    }
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  void _handleEditingComplete() {
    widget.onEditingComplete?.call();
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call(value);
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return AppKitTextField(
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      behavior: widget.behavior,
      borderStyle: widget.borderStyle,
      clearButtonMode: widget.clearButtonMode,
      continuous: widget.continuous,
      controller: _controller,
      enabled: enabled,
      focusNode: _focusNode,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.inputType,
      maxLength: widget.maxLength,
      maxLengthEnforcement: _effectiveMaxLengthEnforcement,
      maxLines: 1,
      onChanged: _handleChanged,
      onEditingComplete: enabled ? _handleEditingComplete : null,
      onSubmitted: enabled ? _handleSubmitted : null,
      onTap: enabled ? _handleTap : null,
      padding: widget.padding ?? widget.controlSize.padding,
      placeholder: widget.placeholder,
      placeholderStyle: widget.controlSize.textStyle,
      prefixMode: AppKitOverlayVisibilityMode.always,
      prefixPadding: widget.controlSize.prefixPadding,
      style: widget.controlSize.textStyle,
      textAlign: widget.textAlign,
      prefix: IgnorePointer(
        ignoring: !enabled || !widget.hasSuggestions,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: enabled && widget.hasSuggestions ? _handlePrefixTap : null,
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.search,
                    size: widget.controlSize.prefixIconSize,
                    color: AppKitDynamicColor.resolve(
                            context, AppKitColors.labelColor)
                        .multiplyOpacity(enabled ? 1.0 : 0.5),
                  ),
                  if (widget.hasSuggestions) ...[
                    Icon(
                      CupertinoIcons.chevron_down,
                      size: widget.controlSize.prefixIconSize / 2,
                      color: AppKitDynamicColor.resolve(
                              context, AppKitColors.labelColor)
                          .multiplyOpacity(enabled ? 1.0 : 0.5),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<FocusNode>('focusNode', widget.focusNode));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'controller', widget.controller));
    properties.add(IterableProperty<TextInputFormatter>(
        'inputFormatters', widget.inputFormatters));
    properties.add(DiagnosticsProperty<bool>('enabled', widget.enabled));
    properties.add(DiagnosticsProperty<bool>('autoFocus', widget.autofocus));
    properties
        .add(DiagnosticsProperty<bool>('autoCorrect', widget.autocorrect));
    properties.add(DiagnosticsProperty<bool>('continuous', widget.continuous));
    properties.add(DiagnosticsProperty<int>('maxLength', widget.maxLength));
    properties.add(DiagnosticsProperty<MaxLengthEnforcement>(
        'maxLengthEnforcement', widget.maxLengthEnforcement));
    properties
        .add(DiagnosticsProperty<TextAlign>('textAlign', widget.textAlign));
    properties.add(DiagnosticsProperty<TextStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<TextStyle>(
        'placeholderStyle', widget.placeholderStyle));
    properties
        .add(DiagnosticsProperty<String>('placeholder', widget.placeholder));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', widget.padding));
    properties
        .add(DiagnosticsProperty<TextInputType>('inputType', widget.inputType));
    properties.add(DiagnosticsProperty<AppKitTextFieldBorderStyle>(
        'borderStyle', widget.borderStyle));
    properties.add(DiagnosticsProperty<AppKitControlSize>(
        'controlSize', widget.controlSize));
    properties.add(DiagnosticsProperty<AppKitOverlayVisibilityMode>(
        'clearButtonMode', widget.clearButtonMode));
    properties.add(DiagnosticsProperty<AppKitTextFieldBehavior>(
        'behavior', widget.behavior));
  }
}

extension _ControlSizeX on AppKitControlSize {
  EdgeInsets get padding {
    switch (this) {
      case AppKitControlSize.mini:
        return const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5);
      case AppKitControlSize.small:
        return const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0);
      case AppKitControlSize.regular:
        return const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 6);
      case AppKitControlSize.large:
        return const EdgeInsets.only(left: 8.0, right: 8.0, top: 7, bottom: 8);
    }
  }

  EdgeInsets get prefixPadding {
    switch (this) {
      case AppKitControlSize.mini:
        return const EdgeInsets.only(
            left: 4.0, right: 2.0, top: 1.0, bottom: 1.0);
      case AppKitControlSize.small:
        return const EdgeInsets.only(
            left: 4.0, right: 3.0, top: 1.0, bottom: 1.0);
      case AppKitControlSize.regular:
        return const EdgeInsets.only(
            left: 6.0, right: 2.0, top: 1.0, bottom: 2.0);
      case AppKitControlSize.large:
        return const EdgeInsets.only(
            left: 6.0, right: 2.0, top: 1.0, bottom: 2.0);
    }
  }

  double get prefixIconSize {
    switch (this) {
      case AppKitControlSize.mini:
        return 11.0;
      case AppKitControlSize.small:
        return 12.0;
      case AppKitControlSize.regular:
        return 16.0;
      case AppKitControlSize.large:
        return 16.0;
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
