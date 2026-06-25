import AppKit
import SwiftUI

@Observable
class AppearanceManager {
    static let shared = AppearanceManager()
    
    private init() {}
    
    func applyAppearance() {
        let mode = SettingsManager.shared.appearanceMode
        
        switch mode {
        case 1:
            NSApp.appearance = NSAppearance(named: .aqua)
        case 2:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        default:
            NSApp.appearance = nil // System default
        }
    }
}
