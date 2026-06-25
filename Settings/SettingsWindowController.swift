import AppKit
import SwiftUI

class SettingsWindowController {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    
    private init() {}
    
    func openSettings() {
        if let existingWindow = window, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApplication.shared.activate(ignoringOtherApps: true)
            return
        }
        
        let settingsView = MainSettingsView()
        let hostingController = NSHostingController(rootView: settingsView)
        
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 680, height: 520),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        newWindow.center()
        newWindow.setFrameAutosaveName("SettingsWindow")
        newWindow.isReleasedWhenClosed = false
        newWindow.contentViewController = hostingController
        newWindow.title = "Settings"
        newWindow.titlebarAppearsTransparent = true
        newWindow.titleVisibility = .hidden
        
        self.window = newWindow
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        newWindow.makeKeyAndOrderFront(nil)
    }
}
