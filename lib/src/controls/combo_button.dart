import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AppKitComboButton<T> extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final Widget child;
  final AppKitControlSize controlSize;
  final ContextMenuBuilder<T>? menuBuilder;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final AppKitComboButtonStyle style;

  const AppKitComboButton({
    super.key,
    this.padding,
    this.onPressed,
    this.onItemSelected,
    this.semanticLabel,
    this.menuBuilder,
    this.controlSize = AppKitControlSize.regular,
    this.style = AppKitComboButtonStyle.split,
    required this.child,
  });

  @override
  State<AppKitComboButton<T>> createState() => _AppKitComboButtonState<T>();
}

class _AppKitComboButtonState<T> extends State<AppKitComboButton<T>> {
  bool get enabled => widget.onPressed != null && widget.menuBuilder != null;

  bool _isContextMenuOpened = false;
  bool _isSplitButtonHeldDown = false;
  bool _isButtonHeldDown = false;

  bool get isDown => _isSplitButtonHeldDown || _isButtonHeldDown || _isContextMenuOpened;

  set isContextMenuOpened(bool value) {
    if (value != _isContextMenuOpened) {
      setState(() {
        _isContextMenuOpened = value;
        if (!value) {
          _isSplitButtonHeldDown = false;
          _isButtonHeldDown = false;
        }
      });
    }
  }

  void _handleButtonTapDown() {
    setState(() {
      _isButtonHeldDown = true;
    });
  }

  void _handleButtonTapUp() {
    setState(() {
      _isButtonHeldDown = false;
    });
    widget.onPressed?.call();
  }

  void _handleButtonTapCancel() {
    setState(() {
      _isButtonHeldDown = false || _isContextMenuOpened;
    });
  }

  void _handleButtonLongPress() {
    setState(() {
      _isButtonHeldDown = true;
    });
    _showContextMenu(context.getWidgetBounds());
  }

  void _handleSplitTapDown(Rect? bounds) {
    setState(() {
      _isSplitButtonHeldDown = true;
    });
    _showContextMenu(bounds);
  }

  void _handleSplitTapUp() {
    setState(() {
      _isSplitButtonHeldDown = false;
    });
  }

  void _handleSplitTapCancel() {
    setState(() {
      _isSplitButtonHeldDown = false || _isContextMenuOpened;
    });
  }

  void _showContextMenu(Rect? bounds) async {
    if (widget.menuBuilder != null) {
      final itemRect = bounds ?? context.getWidgetBounds();
      if (null != itemRect && widget.menuBuilder != null) {
        final contextMenu = widget.menuBuilder!(context);
        final menu =
            contextMenu.copyWith(position: contextMenu.position ?? AppKitMenuEdge.auto.getRectPosition(itemRect));

        isContextMenuOpened = true;

        final value = await showContextMenu<T>(
          context,
          contextMenu: menu,
          transitionDuration: kContextMenuTrasitionDuration,
          barrierDismissible: true,
          opaque: false,
        );

        isContextMenuOpened = false;

        widget.onItemSelected?.call(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: enabled,
      child: UiElementColorBuilder(
        builder: (context, colorContainer) {
          final isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
          final comboButtonTheme = AppKitComboButtonTheme.of(context);
          final themeData = comboButtonTheme.get(widget.controlSize);

          return ConstrainedBox(
            constraints: BoxConstraints(minWidth: themeData.buttonSize.width, maxHeight: themeData.buttonSize.height),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(themeData.borderRadius),
                  color: enabled
                      ? colorContainer.controlBackgroundColor
                      : colorContainer.controlBackgroundColor.multiplyOpacity(0.5),
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        AppKitColors.text.opaque.tertiary.multiplyOpacity(0.5),
                        AppKitColors.text.opaque.secondary.multiplyOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurStyle: BlurStyle.outer,
                      color: colorContainer.shadowColor.withOpacity(0.15),
                      blurRadius: 0.25,
                      spreadRadius: 0.0,
                      offset: const Offset(0, 0.25),
                    ),
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ButtonWidget(
                      padding: widget.padding,
                      height: themeData.buttonSize.height,
                      controlSize: widget.controlSize,
                      style: widget.style,
                      colorContainer: colorContainer,
                      enabled: enabled,
                      isMainWindow: isMainWindow,
                      onTapDown: _handleButtonTapDown,
                      onTapUp: _handleButtonTapUp,
                      onTapCancel: _handleButtonTapCancel,
                      onLongPress: widget.style == AppKitComboButtonStyle.unified ? _handleButtonLongPress : null,
                      isDown: _isButtonHeldDown,
                      themeData: themeData,
                      child: widget.child),
                  if (widget.style == AppKitComboButtonStyle.split) ...[
                    VerticalDivider(
                      indent: isDown ? 0.0 : 4.0,
                      endIndent: isDown ? 0.0 : 4.0,
                      width: 1,
                      thickness: 1,
                      color: AppKitColors.text.opaque.tertiary.multiplyOpacity(0.5),
                    ),
                    _SplitButton(
                        width: themeData.buttonSize.height - 4,
                        height: themeData.buttonSize.height,
                        colorContainer: colorContainer,
                        enabled: enabled,
                        isMainWindow: isMainWindow,
                        onTapUp: _handleSplitTapUp,
                        onTapDown: _handleSplitTapDown,
                        onTapCancel: _handleSplitTapCancel,
                        themeData: themeData,
                        isDown: _isSplitButtonHeldDown),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', widget.padding));
    properties.add(DiagnosticsProperty<String>('semanticLabel', widget.semanticLabel));
    properties.add(DiagnosticsProperty<AppKitControlSize>('controlSize', widget.controlSize));
    properties.add(DiagnosticsProperty<Widget>('child', widget.child));
    properties.add(DiagnosticsProperty<ContextMenuBuilder>('menuBuilder', widget.menuBuilder));
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', widget.onPressed, ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<AppKitContextMenuItem<T>?>>('onItemSelected', widget.onItemSelected,
        ifNull: 'disabled'));
    properties.add(EnumProperty<AppKitComboButtonStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<bool>('isDown', isDown));
  }
}

class _SplitButton extends StatelessWidget {
  final double width;
  final double height;
  final UiElementColorContainer colorContainer;
  final bool enabled;
  final bool isMainWindow;
  final ValueChanged<Rect?> onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final bool isDown;
  final AppKitComboButtonThemeDataSize themeData;

  const _SplitButton({
    required this.width,
    required this.height,
    required this.colorContainer,
    required this.enabled,
    required this.isMainWindow,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.isDown,
    required this.themeData,
  });

  void _handleTapDown(BuildContext context, TapDownDetails details) {
    onTapDown.call(context.getWidgetBounds());
  }

  void _handleTap() {
    onTapUp.call();
  }

  void _handleTapCancel() {
    onTapCancel.call();
  }

  @override
  Widget build(BuildContext context) {
    Color? controlBackgroundColor;
    if (enabled && isDown) {
      final hslColor = HSLColor.fromColor(colorContainer.controlBackgroundColor);
      controlBackgroundColor = (hslColor.withLightness(hslColor.lightness / 1.1)).toColor();
    }

    return GestureDetector(
      onTap: enabled ? _handleTap : null,
      onTapDown: enabled ? (e) => _handleTapDown(context, e) : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      child: DecoratedBox(
        decoration: enabled && isDown
            ? BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(themeData.borderRadius),
                  bottomRight: Radius.circular(themeData.borderRadius),
                ),
                color: controlBackgroundColor,
              )
            : const BoxDecoration(),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.chevron_right,
                size: width * 0.75,
                color: enabled ? colorContainer.textColor : colorContainer.textColor.multiplyOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final Widget child;
  final AppKitControlSize controlSize;
  final AppKitComboButtonStyle style;
  final UiElementColorContainer colorContainer;
  final bool enabled;
  final bool isMainWindow;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final VoidCallback? onLongPress;
  final bool isDown;
  final double height;
  final EdgeInsetsGeometry? padding;
  final AppKitComboButtonThemeDataSize themeData;

  const _ButtonWidget({
    required this.controlSize,
    required this.style,
    required this.child,
    required this.colorContainer,
    required this.enabled,
    required this.isMainWindow,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.isDown,
    required this.height,
    required this.themeData,
    this.onLongPress,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color? controlBackgroundColor;
    if (enabled && isDown) {
      final hslColor = HSLColor.fromColor(colorContainer.controlBackgroundColor);
      controlBackgroundColor = (hslColor.withLightness(hslColor.lightness / 1.1)).toColor();
    }

    return GestureDetector(
      onTapDown: enabled ? (_) => onTapDown.call() : null,
      onTap: enabled ? onTapUp : null,
      onTapCancel: enabled ? onTapCancel : null,
      onLongPress: enabled && onLongPress != null ? onLongPress : null,
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: enabled && isDown
              ? BoxDecoration(
                  borderRadius: style == AppKitComboButtonStyle.split
                      ? BorderRadius.only(
                          topLeft: Radius.circular(themeData.borderRadius),
                          bottomLeft: Radius.circular(themeData.borderRadius),
                        )
                      : BorderRadius.circular(themeData.borderRadius),
                  color: controlBackgroundColor,
                )
              : const BoxDecoration(),
          child: Padding(
            padding: themeData.padding.add(padding ?? EdgeInsets.zero),
            child: Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              alignment: Alignment.center,
              child: Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: DefaultTextStyle(
                  style: AppKitTheme.of(context).typography.body.copyWith(fontSize: themeData.fontSize),
                  child: FittedBox(
                    child: child,
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

enum AppKitComboButtonStyle { split, unified }
