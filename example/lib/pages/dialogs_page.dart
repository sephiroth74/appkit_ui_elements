import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';

const dialogMessage =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur';

class DialogsViewPage extends StatefulWidget {
  const DialogsViewPage({super.key});

  @override
  State<DialogsViewPage> createState() => _DialogsViewPageState();
}

class _DialogsViewPageState extends State<DialogsViewPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('Selectors'),
        titleWidth: 200,
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const WidgetTitle(label: 'Dialogs'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: AppKitButton(
                          onTap: () {
                            showAppKitDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                debugPrint('generate dialog widget');
                                return AppKitDialog(
                                  suppress: const DoNotNotifyRow(),
                                  title: const Text('Dialog'),
                                  message: const Text(dialogMessage),
                                  primaryButton: AppKitButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      type: AppKitButtonType.primary,
                                      style: AppKitButtonStyle.flat,
                                      child: const Text('Close')),
                                );
                              },
                            );
                          },
                          type: AppKitButtonType.primary,
                          child: const Text('Show Dialog 1')),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: AppKitButton(
                          onTap: () {
                            showAppKitDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AppKitDialog(
                                  constraints: const BoxConstraints(
                                      minWidth: 350, maxWidth: 350),
                                  suppress: const DoNotNotifyRow(),
                                  icon: const AppKitIcon(CupertinoIcons.news),
                                  title: const Text('Dialog'),
                                  message: const Text(dialogMessage),
                                  secondaryButton: AppKitButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      type: AppKitButtonType.secondary,
                                      child: const Text('Cancel')),
                                  primaryButton: AppKitButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      type: AppKitButtonType.primary,
                                      child: const Text('Close')),
                                );
                              },
                            );
                          },
                          type: AppKitButtonType.primary,
                          child: const Text('Show Dialog 2')),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: AppKitButton(
                          onTap: () {
                            showAppKitDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AppKitDialog(
                                  suppress: const DoNotNotifyRow(),
                                  icon: const AppKitIcon(CupertinoIcons.news),
                                  title: const Text('Dialog'),
                                  message: const Text(dialogMessage),
                                  horizontalActions: false,
                                  tertiaryButton: AppKitButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      type: AppKitButtonType.destructive,
                                      child: const Text('Close')),
                                  primaryButton: AppKitButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      type: AppKitButtonType.primary,
                                      child: const Text('Close')),
                                );
                              },
                            );
                          },
                          type: AppKitButtonType.primary,
                          child: const Text('Show Dialog 3')),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: AppKitButton(
                        type: AppKitButtonType.primary,
                        child: const Text('Show sheet'),
                        onTap: () {
                          showAppKitSheet(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const DemoSheet(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class DoNotNotifyRow extends StatefulWidget {
  const DoNotNotifyRow({super.key});

  @override
  State<DoNotNotifyRow> createState() => _DoNotNotifyRowState();
}

class _DoNotNotifyRowState extends State<DoNotNotifyRow> {
  bool suppress = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppKitCheckbox(
          value: suppress,
          onChanged: (value) {
            setState(() => suppress = value);
          },
        ),
        const SizedBox(width: 8),
        Text(
          'Don\'t ask again',
          style: AppKitTheme.of(context).typography.body,
        ),
      ],
    );
  }
}

class DemoSheet extends StatelessWidget {
  const DemoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppKitSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Welcome to appkit_ui_elements',
                style: AppKitTheme.of(context)
                    .typography
                    .largeTitle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const AppKitListTile(
                leading: Icon(CupertinoIcons.lightbulb),
                title:
                    Text('A complete library of Flutter components for AppKit'),
                subtitle: Text(
                    'Create native looking AppKit applications using Flutter'),
              ),
              const SizedBox(height: 16),
              const AppKitListTile(
                leading: Icon(CupertinoIcons.bolt),
                title: Text('Create beautiful macOS applications in minutes'),
              ),
              const Spacer(),
              AppKitButton(
                type: AppKitButtonType.primary,
                style: AppKitButtonStyle.flat,
                size: AppKitControlSize.large,
                child: const Text('Get started'),
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
