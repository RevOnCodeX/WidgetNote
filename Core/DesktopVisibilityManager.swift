import AppKit
import Observation

@Observable
class DesktopVisibilityManager {
    static let shared = DesktopVisibilityManager()
    
    private(set) var isDesktopVisible: Bool = true
    
    private init() {
        // Evaluate initial state
        updateVisibilityState()
        
        // Observe app changes
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(applicationDidActivate),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
        
        // Observe space changes
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(spaceDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func applicationDidActivate(_ notification: Notification) {
        updateVisibilityState()
    }
    
    @objc private func spaceDidChange(_ notification: Notification) {
        updateVisibilityState()
    }
    
    private func updateVisibilityState() {
        guard let activeApp = NSWorkspace.shared.frontmostApplication else { return }
        
        let bundleID = activeApp.bundleIdentifier ?? ""
        let isFinder = bundleID == "com.apple.finder"
        let isWidgetNote = activeApp == NSRunningApplication.current
        
        let shouldBeVisible = isFinder || isWidgetNote
        
        if shouldBeVisible != isDesktopVisible {
            isDesktopVisible = shouldBeVisible
            if shouldBeVisible {
                DesktopWindowManager.shared.fadeInAllWindows()
            } else {
                DesktopWindowManager.shared.fadeOutAllWindows()
            }
        }
    }
}
