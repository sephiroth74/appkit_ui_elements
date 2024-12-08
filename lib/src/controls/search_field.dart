import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

final _logger = newLogger('AppKitSearchField');

class AppKitSearchField extends StatefulWidget {
  final ContextMenuBuilder<String>? contextMenuBuilder;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool autocorrect;
  final bool autofocus;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType inputType;
  final AppKitTextFieldBorderStyle borderStyle;
  final bool enabled;
  final bool continuous;
  final AppKitControlSize controlSize;
  final AppKitOverlayVisibilityMode clearButtonMode;
  final AppKitTextFieldBehavior behavior;

  const AppKitSearchField({
    super.key,
    this.contextMenuBuilder,
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
  });

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

    if (null != itemRect && widget.contextMenuBuilder != null) {
      final menu = widget.contextMenuBuilder!
          .call(context)
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
      );

      if (value?.value != null) {
        setState(() {
          _controller!.text = value!.title;
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
        ignoring: !enabled || widget.contextMenuBuilder == null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: enabled && widget.contextMenuBuilder != null
              ? _handlePrefixTap
              : null,
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.search,
                    size: widget.controlSize.prefixIconSize,
                    color: AppKitColors.labelColor
                        .resolveFrom(context)
                        .multiplyOpacity(enabled ? 1.0 : 0.5),
                  ),
                  if (widget.contextMenuBuilder != null) ...[
                    Icon(
                      CupertinoIcons.chevron_down,
                      size: widget.controlSize.prefixIconSize / 2,
                      color: AppKitColors.labelColor
                          .resolveFrom(context)
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
        return const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0);
      case AppKitControlSize.small:
        return const EdgeInsets.symmetric(horizontal: 7.0, vertical: 1.5);
      case AppKitControlSize.regular:
        return const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 1.5, bottom: 3.5);
      case AppKitControlSize.large:
        return const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 3.5, bottom: 5.5);
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
            left: 4.0, right: 2.0, top: 1.0, bottom: 2.0);
      case AppKitControlSize.large:
        return const EdgeInsets.only(
            left: 4.0, right: 2.0, top: 1.0, bottom: 2.0);
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
