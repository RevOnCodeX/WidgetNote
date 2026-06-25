import AppKit

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private init() {}
    
    func start() {
        // Implement local shortcuts to avoid Accessibility permissions.
        // These will fire when the app is active (e.g., when the settings window or a widget is focused).
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Option + Space for Quick Capture
            if event.modifierFlags.contains(.option) && event.keyCode == 49 {
                self.triggerQuickCapture()
                return nil
            }
            // Command + Shift + N for New Widget (keycode 45 = 'n')
            if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) && event.keyCode == 45 {
                DesktopWindowManager.shared.createNewNote()
                return nil
            }
            // Command + Shift + A for Show All (keycode 0 = 'a')
            if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) && event.keyCode == 0 {
                DesktopWindowManager.shared.showAllNotes()
                return nil
            }
            return event
        }
    }
    
    private func triggerQuickCapture() {
        if DataStore.shared.notes.isEmpty {
            DesktopWindowManager.shared.createNewNote()
        }
        
        if let firstNote = DataStore.shared.notes.first {
            if let window = DesktopWindowManager.shared.controllers[firstNote.id]?.window {
                window.makeKeyAndOrderFront(nil)
            }
            if WidgetExpansionManager.shared.expandedNoteID != firstNote.id {
                DesktopWindowManager.shared.expandWindow(for: firstNote.id)
            } else {
                if let window = DesktopWindowManager.shared.controllers[firstNote.id]?.window {
                    InteractionManager.shared.enterEditMode(for: window, targetFieldID: "QuickAddField-\(firstNote.id)")
                }
            }
        }
    }
}
