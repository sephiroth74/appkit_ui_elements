import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

/// A custom combo button widget with customizable properties.
///
/// The [AppKitComboButton] widget allows users to create a button with an attached
/// context menu. The appearance and behavior of the combo button can be customized
/// using various properties.
///
/// Example usage:
/// ```dart
/// AppKitComboButton(
///   child: Text('Press me'),
///   onPressed: () {
///     print('Button pressed');
///   },
///   menuBuilder: (context) => <AppKitContextMenuItem<String>>[
///     AppKitContextMenuItem<String>(
///       value: 'Option 1',
///       child: Text('Option 1'),
///     ),
///     AppKitContextMenuItem<String>(
///       value: 'Option 2',
///       child: Text('Option 2'),
///     ),
///   ],
///   onItemSelected: (item) {
///     print('Selected item: ${item?.value}');
///   },
/// )
/// ```
class AppKitComboButton<T> extends StatefulWidget {
  /// The padding inside the button.
  ///
  /// If null, a default padding will be used.
  final EdgeInsetsGeometry? padding;

  /// Called when the button is pressed.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The semantic label for the button.
  ///
  /// Used by accessibility tools to describe the button.
  final String? semanticLabel;

  /// The widget to display inside the button.
  ///
  /// Typically a [Text] or [Icon] widget.
  final Widget child;

  /// The size of the control.
  ///
  /// Determines the overall dimensions of the combo button.
  final AppKitControlSize controlSize;

  /// The builder for the context menu.
  ///
  /// If null, no context menu will be displayed.
  final ContextMenuBuilder<T>? menuBuilder;

  /// Called when the user selects an item from the context menu.
  ///
  /// If null, the context menu will be disabled.
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;

  /// The style of the combo button.
  ///
  /// Determines the visual appearance of the combo button.
  /// Defaults to [AppKitComboButtonStyle.split].
  final AppKitComboButtonStyle style;

  /// Creates an [AppKitComboButton] widget.
  ///
  /// The [child] parameter must not be null.
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

  bool get isDown =>
      _isSplitButtonHeldDown || _isButtonHeldDown || _isContextMenuOpened;

  bool get isDark => AppKitTheme.of(context).brightness == Brightness.dark;

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
        final menu = contextMenu.copyWith(
            position: contextMenu.position ??
                AppKitMenuEdge.auto.getRectPosition(itemRect));

        isContextMenuOpened = true;

        final value = await showContextMenu<T>(
          context,
          contextMenu: menu,
          transitionDuration: kContextMenuTrasitionDuration,
          barrierDismissible: true,
          opaque: false,
          enableWallpaperTinting: false,
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
      child: Consumer<MainWindowModel>(builder: (context, model, _) {
        final isMainWindow = model.isMainWindow;
        final theme = AppKitTheme.of(context);
        final comboButtonTheme = AppKitComboButtonTheme.of(context);
        final comboButtonThemeDataSize =
            comboButtonTheme.get(widget.controlSize);

        return Builder(
          builder: (context) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: comboButtonThemeDataSize.buttonSize.width,
                  maxHeight: comboButtonThemeDataSize.buttonSize.height),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        comboButtonThemeDataSize.borderRadius),
                    color: enabled
                        ? theme.controlColor
                        : theme.controlColor.multiplyOpacity(0.5),
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppKitDynamicColor.resolve(context,
                                        AppKitColors.text.opaque.primary)
                                    .multiplyOpacity(0.5),
                                AppKitDynamicColor.resolve(context,
                                        AppKitColors.text.opaque.quaternary)
                                    .multiplyOpacity(0.0)
                              ]
                            : [
                                AppKitDynamicColor.resolve(context,
                                        AppKitColors.text.opaque.tertiary)
                                    .multiplyOpacity(0.5),
                                AppKitDynamicColor.resolve(context,
                                        AppKitColors.text.opaque.secondary)
                                    .multiplyOpacity(0.5)
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                      ),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppKitColors.shadowColor.color
                            .withValues(alpha: isDark ? 0.75 : 0.15),
                        blurRadius: 0.5,
                        spreadRadius: 0,
                        offset: const Offset(0, 0.5),
                        blurStyle: BlurStyle.outer,
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: _ButtonWidget(
                              padding: widget.padding,
                              height:
                                  comboButtonThemeDataSize.buttonSize.height,
                              controlSize: widget.controlSize,
                              style: widget.style,
                              enabled: enabled,
                              isMainWindow: isMainWindow,
                              onTapDown: _handleButtonTapDown,
                              onTapUp: _handleButtonTapUp,
                              onTapCancel: _handleButtonTapCancel,
                              onLongPress:
                                  widget.style == AppKitComboButtonStyle.unified
                                      ? _handleButtonLongPress
                                      : null,
                              isDown: _isButtonHeldDown,
                              comboButtonTheme: comboButtonThemeDataSize,
                              theme: theme,
                              child: widget.child)),
                      if (widget.style == AppKitComboButtonStyle.split) ...[
                        VerticalDivider(
                          indent: isDown
                              ? 0.0
                              : (comboButtonThemeDataSize.buttonSize.height /
                                      5) +
                                  1,
                          endIndent: isDown
                              ? 0.0
                              : (comboButtonThemeDataSize.buttonSize.height /
                                      5) +
                                  1,
                          width: 0.5,
                          thickness: 0.5,
                          color: AppKitColors.text.opaque.secondary
                              .multiplyOpacity(0.8),
                        ),
                        _SplitButton(
                            width:
                                comboButtonThemeDataSize.buttonSize.height - 5,
                            height: comboButtonThemeDataSize.buttonSize.height,
                            enabled: enabled,
                            isMainWindow: isMainWindow,
                            onTapUp: _handleSplitTapUp,
                            onTapDown: _handleSplitTapDown,
                            onTapCancel: _handleSplitTapCancel,
                            comboButtonThemeDataSize: comboButtonThemeDataSize,
                            themeData: theme,
                            isDown: _isSplitButtonHeldDown),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(
        DiagnosticsProperty<EdgeInsetsGeometry>('padding', widget.padding));
    properties.add(
        DiagnosticsProperty<String>('semanticLabel', widget.semanticLabel));
    properties.add(DiagnosticsProperty<AppKitControlSize>(
        'controlSize', widget.controlSize));
    properties.add(DiagnosticsProperty<Widget>('child', widget.child));
    properties.add(DiagnosticsProperty<ContextMenuBuilder>(
        'menuBuilder', widget.menuBuilder));
    properties.add(ObjectFlagProperty<VoidCallback>(
        'onPressed', widget.onPressed,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<AppKitContextMenuItem<T>?>>(
        'onItemSelected', widget.onItemSelected,
        ifNull: 'disabled'));
    properties.add(EnumProperty<AppKitComboButtonStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<bool>('isDown', isDown));
  }
}

class _SplitButton extends StatelessWidget {
  final double width;
  final double height;
  final bool enabled;
  final bool isMainWindow;
  final ValueChanged<Rect?> onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final bool isDown;
  final AppKitComboButtonThemeDataSize comboButtonThemeDataSize;
  final AppKitThemeData themeData;

  const _SplitButton({
    required this.width,
    required this.height,
    required this.enabled,
    required this.isMainWindow,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.isDown,
    required this.comboButtonThemeDataSize,
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
      controlBackgroundColor =
          themeData.controlColor.multiplyLuminance(0.9).withValues(alpha: 0.5);
    }

    return GestureDetector(
      onTap: enabled ? _handleTap : null,
      onTapDown: enabled ? (e) => _handleTapDown(context, e) : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      child: DecoratedBox(
        decoration: enabled && isDown
            ? BoxDecoration(
                backgroundBlendMode: BlendMode.darken,
                borderRadius: BorderRadius.only(
                  topRight:
                      Radius.circular(comboButtonThemeDataSize.borderRadius),
                  bottomRight:
                      Radius.circular(comboButtonThemeDataSize.borderRadius),
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
                size: width * 0.65,
                color:
                    AppKitDynamicColor.resolve(context, AppKitColors.textColor)
                        .multiplyOpacity(enabled ? 1.0 : 0.5),
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
  final bool enabled;
  final bool isMainWindow;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final VoidCallback? onLongPress;
  final bool isDown;
  final double height;
  final EdgeInsetsGeometry? padding;
  final AppKitComboButtonThemeDataSize comboButtonTheme;
  final AppKitThemeData theme;

  const _ButtonWidget({
    required this.controlSize,
    required this.style,
    required this.child,
    required this.enabled,
    required this.isMainWindow,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.isDown,
    required this.height,
    required this.comboButtonTheme,
    required this.theme,
    this.onLongPress,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color? controlBackgroundColor;
    if (enabled && isDown) {
      controlBackgroundColor =
          theme.controlColor.multiplyLuminance(0.9).withValues(alpha: 0.5);
    }

    return GestureDetector(
      onTapDown: enabled ? (_) => onTapDown.call() : null,
      onTap: enabled ? onTapUp : null,
      onTapCancel: enabled ? onTapCancel : null,
      onLongPress: enabled && onLongPress != null ? onLongPress : null,
      child: Builder(builder: (context) {
        return IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height,
              maxHeight: height,
              minWidth: comboButtonTheme.buttonSize.width,
            ),
            child: DecoratedBox(
              decoration: enabled && isDown
                  ? BoxDecoration(
                      backgroundBlendMode: BlendMode.darken,
                      borderRadius: style == AppKitComboButtonStyle.split
                          ? BorderRadius.only(
                              topLeft: Radius.circular(
                                  comboButtonTheme.borderRadius),
                              bottomLeft: Radius.circular(
                                  comboButtonTheme.borderRadius),
                            )
                          : BorderRadius.circular(
                              comboButtonTheme.borderRadius),
                      color: controlBackgroundColor,
                    )
                  : const BoxDecoration(),
              child: Padding(
                padding:
                    comboButtonTheme.padding.add(padding ?? EdgeInsets.zero),
                child: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: enabled ? 1.0 : 0.5,
                    child: DefaultTextStyle(
                      style: AppKitTheme.of(context)
                          .typography
                          .body
                          .copyWith(fontSize: comboButtonTheme.fontSize),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

enum AppKitComboButtonStyle { split, unified }
