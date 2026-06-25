import AppKit
import SwiftUI

class WidgetWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    override var canBecomeMain: Bool {
        return true
    }
}

class DesktopWindowController: NSWindowController, NSWindowDelegate {
    var noteID: UUID
    
    init(note: Note) {
        self.noteID = note.id
        
        let rootView = NoteCardView(noteID: note.id)
        let hostingView = NSHostingView(rootView: rootView)
        
        let styleMask: NSWindow.StyleMask = [.titled, .resizable, .fullSizeContentView]
        let initialRect = NSRect(x: note.positionX, y: note.positionY, width: note.width, height: note.height)
        
        // Use our custom WidgetWindow so textfields can become key while borderless
        let window = WidgetWindow(contentRect: initialRect, styleMask: styleMask, backing: .buffered, defer: false)
        
        // Hide the title bar completely to make it look borderless
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Wrap in container view to prevent auto-sizing
        let containerView = NSView(frame: NSRect(origin: .zero, size: initialRect.size))
        hostingView.frame = containerView.bounds
        hostingView.autoresizingMask = [.width, .height]
        containerView.addSubview(hostingView)
        
        window.contentView = containerView
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false // Desktop widgets usually don't have heavy OS shadows, or we can add a subtle shadow in SwiftUI
        window.isMovableByWindowBackground = true
        
        // Set level to normal. Fading logic handles the "desktop" feel, but it must be at least .normal to receive clicks from WindowServer.
        window.level = .normal
        
        // Ensures it stays on the desktop and doesn't follow the user into spaces or expose
        window.collectionBehavior = [.stationary, .ignoresCycle, .canJoinAllSpaces]
        
        super.init(window: window)
        window.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        saveWindowState()
    }
    
    func windowDidMove(_ notification: Notification) {
        saveWindowState()
    }
    
    func windowDidResignKey(_ notification: Notification) {
        // If the user clicks outside while expanded, auto-save the task and collapse
        if WidgetExpansionManager.shared.expandedNoteID == self.noteID {
            let text = WidgetExpansionManager.shared.newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                if let index = DataStore.shared.notes.firstIndex(where: { $0.id == self.noteID }) {
                    let newTask = TaskItem(text: text, order: DataStore.shared.notes[index].tasks.count)
                    DataStore.shared.notes[index].tasks.append(newTask)
                }
            }
            DesktopWindowManager.shared.collapseWindow(for: self.noteID, discardText: true)
        }
    }
    
    private func saveWindowState() {
        guard let window = self.window else { return }
        let frame = window.frame
        let id = self.noteID
        if let index = DataStore.shared.notes.firstIndex(where: { $0.id == id }) {
            var note = DataStore.shared.notes[index]
            
            if WidgetExpansionManager.shared.expandedNoteID == id {
                note.positionX = frame.origin.x
                note.positionY = frame.origin.y + 80
                note.width = frame.width
                note.height = frame.height - 80
            } else {
                note.positionX = frame.origin.x
                note.positionY = frame.origin.y
                note.width = frame.width
                note.height = frame.height
            }
            
            DataStore.shared.notes[index] = note
        }
    }
}
