import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class PushButtonPage extends StatefulWidget {
  const PushButtonPage({super.key});

  @override
  State<PushButtonPage> createState() => _PushButtonPageState();
}

class _PushButtonPageState extends State<PushButtonPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('Push Button'),
        titleWidth: 200,
      ),
      children: [
        AppKitContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WidgetTitle(label: 'Inline Button'),
                        const SizedBox(height: 16.0),

                        for (final controlSize in AppKitControlSize.values) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppKitTooltip.plain(
                                  message: 'Inline button (primary)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.inline,
                                      type: AppKitButtonType.primary,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Inline button (secondary)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.inline,
                                      type: AppKitButtonType.secondary,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Inline button (destructive)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.inline,
                                      type: AppKitButtonType.destructive,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.rich(
                                  message: TextSpan(children: [
                                    const TextSpan(
                                      text: 'Inline Button with ',
                                    ),
                                    TextSpan(
                                      text: 'custom color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppKitDynamicColor.resolve(
                                              context,
                                              AppKitColors.systemMint)),
                                    ),
                                  ]),
                                  child: AppKitButton(
                                      accentColor: AppKitDynamicColor.resolve(
                                          context, AppKitColors.systemMint),
                                      onPressed: () {},
                                      style: AppKitButtonStyle.inline,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Inline button disabled',
                                  child: AppKitButton(
                                      style: AppKitButtonStyle.inline,
                                      size: controlSize,
                                      child: const Text('Get'))),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                        ],

                        const WidgetTitle(label: 'Flat Button'),
                        const SizedBox(height: 16.0),
                        for (final controlSize in AppKitControlSize.values) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppKitTooltip.plain(
                                  message: 'Flat button (primary)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.flat,
                                      type: AppKitButtonType.primary,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Flat button (secondary)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.flat,
                                      type: AppKitButtonType.secondary,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Flat button (destructive)',
                                  child: AppKitButton(
                                      onPressed: () {},
                                      style: AppKitButtonStyle.flat,
                                      type: AppKitButtonType.destructive,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.rich(
                                  message: TextSpan(children: [
                                    const TextSpan(
                                      text: 'Flat Button with ',
                                    ),
                                    TextSpan(
                                      text: 'custom color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppKitDynamicColor.resolve(
                                              context,
                                              AppKitColors.systemMint)),
                                    ),
                                  ]),
                                  child: AppKitButton(
                                      accentColor: AppKitDynamicColor.resolve(
                                          context, AppKitColors.systemMint),
                                      onPressed: () {},
                                      style: AppKitButtonStyle.flat,
                                      size: controlSize,
                                      child: const Text('Get'))),
                              const SizedBox(width: 8.0),
                              AppKitTooltip.plain(
                                  message: 'Flat button disabled',
                                  child: AppKitButton(
                                      style: AppKitButtonStyle.flat,
                                      size: controlSize,
                                      child: const Text('Get'))),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                        ],

                        // AppKitControlSize.values.map((controlSize) {
                        //   return Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       AppKitTooltip.plain(
                        //           message: 'Inline button (primary)',
                        //           child: AppKitButton(
                        //               onPressed: () {},
                        //               style: AppKitButtonStyle.inline,
                        //               type: AppKitButtonType.primary,
                        //               size: AppKitControlSize.large,
                        //               child: const Text('Get'))),
                        //       const SizedBox(width: 8.0),
                        //       AppKitTooltip.plain(
                        //           message: 'Inline button (secondary)',
                        //           child: AppKitButton(
                        //               onPressed: () {},
                        //               style: AppKitButtonStyle.inline,
                        //               type: AppKitButtonType.secondary,
                        //               size: AppKitControlSize.large,
                        //               child: const Text('Get'))),
                        //       const SizedBox(width: 8.0),
                        //       AppKitTooltip.plain(
                        //           message: 'Inline button (destructive)',
                        //           child: AppKitButton(
                        //               onPressed: () {},
                        //               style: AppKitButtonStyle.inline,
                        //               type: AppKitButtonType.destructive,
                        //               size: AppKitControlSize.large,
                        //               child: const Text('Get'))),
                        //       const SizedBox(width: 8.0),
                        //       AppKitTooltip.rich(
                        //           message: TextSpan(children: [
                        //             const TextSpan(
                        //               text: 'Inline Button with ',
                        //             ),
                        //             TextSpan(
                        //               text: 'custom color',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   color: AppKitDynamicColor.resolve(context, AppKitColors.systemMint)),
                        //             ),
                        //           ]),
                        //           child: AppKitButton(
                        //               accentColor: AppKitDynamicColor.resolve(context, AppKitColors.systemMint),
                        //               onPressed: () {},
                        //               style: AppKitButtonStyle.inline,
                        //               size: AppKitControlSize.large,
                        //               child: const Text('Get'))),
                        //       const SizedBox(width: 8.0),
                        //       AppKitTooltip.plain(
                        //           message: 'Inline button disabled',
                        //           child: const AppKitButton(
                        //               style: AppKitButtonStyle.inline,
                        //               size: AppKitControlSize.large,
                        //               child: Text('Get'))),
                        //     ],
                        //   );
                        // }).toList(),

                        const WidgetTitle(label: 'Push Button'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitTooltip.plain(
                              message:
                                  'This is a tooltip with a somewhat long message.',
                              child: AppKitPushButton(
                                onPressed: () {},
                                controlSize: AppKitControlSize.large,
                                color: AppKitColors.systemYellow
                                    .resolveFrom(context),
                                type: AppKitPushButtonType.primary,
                                child: const Text('Label'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitTooltip.rich(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              softWrap: false,
                              useMousePosition: false,
                              message: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Rich Tooltip: \n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppKitColors.systemGray
                                          .resolveFrom(context),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const TextSpan(text: 'This is a '),
                                  TextSpan(
                                    text: 'tooltip',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        backgroundColor:
                                            Colors.yellow.withOpacity(0.5)),
                                  ),
                                  const TextSpan(
                                      text:
                                          ' with a somewhat long message.\n\n'),
                                  const TextSpan(
                                    text:
                                        'Tooltip can also contains rich text.',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              child: AppKitPushButton(
                                onPressed: () {},
                                controlSize: AppKitControlSize.large,
                                type: AppKitPushButtonType.primary,
                                child: const Text('Label'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.regular,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.small,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.mini,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              color: AppKitColors.systemYellow
                                  .resolveFrom(context),
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.mini,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.large,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.mini,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Divider(
                          thickness: 0.5,
                        ),
                        const SizedBox(height: 8.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
