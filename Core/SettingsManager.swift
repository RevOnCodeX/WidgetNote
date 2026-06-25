import SwiftUI
import ServiceManagement

@Observable
class SettingsManager {
    static let shared = SettingsManager()
    
    // General
    var launchAtLogin: Bool = false {
        didSet {
            saveSettings()
            updateLaunchAtLoginStatus()
        }
    }
    var restoreWidgetsOnLaunch: Bool = true { didSet { saveSettings() } }
    
    // Appearance
    var blurIntensity: Double = 0.5 { didSet { saveSettings() } }
    var widgetOpacity: Double = 1.0 { didSet { saveSettings() } }
    var cornerRadius: Double = 24.0 { didSet { saveSettings() } }
    var shadowStrength: Double = 0.2 { didSet { saveSettings() } }
    var accentColorHex: String = "#FF69B4" { didSet { saveSettings() } }
    var appearanceMode: Int = 0 { didSet { saveSettings() } } // 0 = System, 1 = Light, 2 = Dark
    
    // Widgets
    var defaultWidgetWidth: Double = 250.0 { didSet { saveSettings() } }
    var defaultWidgetHeight: Double = 300.0 { didSet { saveSettings() } }
    var showHeaders: Bool = true { didSet { saveSettings() } }
    var showCompletedTasks: Bool = true { didSet { saveSettings() } }
    var autoSortCompletedTasks: Bool = true { didSet { saveSettings() } }
    var enableMultipleWidgets: Bool = true { didSet { saveSettings() } }
    
    // Behavior
    var autoHideWhenActive: Bool = true { didSet { saveSettings() } }
    var desktopFadeDuration: Double = 0.25 { didSet { saveSettings() } }
    var hoverAnimationStrength: Double = 1.01 { didSet { saveSettings() } }
    var springAnimationSpeed: Double = 0.25 { didSet { saveSettings() } }
    var autoSaveDelay: Double = 1.0 { didSet { saveSettings() } }
    
    private init() {
        loadSettings()
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        
        if #available(macOS 13.0, *) {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        } else {
            launchAtLogin = defaults.object(forKey: "launchAtLogin") as? Bool ?? false
        }
        
        restoreWidgetsOnLaunch = defaults.object(forKey: "restoreWidgetsOnLaunch") as? Bool ?? true
        
        blurIntensity = defaults.object(forKey: "blurIntensity") as? Double ?? 0.5
        widgetOpacity = defaults.object(forKey: "widgetOpacity") as? Double ?? 1.0
        cornerRadius = defaults.object(forKey: "cornerRadius") as? Double ?? 24.0
        shadowStrength = defaults.object(forKey: "shadowStrength") as? Double ?? 0.2
        accentColorHex = defaults.string(forKey: "accentColorHex") ?? "#FF69B4"
        appearanceMode = defaults.object(forKey: "appearanceMode") as? Int ?? 0
        
        defaultWidgetWidth = defaults.object(forKey: "defaultWidgetWidth") as? Double ?? 250.0
        defaultWidgetHeight = defaults.object(forKey: "defaultWidgetHeight") as? Double ?? 300.0
        showHeaders = defaults.object(forKey: "showHeaders") as? Bool ?? true
        showCompletedTasks = defaults.object(forKey: "showCompletedTasks") as? Bool ?? true
        autoSortCompletedTasks = defaults.object(forKey: "autoSortCompletedTasks") as? Bool ?? true
        enableMultipleWidgets = defaults.object(forKey: "enableMultipleWidgets") as? Bool ?? true
        
        autoHideWhenActive = defaults.object(forKey: "autoHideWhenActive") as? Bool ?? true
        desktopFadeDuration = defaults.object(forKey: "desktopFadeDuration") as? Double ?? 0.25
        hoverAnimationStrength = defaults.object(forKey: "hoverAnimationStrength") as? Double ?? 1.01
        springAnimationSpeed = defaults.object(forKey: "springAnimationSpeed") as? Double ?? 0.25
        autoSaveDelay = defaults.object(forKey: "autoSaveDelay") as? Double ?? 1.0
    }
    
    private func updateLaunchAtLoginStatus() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    if SMAppService.mainApp.status == .enabled { return }
                    try SMAppService.mainApp.register()
                } else {
                    if SMAppService.mainApp.status != .enabled { return }
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update launch at login status: \(error)")
            }
        }
    }
    
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(launchAtLogin, forKey: "launchAtLogin")
        defaults.set(restoreWidgetsOnLaunch, forKey: "restoreWidgetsOnLaunch")
        
        defaults.set(blurIntensity, forKey: "blurIntensity")
        defaults.set(widgetOpacity, forKey: "widgetOpacity")
        defaults.set(cornerRadius, forKey: "cornerRadius")
        defaults.set(shadowStrength, forKey: "shadowStrength")
        defaults.set(accentColorHex, forKey: "accentColorHex")
        defaults.set(appearanceMode, forKey: "appearanceMode")
        
        defaults.set(defaultWidgetWidth, forKey: "defaultWidgetWidth")
        defaults.set(defaultWidgetHeight, forKey: "defaultWidgetHeight")
        defaults.set(showHeaders, forKey: "showHeaders")
        defaults.set(showCompletedTasks, forKey: "showCompletedTasks")
        defaults.set(autoSortCompletedTasks, forKey: "autoSortCompletedTasks")
        defaults.set(enableMultipleWidgets, forKey: "enableMultipleWidgets")
        
        defaults.set(autoHideWhenActive, forKey: "autoHideWhenActive")
        defaults.set(desktopFadeDuration, forKey: "desktopFadeDuration")
        defaults.set(hoverAnimationStrength, forKey: "hoverAnimationStrength")
        defaults.set(springAnimationSpeed, forKey: "springAnimationSpeed")
        defaults.set(autoSaveDelay, forKey: "autoSaveDelay")
    }
    
    func resetAllSettings() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
        
        // Reset properties to defaults without triggering save loops
        let newManager = SettingsManager()
        self.launchAtLogin = false
        self.restoreWidgetsOnLaunch = true
        self.blurIntensity = 0.5
        self.widgetOpacity = 1.0
        self.cornerRadius = 24.0
        self.shadowStrength = 0.2
        self.accentColorHex = "#FF69B4"
        self.appearanceMode = 0
        self.defaultWidgetWidth = 250.0
        self.defaultWidgetHeight = 300.0
        self.showHeaders = true
        self.showCompletedTasks = true
        self.autoSortCompletedTasks = true
        self.enableMultipleWidgets = true
        self.autoHideWhenActive = true
        self.desktopFadeDuration = 0.25
        self.hoverAnimationStrength = 1.01
        self.springAnimationSpeed = 0.25
        self.autoSaveDelay = 1.0
    }
}

// Helper to convert hex to Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 105, 180) // Default pink
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        guard let components = NSColor(self).cgColor.components, components.count >= 3 else {
            return "#FF69B4"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
