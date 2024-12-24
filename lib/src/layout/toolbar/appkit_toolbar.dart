import 'dart:ui';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kToolbarHeight = 52.0;

const _kLeadingWidth = 20.0;

const _kTitleWidth = 150.0;

class AppKitToolBar extends StatefulWidget with Diagnosticable {
  const AppKitToolBar({
    super.key,
    this.height = _kToolbarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.titleWidth = _kTitleWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
    this.decoration,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.centerTitle = false,
    this.dividerColor,
    this.allowWallpaperTintingOverrides = true,
    this.enableBlur = false,
  });

  final double height;

  final Alignment alignment;

  final Widget? title;

  final double titleWidth;

  final BoxDecoration? decoration;

  final EdgeInsets padding;

  final Widget? leading;

  final bool automaticallyImplyLeading;

  final List<AppKitToolbarItem>? actions;

  final bool centerTitle;

  final Color? dividerColor;

  final bool allowWallpaperTintingOverrides;

  final bool enableBlur;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(DiagnosticsProperty<Widget>('title', title));
    properties.add(DoubleProperty('titleWidth', titleWidth));
    properties
        .add(DiagnosticsProperty<BoxDecoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<Widget>('leading', leading));
    properties.add(FlagProperty(
      'automaticallyImplyLeading',
      value: automaticallyImplyLeading,
      ifTrue: 'automatically imply leading',
    ));
    properties
        .add(DiagnosticsProperty<List<AppKitToolbarItem>>('actions', actions));
    properties.add(FlagProperty(
      'centerTitle',
      value: centerTitle,
      ifTrue: 'center title',
    ));
    properties.add(DiagnosticsProperty<Color>('dividerColor', dividerColor));
  }

  @override
  State<AppKitToolBar> createState() => _AppKitToolBarState();
}

class _AppKitToolBarState extends State<AppKitToolBar> {
  int overflowedActionsCount = 0;

  @override
  void didUpdateWidget(AppKitToolBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actions != null &&
        widget.actions!.length != oldWidget.actions!.length) {
      overflowedActionsCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppKitWindowScope.maybeOf(context);
    final AppKitThemeData theme = AppKitTheme.of(context);
    final brightness = AppKitTheme.of(context).brightness;
    Color dividerColor = widget.dividerColor ?? theme.dividerColor;
    final route = ModalRoute.of(context);
    double overflowBreakpoint = 0.0;

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (route?.canPop ?? false) {
        leading = Container(
          width: _kLeadingWidth,
          alignment: Alignment.centerLeft,
          child: AppKitIconTheme(
            data: const AppKitIconThemeData(
              size: 20.0,
            ),
            child: AppKitIconButton(
              padding: const EdgeInsets.all(5),
              disabledColor: Colors.transparent,
              color: brightness.resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        );
      }
    }

    if (widget.leading != null) {
      overflowBreakpoint += _kLeadingWidth;
    }

    Widget? title = widget.title;
    if (title != null) {
      title = SizedBox(
        width: widget.titleWidth,
        child: DefaultTextStyle(
          style: theme.typography.title3.copyWith(
            fontSize: 15,
            fontWeight: AppKitFontWeight.w590,
          ),
          child: title,
        ),
      );
      overflowBreakpoint += widget.titleWidth;
    }

    // Collect the toolbar action widgets that can be shown inside the ToolBar
    // and the ones that have overflowed.
    List<AppKitToolbarItem>? inToolbarActions = [];
    List<AppKitToolbarItem> overflowedActions = [];
    bool doAllItemsShowLabel = true;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      inToolbarActions = widget.actions ?? [];
      overflowedActions = inToolbarActions
          .sublist(inToolbarActions.length - overflowedActionsCount)
          .toList();
      // If all toolbar actions have labels shown below their icons,
      // reduce the overflow button's size as well.
      for (AppKitToolbarItem item in widget.actions!) {
        if (item is AppKitToolBarIconButton) {
          if (!item.showLabel) {
            doAllItemsShowLabel = false;
          }
        }
      }
    }

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(
          left: !kIsWeb && isMacOS ? 70 : 0,
        ),
      ),
      child: _WallpaperTintedAreaOrBlurFilter(
        enableWallpaperTintedArea: kIsWeb ? false : !widget.enableBlur,
        isWidgetVisible: widget.allowWallpaperTintingOverrides,
        backgroundColor: theme.canvasColor,
        widgetOpacity: widget.decoration?.color?.opacity,
        child: Container(
          alignment: widget.alignment,
          padding: widget.padding,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: dividerColor)),
          ).copyWith(
            color: widget.decoration?.color,
            image: widget.decoration?.image,
            border: widget.decoration?.border,
            borderRadius: widget.decoration?.borderRadius,
            boxShadow: widget.decoration?.boxShadow,
            gradient: widget.decoration?.gradient,
          ),
          child: NavigationToolbar(
            middle: title,
            centerMiddle: widget.centerTitle,
            trailing: AppKitOverflowHandler(
              overflowBreakpoint: overflowBreakpoint,
              overflowWidget: AppKitToolbarOverflowButton(
                isDense: doAllItemsShowLabel,
                overflowContentBuilder: (context) => AppKitToolbarOverflowMenu(
                  children: overflowedActions
                      .map((action) => action.build(
                            context,
                            AppKitToolbarItemDisplayMode.overflowed,
                          ))
                      .toList(),
                ),
              ),
              children: inToolbarActions
                  .map(
                    (e) => e.build(
                        context, AppKitToolbarItemDisplayMode.inToolbar),
                  )
                  .toList(),
              overflowChangedCallback: (hiddenItems) {
                setState(() => overflowedActionsCount = hiddenItems.length);
              },
            ),
            middleSpacing: 8,
            leading: SafeArea(
              top: false,
              right: false,
              bottom: false,
              left: !(scope?.isSidebarShown ?? false),
              child: leading ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppKitToolbarItemDisplayMode {
  inToolbar,
  overflowed,
}

abstract class AppKitToolbarItem with Diagnosticable {
  const AppKitToolbarItem({required this.key});

  final Key? key;

  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode);
}

class _WallpaperTintedAreaOrBlurFilter extends StatelessWidget {
  const _WallpaperTintedAreaOrBlurFilter({
    required this.child,
    required this.enableWallpaperTintedArea,
    required this.backgroundColor,
    required this.widgetOpacity,
    required this.isWidgetVisible,
  });

  final Widget child;
  final bool enableWallpaperTintedArea;
  final Color backgroundColor;
  final double? widgetOpacity;
  final bool isWidgetVisible;

  @override
  Widget build(BuildContext context) {
    if (enableWallpaperTintedArea) {
      return AppKitWallpaperTintedArea(
        backgroundColor: backgroundColor,
        insertRepaintBoundary: true,
        child: child,
      );
    }

    if (!isWidgetVisible) {
      return child;
    }

    return AppKitWallpaperTintingOverride(
      child: ClipRect(
        child: BackdropFilter(
          filter: widgetOpacity == 1.0
              ? ImageFilter.blur()
              : ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
          child: child,
        ),
      ),
    );
  }
}
