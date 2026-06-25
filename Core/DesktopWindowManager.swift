import AppKit
import SwiftUI
import Observation

@Observable
class DesktopWindowManager {
    static let shared = DesktopWindowManager()
    
    var controllers: [UUID: DesktopWindowController] = [:]
    
    private init() {}
    
    func restoreWindows() {
        for note in DataStore.shared.notes {
            if note.isVisible {
                openWindow(for: note)
            }
        }
    }
    
    func openWindow(for note: Note) {
        if let existingController = controllers[note.id] {
            existingController.window?.orderFront(nil)
            return
        }
        
        let newController = DesktopWindowController(note: note)
        controllers[note.id] = newController
        
        // Initial visibility
        if DesktopVisibilityManager.shared.isDesktopVisible {
            newController.window?.alphaValue = 1.0
        } else {
            newController.window?.alphaValue = 0.0
        }
        
        newController.window?.orderFront(nil)
        
        if let index = DataStore.shared.notes.firstIndex(where: { $0.id == note.id }) {
            var updated = note
            updated.isVisible = true
            DataStore.shared.notes[index] = updated
        }
    }
    
    func closeWindow(for noteID: UUID) {
        if let controller = controllers.removeValue(forKey: noteID) {
            controller.close()
            
            if let index = DataStore.shared.notes.firstIndex(where: { $0.id == noteID }) {
                var note = DataStore.shared.notes[index]
                note.isVisible = false
                DataStore.shared.notes[index] = note
            }
        }
    }
    
    func expandWindow(for noteID: UUID) {
        guard let controller = controllers[noteID], let window = controller.window else { return }
        
        WidgetExpansionManager.shared.expandedNoteID = noteID
        WidgetExpansionManager.shared.newTaskText = ""
        
        var frame = window.frame
        let heightDiff: CGFloat = 80
        
        frame.size.height += heightDiff
        frame.origin.y -= heightDiff
        
        let newFrame = frame
        AnimationManager.animate(changes: {
            window.animator().setFrame(newFrame, display: true)
        }) {
            InteractionManager.shared.enterEditMode(for: window, targetFieldID: "QuickAddField-\(noteID)")
        }
    }
    
    func collapseWindow(for noteID: UUID, discardText: Bool = false) {
        guard let controller = controllers[noteID], let window = controller.window else { return }
        
        if WidgetExpansionManager.shared.expandedNoteID == noteID {
            WidgetExpansionManager.shared.expandedNoteID = nil
            
            if discardText {
                WidgetExpansionManager.shared.newTaskText = ""
            }
            
            var frame = window.frame
            let heightDiff: CGFloat = 80
            
            frame.size.height -= heightDiff
            frame.origin.y += heightDiff
            
            let newFrame = frame
            AnimationManager.animate(changes: {
                window.animator().setFrame(newFrame, display: true)
            }) {
                WidgetExpansionManager.shared.expandedNoteID = nil
                if discardText {
                    WidgetExpansionManager.shared.newTaskText = ""
                }
                InteractionManager.shared.leaveEditMode(for: window)
            }
        }
    }
    
    func createNewNote() {
        let count = controllers.count
        let offset = Double(count * 30)
        
        let screenMaxY = Double(NSScreen.main?.visibleFrame.maxY ?? 1080)
        let screenMinX = Double(NSScreen.main?.visibleFrame.minX ?? 0)
        
        let noteHeight: Double = 142
        let yPos = screenMaxY - 170 - noteHeight - offset
        let xPos = screenMinX + offset
        
        let note = Note(positionX: xPos, positionY: yPos)
        
        DataStore.shared.notes.append(note)
        openWindow(for: note)
    }
    
    func showAllNotes() {
        for note in DataStore.shared.notes {
            openWindow(for: note)
        }
    }
    
    func hideAllNotes() {
        let keys = Array(controllers.keys)
        for key in keys {
            closeWindow(for: key)
        }
    }
    
    // Fade animations called by DesktopVisibilityManager
    func fadeOutAllWindows() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            for controller in controllers.values {
                controller.window?.animator().alphaValue = 0.0
            }
        }, completionHandler: {
            for controller in self.controllers.values {
                controller.window?.orderOut(nil)
            }
        })
    }
    
    func fadeInAllWindows() {
        for controller in self.controllers.values {
            controller.window?.orderFront(nil)
        }
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            for controller in controllers.values {
                controller.window?.animator().alphaValue = 1.0
            }
        }
    }
}
