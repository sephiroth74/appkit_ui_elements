import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:macos_ui/macos_ui.dart';

const groupMessage =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

class ResizablePanelPage extends StatefulWidget {
  const ResizablePanelPage({super.key});

  @override
  State<ResizablePanelPage> createState() => _ResizablePanelPageState();
}

class _ResizablePanelPageState extends State<ResizablePanelPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const ToolBar(
        title: Text('Resizable Panel'),
        titleWidth: 200,
      ),
      children: [
        AppKitResizablePane(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: AppKitResizableSide.right,
          builder: (_, __) {
            return const Center(
              child: Text('Left Resizable Pane'),
            );
          },
        ),
        AppKitContentArea(
          builder: (_, __) {
            return Column(
              children: [
                const Flexible(
                  fit: FlexFit.loose,
                  child: Center(
                    child: Text('Content Area'),
                  ),
                ),
                AppKitResizablePane(
                  minSize: 50,
                  startSize: 200,
                  //windowBreakpoint: 600,
                  builder: (_, __) {
                    return const Center(
                      child: Text('Bottom Resizable Pane'),
                    );
                  },
                  resizableSide: AppKitResizableSide.top,
                ),
              ],
            );
          },
        ),
        const AppKitResizablePane.noScrollBar(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: AppKitResizableSide.left,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Right non-scrollable Resizable Pane')),
          ),
        ),
      ],
    );
  }
}
