import Cocoa
import FlutterMacOS

public class AppKitUiElementsPlugin: NSObject, FlutterPlugin {
    private let colorPanelProvider: ColorPanelProvider
    private var eventSink: FlutterEventSink?
    
    init(colorPanelProvider: ColorPanelProvider) {
        self.colorPanelProvider = colorPanelProvider
        super.init()
    }

  public static func register(with registrar: FlutterPluginRegistrar) {
      print("register()")
      let channel = FlutterMethodChannel(name: "dev.sephiroth74.appkit_ui_elements", binaryMessenger: registrar.messenger)
      
      let colorSelectionChannel = FlutterEventChannel(name: "dev.sephiroth74.appkit_ui_elements/color_picker",binaryMessenger: registrar.messenger)
    
      let colorPanelProvider = ColorPanelProvider()


      let instance = AppKitUiElementsPlugin(colorPanelProvider: colorPanelProvider)
      colorSelectionChannel.setStreamHandler(colorPanelProvider)
      
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      print("handle(\(call.method))")
      
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        
    case "colorPicker":
        if let arguments = call.arguments as? Dictionary<String, Any> {
            print("arguments: \(arguments)")
            
            let uuid = arguments["uuid"] as? String
            let mode = arguments["mode"] as? String
            let withAlpha = arguments["alpha"] as? Bool ?? false
            let color = arguments["color"] as? Dictionary<String, Any>
            
            colorPanelProvider.openPanel(pickerMode: mode!, uuid: uuid, withAlpha: withAlpha, color: color)
            result("colorPanel")
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func onListen(eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("plugin.onListen()")
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("plugin.onCancel()")
        eventSink = nil
        return nil
    }
}
