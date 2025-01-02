import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const groupMessage =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

class SliverToolbarPage extends StatefulWidget {
  const SliverToolbarPage({super.key});

  @override
  State<SliverToolbarPage> createState() => _SliverToolbarPageState();
}

class _SliverToolbarPageState extends State<SliverToolbarPage> {
  bool pinned = true;
  bool floating = false;
  double opacity = .9;

  AppKitContextMenuItem<double> opacitySelectedItem =
      const AppKitContextMenuItem(title: '90% (Default)', value: 0.9);

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      children: [
        AppKitContentArea(builder: (context, scrollController) {
          return CustomScrollView(
            slivers: [
              AppKitSliverToolBar(
                title: const Text('SliverToolbar'),
                floating: floating,
                pinned: pinned,
                toolbarOpacity: opacity,
                allowWallpaperTintingOverrides: true,
                actions: [
                  AppKitToolBarIconButton(
                    label: 'Pinned',
                    icon: pinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                    tooltipMessage:
                        'Whether the toolbar should remain visible at the start of the scroll view.',
                    showLabel: false,
                    onPressed: () {
                      setState(() => pinned = !pinned);
                    },
                  ),
                  AppKitToolBarIconButton(
                    label: 'Floating',
                    icon: floating
                        ? CupertinoIcons.arrow_up_circle
                        : CupertinoIcons.arrow_down_circle,
                    tooltipMessage:
                        'Whether the toolbar should become visible as soon as the user scrolls upwards',
                    showLabel: false,
                    onPressed: () {
                      setState(() => floating = !floating);
                    },
                  ),
                  const AppKitToolBarSpacer(spacerUnits: 0.25),
                  AppKitCustomToolbarItem(
                    inToolbarBuilder: (context) {
                      return AppKitTooltip.plain(
                        message: 'Toolbar opacity',
                        child: AppKitPopupButton<double>(
                          width: 75,
                          controlSize: AppKitControlSize.regular,
                          style: AppKitPopupButtonStyle.bevel,
                          selectedItem: opacitySelectedItem,
                          menuBuilder: (context) {
                            return AppKitContextMenu(entries: [
                              const AppKitContextMenuItem(
                                  title: '25%', value: 0.25),
                              const AppKitContextMenuItem(
                                  title: '50%', value: 0.5),
                              const AppKitContextMenuItem(
                                  title: '75%', value: 0.75),
                              const AppKitContextMenuItem(
                                  title: '90% (Default)', value: 0.9),
                            ]);
                          },
                          onItemSelected: (item) {
                            if (null == item) return;
                            final value = item.value;
                            opacitySelectedItem = item;
                            if (value == 0.25) {
                              setState(() => opacity = 0.25);
                            } else if (value == 0.5) {
                              setState(() => opacity = 0.5);
                            } else if (value == 0.75) {
                              setState(() => opacity = 0.75);
                            } else if (value == 0.9) {
                              setState(() => opacity = 0.9);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const AppKitToolBarSpacer(spacerUnits: 0.5),
                  ThemeSwitcherToolbarItem.build(context),
                  const AppKitToolBarSpacer(spacerUnits: 0.5),
                ],
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'SliverToolbar is nearly identical to the standard '
                    'Toolbar widget, except that it can be used in a '
                    'CustomScrollView. It can be pinned, floating, or '
                    'neither.',
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        ...List<Widget>.generate(
                          3,
                          (index) => const FlutterLogo(size: 150),
                        )
                      ],
                    ),
                    ...List<Widget>.generate(
                      100,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Item ${index + 1}'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        })
      ],
    );
  }
}
