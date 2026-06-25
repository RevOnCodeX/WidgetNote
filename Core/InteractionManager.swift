import Cocoa

class InteractionManager {
    static let shared = InteractionManager()
    
    private var registeredTextFields: [String: NSTextField] = [:]
    
    private init() {}
    
    func register(textField: NSTextField, with id: String) {
        registeredTextFields[id] = textField
    }
    
    func enterEditMode(for window: NSWindow, targetFieldID: String? = nil) {
        print("\n--- ENTERING EDIT MODE ---")
        
        // 1. Activate application
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // 2. Make window key
        window.makeKeyAndOrderFront(nil)
        
        // 3. Wait one runloop before stealing focus
        DispatchQueue.main.async {
            // 4. Steal focus on raw NSTextField if provided
            if let id = targetFieldID, let textField = self.registeredTextFields[id] {
                window.makeFirstResponder(textField)
                
                // If it's empty, we might want to select the text or place insertion point,
                // but just making it first responder is usually enough for a new field.
                if let fieldEditor = window.fieldEditor(true, for: textField) as? NSTextView {
                    fieldEditor.setSelectedRange(NSRange(location: fieldEditor.string.count, length: 0))
                }
            }
            
            // 5. Diagnostics
            let app = NSApplication.shared
            print("Current activation policy: \(app.activationPolicy().rawValue)")
            print("NSApp.isActive: \(app.isActive)")
            print("window.isKeyWindow: \(window.isKeyWindow)")
            print("window.isMainWindow: \(window.isMainWindow)")
            if let firstResponder = window.firstResponder {
                print("window.firstResponder: \(firstResponder)")
                print("type(of: window.firstResponder): \(type(of: firstResponder))")
            } else {
                print("window.firstResponder: nil")
            }
        }
    }
    
    func leaveEditMode(for window: NSWindow) {
        print("\n--- LEAVING EDIT MODE ---")
        
        // 1. Relinquish first responder
        window.makeFirstResponder(nil)
        
        // 2. Resign key window so Finder/etc can take it back
        if window.isKeyWindow {
            window.resignKey()
        }
        
        // 3. Do NOT manually deactivate other apps or switch policy.
        // We do NOT hide the application either, because that makes the widget disappear from the desktop!
        // NSApplication.shared.hide(nil) // REMOVED
        
        let app = NSApplication.shared
        print("Current activation policy after editing: \(app.activationPolicy().rawValue)")
    }
}
