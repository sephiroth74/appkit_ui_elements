import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kContextMenuTrasitionDuration = Duration(milliseconds: 200);

typedef ContextMenuBuilder<T> = AppKitContextMenu<T> Function(
    BuildContext context);
typedef SelectedItemBuilder<T> = Widget Function(
    BuildContext context, AppKitContextMenuItem<T>? value);

List<BoxShadow> _getElevatedShadow(
        BuildContext context, UiElementColorContainer colorContainer) =>
    [
      BoxShadow(
        blurStyle: BlurStyle.outer,
        color: colorContainer.shadowColor.withOpacity(0.3),
        blurRadius: 0.65,
        spreadRadius: 0.0,
        offset: const Offset(0, 0.25),
      ),
      BoxShadow(
        blurStyle: BlurStyle.outer,
        offset: const Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.5,
        color: colorContainer.shadowColor.withOpacity(0.1),
      )
    ];

class AppKitPopupButton<T> extends StatefulWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final AppKitContextMenuItem<T>? selectedItem;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final SelectedItemBuilder<T>? itemBuilder;
  final double width;
  final AppKitMenuEdge menuEdge;
  final AppKitPopupButtonStyle style;
  final Color? color;
  final String? hint;
  final AppKitControlSize controlSize;

  const AppKitPopupButton({
    super.key,
    required this.width,
    this.onItemSelected,
    this.menuBuilder,
    this.selectedItem,
    this.color,
    this.hint,
    this.itemBuilder,
    this.menuEdge = AppKitMenuEdge.bottom,
    this.style = AppKitPopupButtonStyle.push,
    this.controlSize = AppKitControlSize.regular,
  });

  @override
  State<AppKitPopupButton<T>> createState() => _AppKitPopupButtonState<T>();
}

class _AppKitPopupButtonState<T> extends State<AppKitPopupButton<T>> {
  bool get enabled =>
      widget.onItemSelected != null && widget.menuBuilder != null;

  TextStyle get textStyle => AppKitTheme.of(context).typography.body;

  AppKitPopupButtonStyle get style => widget.style;

  AppKitControlSize get controlSize => widget.controlSize;

  bool _isMenuOpened = false;

  bool _isHovered = false;

  late AppKitContextMenu<T> _contextMenu;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('enabled', enabled));
    properties.add(DiagnosticsProperty('style', style));
    properties.add(DiagnosticsProperty('menuEdge', widget.menuEdge));
    properties.add(DiagnosticsProperty('width', widget.width));
    properties.add(DiagnosticsProperty('menuBuilder', widget.menuBuilder));
    properties
        .add(DiagnosticsProperty('onItemSelected', widget.onItemSelected));
    properties.add(DiagnosticsProperty('itemBuilder', widget.itemBuilder));
    properties.add(DiagnosticsProperty('color', widget.color));
    properties.add(DiagnosticsProperty('selectedItem', widget.selectedItem));
  }

  AppKitContextMenuItem<T>? get selectedItem => widget.selectedItem;

  @override
  void initState() {
    super.initState();
    _contextMenu = widget.menuBuilder!(context);
    if (widget.selectedItem != null) {
      assert(_contextMenu.firstWhereOrNull((e) => e == widget.selectedItem) !=
          null);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitPopupButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _contextMenu = widget.menuBuilder!(context);
  }

  Widget _defaultItemBuilder(
      {required BuildContext context, required double controlHeight}) {
    bool isMainWindow = MainWindowStateListener.instance.isMainWindow.value;

    String title = selectedItem?.title ?? '';
    final icon = selectedItem?.image;

    EdgeInsets iconPadding = style == AppKitPopupButtonStyle.inline
        ? EdgeInsets.only(right: 4.0, top: controlHeight * 0.08)
        : EdgeInsets.only(right: 4.0, top: controlHeight * 0.15);

    if (selectedItem == null) {
      if (widget.hint != null) {
        title = widget.hint!;
      } else {
        return const SizedBox();
      }
    }

    final TextStyle textStyle =
        style.getTextStyle(AppKitTheme.of(context), controlSize);
    Color textColor;

    if (style == AppKitPopupButtonStyle.inline) {
      textColor = (textStyle.color ?? AppKitColors.labelColor).withOpacity(0.7);
      if (!isMainWindow) {
        textColor = textColor.withOpacity(0.5);
      }
    } else {
      textColor = textStyle.color ?? AppKitColors.labelColor;
    }

    if (!enabled) {
      textColor = textColor.withOpacity(0.5);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: iconPadding,
              child: Icon(
                icon,
                size: (textStyle.fontSize! - 1),
                color: textColor,
              ),
            ),
          Flexible(
            child: Text(
              title,
              style: textStyle.copyWith(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
    final itemRect = context.getWidgetBounds();
    if (null != itemRect && widget.menuBuilder != null) {
      final menu = _contextMenu.copyWith(
          position: _contextMenu.position ??
              widget.menuEdge.getRectPosition(itemRect));
      setState(() {
        _isMenuOpened = true;
      });

      final value = await showContextMenu<T>(
        context,
        contextMenu: menu,
        transitionDuration: _kContextMenuTrasitionDuration,
        barrierDismissible: true,
        opaque: false,
        selectedItem: selectedItem,
        menuEdge: widget.menuEdge,
      );

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

          final height = style.getHeight(popupButtonTheme, controlSize);
          final width = widget.width;
          final menuEdge = widget.menuEdge;
          final itemBuilder = widget.itemBuilder;

          final child = itemBuilder?.call(context, widget.selectedItem) ??
              _defaultItemBuilder(context: context, controlHeight: height);

          if (style == AppKitPopupButtonStyle.push ||
              style == AppKitPopupButtonStyle.bevel) {
            return _PushButtonStyleWidget<T>(
              width: width,
              height: height,
              menuEdge: menuEdge,
              onItemSelected: widget.onItemSelected,
              enabled: enabled,
              colorContainer: colorContainer,
              contextMenuOpened: _isMenuOpened,
              isMainWindow: isMainWindow,
              style: style,
              controlSize: controlSize,
              color: widget.color,
              child: child,
            );
          } else if (style == AppKitPopupButtonStyle.plain) {
            return _PlainButtonStyleWidget<T>(
              width: width,
              height: height,
              menuEdge: menuEdge,
              onItemSelected: widget.onItemSelected,
              enabled: enabled,
              colorContainer: colorContainer,
              contextMenuOpened: _isMenuOpened,
              isMainWindow: isMainWindow,
              controlSize: controlSize,
              isHovered: _isHovered,
              child: child,
            );
          } else if (style == AppKitPopupButtonStyle.inline) {
            return _InlineButtonStyleWidget<T>(
              width: width,
              height: height,
              menuEdge: menuEdge,
              onItemSelected: widget.onItemSelected,
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
      ),
    );
  }
}

class _UpDownCaretsPainter2 extends CustomPainter {
  const _UpDownCaretsPainter2({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = size.height / 5.0;

    /// Draw carets
    final path1 = Path()
      ..moveTo(0, size.height / 2 - padding)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2 - padding)
      ..moveTo(0, size.height / 2 + padding)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2 + padding);

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(_UpDownCaretsPainter2 oldDelegate) {
    return color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
  }

  @override
  bool shouldRebuildSemantics(_UpDownCaretsPainter2 oldDelegate) => false;
}

class _PushButtonStyleWidget<T> extends StatelessWidget {
  final double width;
  final double height;
  final AppKitMenuEdge menuEdge;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final AppKitPopupButtonStyle style;
  final AppKitControlSize controlSize;
  final Color? color;

  const _PushButtonStyleWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    required this.style,
    this.onItemSelected,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;
    final bool isBevel = style == AppKitPopupButtonStyle.bevel;

    Color caretBackgroundColor;
    Color arrowsColor;
    double caretButtonSize =
        style.getCaretButtonSize(popupButtonTheme, controlSize);
    final caretSize = style.getCaretSize(controlSize);
    final controlBackgroundColor = enabled
        ? theme.controlBackgroundColor
        : theme.controlBackgroundColorDisabled;
    final borderRadius = style.getBorderRadius(popupButtonTheme, controlSize);

    if (isBevel) {
      caretBackgroundColor = Colors.transparent;
      arrowsColor =
          style.getArrowsColor(context).multiplyOpacity(enabledFactor);
    } else {
      caretBackgroundColor = color ??
          popupButtonTheme.elevatedButtonColor ??
          theme.accentColor ??
          colorContainer.controlAccentColor;

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
      height: height,
      width: width,
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: style.pressedBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: _getElevatedShadow(context, colorContainer)),
      child: Padding(
        padding: style.getContainerPadding(menuEdge, controlSize),
        child: LayoutBuilder(builder: (context, parentConstraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: style.getChildPadding(controlSize),
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
                          borderRadius: BorderRadius.circular(borderRadius - 1),
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
                        width: caretSize.width,
                        height: caretSize.height,
                        child: CustomPaint(
                          painter: _UpDownCaretsPainter2(
                            color: arrowsColor,
                            strokeWidth: style.getCaretStrokeWidth(controlSize),
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
    );
  }
}

class _PlainButtonStyleWidget<T> extends StatelessWidget {
  final double width;
  final double height;
  final AppKitMenuEdge menuEdge;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isHovered;
  final AppKitPopupButtonStyle style = AppKitPopupButtonStyle.plain;
  final AppKitControlSize controlSize;

  const _PlainButtonStyleWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    this.onItemSelected,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;

    final Color controlBackgroundColor;
    final Color caretBackgroundColor;
    final caretButtonSize =
        style.getCaretButtonSize(popupButtonTheme, controlSize);
    final caretSize = style.getCaretSize(controlSize);

    final borderRadius = style.getBorderRadius(popupButtonTheme, controlSize);
    final arrowsColor =
        style.getArrowsColor(context).multiplyOpacity(enabledFactor);

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
      controlBackgroundColor = theme.controlBackgroundColor;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : popupButtonTheme.plainButtonColor.multiplyOpacity(enabledFactor);
      controlBackgroundColor = Colors.transparent;
    }

    return Container(
      height: height,
      width: width,
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: style.pressedBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow:
              isHovered ? _getElevatedShadow(context, colorContainer) : null),
      child: Padding(
        padding: style.getContainerPadding(menuEdge, controlSize),
        child: LayoutBuilder(builder: (context, parentConstraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: style.getChildPadding(controlSize),
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
                    child: SizedBox(
                      width: caretSize.width,
                      height: caretSize.height,
                      child: CustomPaint(
                        painter: _UpDownCaretsPainter2(
                          color: arrowsColor,
                          strokeWidth: style.getCaretStrokeWidth(controlSize),
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
    );
  }
}

class _InlineButtonStyleWidget<T> extends StatelessWidget {
  final double width;
  final double height;
  final AppKitMenuEdge menuEdge;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isHovered;
  final AppKitPopupButtonStyle style = AppKitPopupButtonStyle.inline;
  final AppKitControlSize controlSize;

  const _InlineButtonStyleWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    this.onItemSelected,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabledFactor = enabled ? 0.5 : 0.35;
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);

    final Color controlBackgroundColor;
    final caretSize = style.getCaretSize(controlSize);
    final caretButtonSize =
        style.getCaretButtonSize(popupButtonTheme, controlSize);
    final arrowsColor = style
        .getArrowsColor(context)
        .withOpacity(isMainWindow ? enabledFactor : 0.35);
    final borderRadius = style.getBorderRadius(popupButtonTheme, controlSize);

    if (isHovered) {
      controlBackgroundColor = Colors.black.withOpacity(0.2);
    } else {
      controlBackgroundColor = Colors.black.withOpacity(0.05);
    }

    return Container(
      height: height,
      width: width,
      foregroundDecoration: contextMenuOpened
          ? BoxDecoration(
              color: style.pressedBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const BoxDecoration(),
      decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: style.getContainerPadding(menuEdge, controlSize),
        child: LayoutBuilder(builder: (context, parentConstraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: style.getChildPadding(controlSize),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                        width: parentConstraints.maxWidth,
                        height: parentConstraints.maxHeight,
                        child: child);
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: SizedBox(
                  width: caretButtonSize,
                  height: caretButtonSize,
                  child: Center(
                    child: SizedBox(
                      width: caretSize.width,
                      height: caretSize.height,
                      child: CustomPaint(
                        painter: _UpDownCaretsPainter2(
                          color: arrowsColor,
                          strokeWidth: style.getCaretStrokeWidth(controlSize),
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
    );
  }
}

extension AppKitPopupButtonStyleX on AppKitPopupButtonStyle {
  EdgeInsets getContainerPadding(
      AppKitMenuEdge menuEdge, AppKitControlSize controlSize) {
    switch (this) {
      case AppKitPopupButtonStyle.push:
      case AppKitPopupButtonStyle.bevel:
      case AppKitPopupButtonStyle.plain:
        return menuEdge.isLeft
            ? const EdgeInsets.only(left: 2.0, right: 7.0)
            : const EdgeInsets.only(left: 7.0, right: 2.0);

      case AppKitPopupButtonStyle.inline:
        return menuEdge.isLeft
            ? const EdgeInsets.only(
                left: 7.5, top: 3.5, right: 7.5, bottom: 3.5)
            : const EdgeInsets.only(
                left: 7.5, top: 3.5, right: 7.5, bottom: 3.5);
    }
  }

  EdgeInsets getChildPadding(AppKitControlSize controlSize) {
    switch (controlSize) {
      case AppKitControlSize.mini:
        return const EdgeInsets.only(bottom: 0.5, right: 4.0);
      case AppKitControlSize.small:
        return const EdgeInsets.only(bottom: 1, right: 4.0);
      case AppKitControlSize.regular:
        return this == AppKitPopupButtonStyle.inline
            ? const EdgeInsets.only(bottom: 2.5, right: 4.0)
            : const EdgeInsets.only(top: 2.0, bottom: 3.0);
      case AppKitControlSize.large:
        return const EdgeInsets.only(bottom: 3, right: 4.0);
    }
  }

  double getCaretButtonSize(
      AppKitPopupButtonThemeData theme, AppKitControlSize controlSize) {
    switch (this) {
      case AppKitPopupButtonStyle.push:
      case AppKitPopupButtonStyle.bevel:
      case AppKitPopupButtonStyle.plain:
        return getHeight(theme, controlSize) - 4;

      case AppKitPopupButtonStyle.inline:
        return 13.0;
    }
  }

  Size getCaretSize(AppKitControlSize controlSize) {
    switch (controlSize) {
      case AppKitControlSize.mini:
        return const Size(3, 5.5);
      case AppKitControlSize.small:
        return const Size(5, 8);
      case AppKitControlSize.regular:
        return const Size(5.5, 10);
      case AppKitControlSize.large:
        return const Size(7.5, 12.5);
    }
  }

  double getCaretStrokeWidth(AppKitControlSize controlSize) {
    switch (controlSize) {
      case AppKitControlSize.mini:
        return 1.0;
      case AppKitControlSize.small:
        return 1.25;
      case AppKitControlSize.regular:
        return 1.75;
      case AppKitControlSize.large:
        return 1.75;
    }
  }

  double getBorderRadius(
      AppKitPopupButtonThemeData theme, AppKitControlSize constrolSize) {
    switch (this) {
      case AppKitPopupButtonStyle.push:
      case AppKitPopupButtonStyle.bevel:
      case AppKitPopupButtonStyle.plain:
        switch (constrolSize) {
          case AppKitControlSize.mini:
            return 3;
          case AppKitControlSize.small:
            return 5;
          case AppKitControlSize.regular:
            return 5.5;
          case AppKitControlSize.large:
            return 6.0;
        }

      case AppKitPopupButtonStyle.inline:
        return getHeight(theme, constrolSize) / 2.0;
    }
  }

  double getHeight(
      AppKitPopupButtonThemeData theme, AppKitControlSize controlSize) {
    final height = theme.height[controlSize]!;

    if (this == AppKitPopupButtonStyle.inline) {
      return height * 1.25;
    } else {
      return height;
    }
  }

  Color get pressedBackgroundColor => Colors.black.withOpacity(0.05);

  Color getArrowsColor(BuildContext context) =>
      AppKitColors.labelColor.resolveFrom(context);

  TextStyle getTextStyle(AppKitThemeData theme, AppKitControlSize controlSize) {
    final style = this == AppKitPopupButtonStyle.inline
        ? theme.typography.subheadline.copyWith(fontWeight: FontWeight.w500)
        : theme.typography.body;

    switch (controlSize) {
      case AppKitControlSize.mini:
        return style.copyWith(fontSize: 9.0);
      case AppKitControlSize.small:
        return style.copyWith(fontSize: 10.0);
      case AppKitControlSize.regular:
        return style;
      case AppKitControlSize.large:
        return style.copyWith(fontSize: 14.0);
    }
  }
}
