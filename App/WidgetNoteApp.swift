import SwiftUI
import AppKit

@main
struct WidgetNoteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("WidgetNote", systemImage: "note.text") {
            Button("New Note") {
                DesktopWindowManager.shared.createNewNote()
            }
            .keyboardShortcut("n", modifiers: [.command])
            
            Divider()
            
            Button("Show All Notes") {
                DesktopWindowManager.shared.showAllNotes()
            }
            
            Button("Hide All Notes") {
                DesktopWindowManager.shared.hideAllNotes()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: [.command])
        }
        
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the visibility manager to start observing App switches
        _ = DesktopVisibilityManager.shared
        
        // Restore windows behind icons
        DesktopWindowManager.shared.restoreWindows()
        
        // If no notes exist, create one
        if DataStore.shared.notes.isEmpty {
            DesktopWindowManager.shared.createNewNote()
        }
    }
}
