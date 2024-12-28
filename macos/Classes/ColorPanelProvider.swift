import FlutterMacOS

class ColorPanelProvider: NSObject, NSWindowDelegate, FlutterStreamHandler {
    var eventSink: FlutterEventSink?
    // let colorPanel = NSColorPanel.shared
    
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("colorpanel.onListen()")
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("colorpanel.onCancel()")
        eventSink = nil
        return nil
    }
    
    func openPanel(pickerMode: String, uuid: String? = nil, withAlpha: Bool = false, color: Dictionary<String, Any>? = nil) {
        print("openPanel(pickerMode: \(pickerMode), uuid: \(uuid ?? "nil"))")
        let panelMode = NSColorPanel.Mode.from(from: pickerMode)
        print("resolved panelMode: \(panelMode)")
        
        NSColorPanel.setPickerMode(panelMode)
        
        let colorPanel = NSColorPanel()
        
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(startStream(colorPanel:)))
        colorPanel.makeKeyAndOrderFront(self)
        colorPanel.isContinuous = true
        colorPanel.isReleasedWhenClosed = false
        colorPanel.delegate = self
        
        if(uuid != nil) {
            colorPanel.identifier = NSUserInterfaceItemIdentifier(rawValue: uuid!)
        }
        
        colorPanel.showsAlpha = withAlpha
        
        if(color != nil) {
            let rgba = try? RGBA.init(from: color!).toColor()
            if(rgba != nil) {
                colorPanel.color = rgba!
            }
        }
    }
    
    func setPickerMode(panelMode: String) {
        switch (panelMode.lowercased()) {
        case "gray":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.gray)
        case "rbg":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.RGB)
        case "cmyk":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.CMYK)
        case "hsb":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.HSB)
        case "custompalette":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.customPalette)
        case "colorlist":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.colorList)
        case "wheel":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.wheel)
        case "crayon":
            NSColorPanel.setPickerMode(NSColorPanel.Mode.crayon)
        default:
            NSColorPanel.setPickerMode(NSColorPanel.Mode.none)
        }
    }
    
    @objc public func startStream(colorPanel: NSColorPanel) {
        let colorPanelUuid = colorPanel.identifier?.rawValue
        let result = ColorResult(color: colorPanel.color, uuid: colorPanelUuid, action: "stream")
        eventSink?(result.toFlutter())
    }

    
    @MainActor func windowWillClose(_ notification: Notification) {
        print("windowWillClose(notification: \(notification))")
        if(notification.object is NSColorPanel) {
            let colorPanelUuid = (notification.object as! NSColorPanel).identifier?.rawValue
            let result = ColorResult(color: nil, uuid: colorPanelUuid, action: "close")
            eventSink?(result.toFlutter())
        }
    }

}

extension NSColorPanel.Mode {
    
    static func from(from stringValue: String?) -> NSColorPanel.Mode {
        switch (stringValue?.lowercased()) {
        case "gray":
            return NSColorPanel.Mode.gray
        case "rgb":
            return NSColorPanel.Mode.RGB
        case "cmyk":
            return NSColorPanel.Mode.CMYK
        case "hsb":
            return NSColorPanel.Mode.HSB
        case "custompalette":
            return NSColorPanel.Mode.customPalette
        case "colorlist":
            return NSColorPanel.Mode.colorList
        case "wheel":
            return NSColorPanel.Mode.wheel
        case "crayon":
            return NSColorPanel.Mode.crayon
        default:
            return NSColorPanel.Mode.none
        }
        
    }
}

extension NSColorSpace.Model {
    
    private enum CodingKeys: String, CodingKey {
        case model
    }
    
    static func from(from rawValue: Int?) -> NSColorSpace.Model? {
        guard let mode = rawValue.map(NSColorSpace.Model.init(rawValue:)) else { return nil }
        return mode
    }
    
    
    func asFlutterString() -> String {
        switch self {
        case .rgb:
            return "RGB"
        case .deviceN:
            return "DeviceN"
        case .cmyk:
            return "cmyk"
        case .gray:
            return "gray"
        case .indexed:
            return "indexed"
        case .lab:
            return "lab"
        case .patterned:
            return "patterned"
        case .unknown: return "unknown"
        @unknown default:
            return "unknown"
        }
        
    }
}


class RGBA: ToFlutterObject {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    let mode: NSColorSpace.Model
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case red, green, blue, alpha, mode
        
        func isValidValue(_ value: Any) -> Bool {
            switch self {
            case .red, .green, .blue, .alpha:
                return value is Double
            case .mode: return value is Int
                
            }
        }
    }
    
    init(red: Double, green: Double, blue: Double, alpha: Double, mode: NSColorSpace.Model = .rgb) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.mode = mode
    }
    
    init(from color: NSColor) {
        let rgba = color.usingColorSpace(.sRGB)
        self.alpha = rgba!.alphaComponent
        self.red = rgba!.redComponent
        self.green = rgba!.greenComponent
        self.blue = rgba!.blueComponent
        self.mode = color.colorSpace.colorSpaceModel
    }
    
    init(from: Dictionary<String, Any>) throws {
        try CodingKeys.allCases.forEach { key in
            guard let value = from[key.rawValue] else { throw FlutterDecodeError.missingKey(key.stringValue) }
            if !key.isValidValue(value) { throw FlutterDecodeError.invalidType(key.stringValue) }
        }
        
        
        let red = from["red"] as? Double ?? 0
        let green = from["green"] as? Double ?? 0
        let blue = from["blue"] as? Double ?? 0
        let alpha = from["alpha"] as? Double ?? 0
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.mode = NSColorSpace.Model.from(from: from["mode"] as? Int) ?? .unknown
    }
    
    func toColor() -> NSColor? {
        return NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    func toFlutter() -> Any {
        return [
            "red": red,
            "green": green,
            "blue": blue,
            "alpha": alpha,
            "mode": mode.rawValue
        ]
    }
    
}

class ColorResult: ToFlutterObject {
    let color: RGBA?
    let uuid: String?
    let action: String
    
    enum CodingKeys: String, CodingKey {
        case color
        case uuid
        case action
    }
    
    init(color: NSColor?, uuid: String?, action: String) {
        if(color != nil) {
            self.color = RGBA(from: color!)
        } else {
            self.color = nil
        }
        self.uuid = uuid
        self.action = action
    }
    
    func toFlutter() -> Any {
        if(color == nil) {
            return ["uuid": uuid as Any, "action": action]
        }
        return ["color": color!.toFlutter(), "uuid": uuid as Any, "action": action]
    }
}


public protocol ToFlutterObject {
    func toFlutter() -> Any
}

public protocol FromFlutterObject {
    init(from: Any) throws
}

enum FlutterDecodeError: Error {
    case invalidType(String)
    case missingKey(String)
}

extension FlutterDecodeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingKey(let key):
            return "Missing key: \(key)"
        case .invalidType(let type):
            return "Invalid type: \(type)"
        }
    }
}
