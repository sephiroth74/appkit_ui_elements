import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';

class PushButtonPage extends StatefulWidget {
  const PushButtonPage({super.key});

  @override
  State<PushButtonPage> createState() => _PushButtonPageState();
}

class _PushButtonPageState extends State<PushButtonPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Buttons'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
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
                                      child: const Text(
                                        'Get',
                                      ))),
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
                        const WidgetTitle(label: 'Push Button'),
                        const SizedBox(height: 16.0),
                        for (final controlSize in AppKitControlSize.values) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppKitButton(
                                size: controlSize,
                                style: AppKitButtonStyle.push,
                                type: AppKitButtonType.primary,
                                child: const Text('Push'),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16.0),
                              AppKitButton(
                                size: controlSize,
                                style: AppKitButtonStyle.push,
                                type: AppKitButtonType.secondary,
                                child: const Text('Push'),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16.0),
                              AppKitButton(
                                size: controlSize,
                                style: AppKitButtonStyle.push,
                                type: AppKitButtonType.destructive,
                                child: const Text('Push'),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16.0),
                              AppKitButton(
                                size: controlSize,
                                style: AppKitButtonStyle.push,
                                type: AppKitButtonType.primary,
                                child: const Text('Momentary Push'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                        ],
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
