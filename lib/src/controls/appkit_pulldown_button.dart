import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AppKitPulldownButton<T> extends StatefulWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final double minWidth;
  final double maxWidth;
  final AppKitMenuEdge menuEdge;
  final AppKitPulldownButtonStyle style;
  final Color? color;
  final String? title;
  final IconData? icon;
  final AppKitMenuImageAlignment imageAlignment;
  final TextAlign textAlign;
  final AppKitControlSize controlSize;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final Color? iconColor;

  const AppKitPulldownButton({
    super.key,
    required this.minWidth,
    double? maxWidth,
    this.onItemSelected,
    this.menuBuilder,
    this.color,
    this.title,
    this.icon,
    this.semanticLabel,
    this.focusNode,
    this.menuEdge = AppKitMenuEdge.bottom,
    this.style = AppKitPulldownButtonStyle.push,
    this.controlSize = AppKitControlSize.regular,
    this.canRequestFocus = false,
    this.imageAlignment = AppKitMenuImageAlignment.start,
    this.textAlign = TextAlign.start,
    this.iconColor,
  })  : assert(title != null || icon != null),
        maxWidth = maxWidth ?? minWidth;

  @override
  State<AppKitPulldownButton<T>> createState() =>
      _AppKitPulldownButtonState<T>();
}

class _AppKitPulldownButtonState<T> extends State<AppKitPulldownButton<T>>
    with SingleTickerProviderStateMixin {
  bool get enabled =>
      widget.onItemSelected != null && widget.menuBuilder != null;

  TextStyle get textStyle => AppKitTheme.of(context).typography.body;

  AppKitPulldownButtonStyle get style => widget.style;

  AppKitControlSize get controlSize => widget.controlSize;

  bool _isMenuOpened = false;

  bool _isHovered = false;

  late AppKitContextMenu<T> _contextMenu;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('canRequestFocus', widget.canRequestFocus));
    properties.add(DiagnosticsProperty('color', widget.color));
    properties.add(DiagnosticsProperty('controlSize', widget.controlSize));
    properties.add(DiagnosticsProperty('enabled', enabled));
    properties.add(DiagnosticsProperty('focusNode', widget.focusNode));
    properties.add(DiagnosticsProperty('icon', widget.icon));
    properties.add(DiagnosticsProperty('iconColor', widget.iconColor));
    properties
        .add(DiagnosticsProperty('imageAlignment', widget.imageAlignment));
    properties.add(DiagnosticsProperty('maxWidth', widget.maxWidth));
    properties.add(DiagnosticsProperty('menuBuilder', widget.menuBuilder));
    properties.add(DiagnosticsProperty('menuEdge', widget.menuEdge));
    properties.add(DiagnosticsProperty('minWidth', widget.minWidth));
    properties
        .add(DiagnosticsProperty('onItemSelected', widget.onItemSelected));
    properties.add(DiagnosticsProperty('semanticLabel', widget.semanticLabel));
    properties.add(DiagnosticsProperty('style', style));
    properties.add(DiagnosticsProperty('textAlign', widget.textAlign));
    properties.add(DiagnosticsProperty('title', widget.title));
  }

  @override
  void initState() {
    super.initState();
    _contextMenu = widget.menuBuilder!(context);
    _effectiveFocusNode.canRequestFocus = widget.canRequestFocus && enabled;
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitPulldownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _contextMenu = widget.menuBuilder!(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _defaultItemBuilder(
      {required BuildContext context, required double controlHeight}) {
    bool isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
    final popupThemeData = AppKitPopupButtonTheme.of(context);

    final iconSize = style == AppKitPulldownButtonStyle.inline
        ? popupThemeData.sizeData[controlSize]!.inlineIconsSize
        : popupThemeData.sizeData[controlSize]!.iconSize;

    final TextStyle textStyle =
        style.getTextStyle(theme: popupThemeData, controlSize: controlSize);
    Color textColor;

    if (style == AppKitPulldownButtonStyle.inline) {
      textColor = (textStyle.color ??
              AppKitDynamicColor.resolve(context, AppKitColors.labelColor))
          .multiplyOpacity(0.7);
      if (!isMainWindow) {
        textColor = textColor.multiplyOpacity(0.5);
      }
    } else {
      textColor = textStyle.color ??
          AppKitDynamicColor.resolve(context, AppKitColors.labelColor);
    }

    if (!enabled) {
      textColor = textColor.multiplyOpacity(0.5);
    }

    final MainAxisAlignment mainAxisAlignment;
    final double textSpace = popupThemeData.sizeData[controlSize]!.textPadding;
    final EdgeInsets textPadding;

    switch (widget.imageAlignment) {
      case AppKitMenuImageAlignment.leading:
        mainAxisAlignment = MainAxisAlignment.start;
        textPadding = EdgeInsets.only(left: textSpace);
        break;

      case AppKitMenuImageAlignment.trailing:
        mainAxisAlignment = MainAxisAlignment.start;
        textPadding = EdgeInsets.only(right: textSpace);
        break;

      case AppKitMenuImageAlignment.start:
        mainAxisAlignment = MainAxisAlignment.center;
        textPadding = EdgeInsets.only(left: textSpace);
        break;

      case AppKitMenuImageAlignment.end:
        mainAxisAlignment = MainAxisAlignment.center;
        textPadding = EdgeInsets.only(right: textSpace);
        break;
    }

    final textWidget = Padding(
      padding: textPadding,
      child: Text(
        widget.title ?? '',
        style: textStyle.copyWith(color: textColor),
        textAlign: widget.textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final iconWidget = widget.icon != null
        ? AppKitIcon(
            icon: widget.icon!,
            size: iconSize,
            color: widget.iconColor ?? textColor,
          )
        : null;

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (widget.icon != null &&
              (widget.imageAlignment == AppKitMenuImageAlignment.start ||
                  widget.imageAlignment == AppKitMenuImageAlignment.leading))
            iconWidget!,
          if (widget.title != null) ...[
            if (widget.imageAlignment == AppKitMenuImageAlignment.leading ||
                widget.imageAlignment == AppKitMenuImageAlignment.trailing) ...[
              Expanded(child: textWidget),
            ] else ...[
              Flexible(child: textWidget),
            ],
          ],
          if (widget.icon != null &&
              (widget.imageAlignment == AppKitMenuImageAlignment.end ||
                  widget.imageAlignment == AppKitMenuImageAlignment.trailing))
            iconWidget!,
        ],
      );
    });
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

  void _handleTap() async {
    if (!mounted) return;
    final itemRect = context.getWidgetBounds();
    if (null != itemRect && widget.menuBuilder != null) {
      final menu = _contextMenu.copyWith(
          position: _contextMenu.position ??
              widget.menuEdge.getRectPosition(itemRect));
      setState(() {
        if (_effectiveFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_effectiveFocusNode);
        }
        _isMenuOpened = true;
      });

      final value = await showContextMenu<T>(
        context,
        contextMenu: menu,
        transitionDuration: kContextMenuTrasitionDuration,
        barrierDismissible: true,
        opaque: false,
        menuEdge: widget.menuEdge,
        enableWallpaperTinting: false,
      );

      if (!mounted) return;
      setState(() {
        _isMenuOpened = false;
      });

      widget.onItemSelected?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return MouseRegion(
      onEnter: enabled ? _handleMouseEnter : null,
      onExit: enabled ? _handleMouseExit : null,
      child: GestureDetector(
        onTap: enabled ? _handleTap : null,
        child: UiElementColorBuilder(builder: (context, colorContainer) {
          final isMainWindow =
              MainWindowStateListener.instance.isMainWindow.value;
          final popupButtonTheme = AppKitPopupButtonTheme.of(context);
          final height = style.getHeight(
              theme: popupButtonTheme, controlSize: controlSize);
          final menuEdge = widget.menuEdge;

          return Focus.withExternalFocusNode(
            focusNode: _effectiveFocusNode,
            child: Builder(builder: (context) {
              final child =
                  _defaultItemBuilder(context: context, controlHeight: height);

              if (style == AppKitPulldownButtonStyle.push ||
                  style == AppKitPulldownButtonStyle.bevel) {
                return _PushButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  colorContainer: colorContainer,
                  contextMenuOpened: _isMenuOpened,
                  isMainWindow: isMainWindow,
                  style: style,
                  controlSize: controlSize,
                  color: widget.color,
                  child: child,
                );
              } else if (style == AppKitPulldownButtonStyle.plain) {
                return _PlainButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  colorContainer: colorContainer,
                  contextMenuOpened: _isMenuOpened,
                  isMainWindow: isMainWindow,
                  controlSize: controlSize,
                  isHovered: _isHovered,
                  child: child,
                );
              } else if (style == AppKitPulldownButtonStyle.inline) {
                return _InlineButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  colorContainer: colorContainer,
                  contextMenuOpened: _isMenuOpened,
                  controlSize: controlSize,
                  isMainWindow: isMainWindow,
                  isHovered: _isHovered,
                  child: child,
                );
              }

              return const SizedBox();
            }),
          );
        }),
      ),
    );
  }
}

class _PushButtonStyleWidget<T> extends StatelessWidget {
  final double minWidth;
  final double maxWidth;
  final double height;
  final AppKitMenuEdge menuEdge;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final AppKitPulldownButtonStyle style;
  final AppKitControlSize controlSize;
  final Color? color;

  const _PushButtonStyleWidget({
    super.key,
    required this.minWidth,
    required this.maxWidth,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    required this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;
    final bool isBevel = style == AppKitPulldownButtonStyle.bevel;

    Color caretBackgroundColor;
    Color arrowsColor;
    double caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final controlBackgroundColor = enabled
        ? colorContainer.controlBackgroundColor
        : colorContainer.controlBackgroundColor.multiplyOpacity(0.5);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);

    if (isBevel) {
      caretBackgroundColor = Colors.transparent;
      arrowsColor =
          AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
              .multiplyOpacity(enabledFactor);
    } else {
      caretBackgroundColor =
          color ?? popupButtonTheme.elevatedButtonColor ?? theme.activeColor;

      final carteBackgroundColorLiminance =
          caretBackgroundColor.computeLuminance();

      arrowsColor = isMainWindow && enabled
          ? carteBackgroundColorLiminance > 0.5
              ? Colors.black.withOpacity(enabledFactor)
              : Colors.white.withOpacity(enabledFactor)
          : Colors.black.withOpacity(enabledFactor);

      if (contextMenuOpened) {
        final hslColor = HSLColor.fromColor(caretBackgroundColor);
        caretBackgroundColor =
            (hslColor.withLightness(hslColor.lightness / 1.1)).toColor();
      }

      if (!enabled) {
        caretBackgroundColor = caretBackgroundColor.multiplyOpacity(0.5);
      }
    }

    return Container(
      constraints: BoxConstraints(
          minWidth: minWidth,
          minHeight: height,
          maxHeight: height,
          maxWidth: maxWidth),
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: style.getPressedBackgroundColor(
                  theme: theme, backgroundColor: controlBackgroundColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                AppKitColors.text.opaque.tertiary.multiplyOpacity(0.75),
                AppKitColors.text.opaque.secondary.multiplyOpacity(0.75)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            width: 0.5,
          ),
          boxShadow: getElevatedShadow(context, colorContainer),
        ),
        child: Padding(
          padding: style.getContainerPadding(
              theme: popupButtonTheme,
              menuEdge: menuEdge,
              controlSize: controlSize),
          child: LayoutBuilder(builder: (context, parentConstraints) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: style.getChildPadding(
                        theme: popupButtonTheme, controlSize: controlSize),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                          width: constraints.maxWidth,
                          height: parentConstraints.maxHeight,
                          child: child);
                    }),
                  ),
                ),
                SizedBox(
                  width: caretButtonSize,
                  height: caretButtonSize,
                  child: DecoratedBox(
                    decoration: isMainWindow && enabled
                        ? BoxDecoration(
                            color: caretBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(borderRadius - 1),
                            boxShadow: isBevel
                                ? null
                                : [
                                    BoxShadow(
                                      color: colorContainer.controlAccentColor
                                          .withOpacity(0.06),
                                      blurRadius: 1.5,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0, 0.5),
                                    ),
                                    BoxShadow(
                                      offset: const Offset(0.0, 1.0),
                                      blurRadius: 1.0,
                                      spreadRadius: 0.0,
                                      color: colorContainer.controlAccentColor
                                          .withOpacity(0.06),
                                    ),
                                    BoxShadow(
                                      offset: const Offset(0.0, 0.5),
                                      blurRadius: 0.5,
                                      spreadRadius: 0.0,
                                      color: colorContainer.controlAccentColor
                                          .withOpacity(0.12),
                                    )
                                  ])
                        : const BoxDecoration(),
                    child: DecoratedBox(
                      decoration: isMainWindow && !isBevel
                          ? BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(borderRadius - 1),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.17),
                                  Colors.white.withOpacity(0.0),
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
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _PlainButtonStyleWidget<T> extends StatelessWidget {
  final double minWidth;
  final double maxWidth;
  final double height;
  final AppKitMenuEdge menuEdge;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isHovered;
  final AppKitPulldownButtonStyle style = AppKitPulldownButtonStyle.plain;
  final AppKitControlSize controlSize;

  const _PlainButtonStyleWidget({
    super.key,
    required this.minWidth,
    required this.maxWidth,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;

    final Color controlBackgroundColor;
    final Color caretBackgroundColor;
    final caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    final arrowsColor =
        AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
            .multiplyOpacity(enabledFactor);

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
      controlBackgroundColor = colorContainer.controlBackgroundColor;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : popupButtonTheme.plainButtonColor.multiplyOpacity(enabledFactor);
      controlBackgroundColor = Colors.transparent;
    }

    return Container(
      constraints: BoxConstraints(
          minWidth: minWidth,
          minHeight: height,
          maxHeight: height,
          maxWidth: maxWidth),
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: style.getPressedBackgroundColor(
                  theme: theme,
                  backgroundColor: colorContainer.controlBackgroundColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: isHovered
              ? GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      AppKitColors.text.opaque.tertiary.multiplyOpacity(0.75),
                      AppKitColors.text.opaque.secondary.multiplyOpacity(0.75)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 0.5,
                )
              : null,
          boxShadow:
              isHovered ? getElevatedShadow(context, colorContainer) : null,
        ),
        child: Padding(
          padding: style.getContainerPadding(
              theme: popupButtonTheme,
              menuEdge: menuEdge,
              controlSize: controlSize),
          child: LayoutBuilder(builder: (context, parentConstraints) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: style.getChildPadding(
                        theme: popupButtonTheme, controlSize: controlSize),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                          width: constraints.maxWidth,
                          height: parentConstraints.maxHeight,
                          child: child);
                    }),
                  ),
                ),
                SizedBox(
                  width: caretButtonSize,
                  height: caretButtonSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: caretBackgroundColor,
                      borderRadius: BorderRadius.circular(borderRadius - 1),
                    ),
                    child: Center(
                      child: SizedBox.expand(
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
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _InlineButtonStyleWidget<T> extends StatelessWidget {
  final double minWidth;
  final double maxWidth;
  final double height;
  final AppKitMenuEdge menuEdge;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isHovered;
  final AppKitPulldownButtonStyle style = AppKitPulldownButtonStyle.inline;
  final AppKitControlSize controlSize;

  const _InlineButtonStyleWidget({
    super.key,
    required this.minWidth,
    required this.maxWidth,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabledFactor = enabled ? 0.5 : 0.35;
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);

    final Color controlBackgroundColor;
    final caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final arrowsColor =
        AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
            .multiplyOpacity(isMainWindow ? enabledFactor : 0.35);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);

    if (isHovered) {
      controlBackgroundColor = popupButtonTheme
              .sizeData[controlSize]?.inlineHoveredBackgroundColor ??
          Colors.black.withOpacity(0.2);
    } else {
      controlBackgroundColor =
          popupButtonTheme.sizeData[controlSize]?.inlineBackgroundColor ??
              Colors.black.withOpacity(0.05);
    }

    return Container(
      constraints: BoxConstraints(
          minWidth: minWidth,
          minHeight: height,
          maxHeight: height,
          maxWidth: maxWidth),
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: popupButtonTheme
                      .sizeData[controlSize]?.inlinePressedBackgroundColor ??
                  style.getPressedBackgroundColor(
                      theme: theme, backgroundColor: controlBackgroundColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: style.getContainerPadding(
            theme: popupButtonTheme,
            menuEdge: menuEdge,
            controlSize: controlSize),
        child: LayoutBuilder(builder: (context, parentConstraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: style.getChildPadding(
                      theme: popupButtonTheme, controlSize: controlSize),
                  child: SizedBox(
                    width: parentConstraints.maxWidth,
                    height: parentConstraints.maxHeight,
                    child: child,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
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
              )
            ],
          );
        }),
      ),
    );
  }
}

@protected
extension AppKitPulldownButtonStyleX on AppKitPulldownButtonStyle {
  EdgeInsets getContainerPadding({
    required AppKitPopupButtonThemeData theme,
    required AppKitMenuEdge menuEdge,
    required AppKitControlSize controlSize,
  }) {
    final paddings = (this == AppKitPulldownButtonStyle.inline)
        ? theme.sizeData[controlSize]!.inlineContainerPadding
        : theme.sizeData[controlSize]!.containerPadding;
    if (menuEdge.isLeft) {
      return paddings.invertHorizontally();
    } else {
      return paddings;
    }
  }

  EdgeInsetsGeometry getChildPadding({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPulldownButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineChildPadding;
      default:
        return theme.sizeData[controlSize]!.childPadding;
    }
  }

  double getCaretButtonSize({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsButtonSize;
  }

  Size getCaretSize({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsSize;
  }

  double getCaretStrokeWidth({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsStrokeWidth;
  }

  double getBorderRadius({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPulldownButtonStyle.push:
      case AppKitPulldownButtonStyle.bevel:
      case AppKitPulldownButtonStyle.plain:
        return theme.sizeData[controlSize]!.borderRadius;
      case AppKitPulldownButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineBorderRadius;
    }
  }

  double getHeight({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPulldownButtonStyle.push:
      case AppKitPulldownButtonStyle.bevel:
      case AppKitPulldownButtonStyle.plain:
        return theme.sizeData[controlSize]!.height;
      case AppKitPulldownButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineHeight;
    }
  }

  Color getPressedBackgroundColor(
      {required AppKitThemeData theme, required Color backgroundColor}) {
    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      backgroundColor,
      backgroundColor.opacity,
    )!;

    final luminance = blendedBackgroundColor.computeLuminance();
    final color = luminance > 0.5
        ? AppKitColors.controlBackgroundPressedColor.color
        : AppKitColors.controlBackgroundPressedColor.darkColor;
    return color;
  }

  TextStyle getTextStyle({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPulldownButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineTextStyle;
      default:
        return theme.sizeData[controlSize]!.textStyle;
    }
  }
}
