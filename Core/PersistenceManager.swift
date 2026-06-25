import Foundation
import Observation
import AppKit

@Observable
class DataStore {
    static let shared = DataStore()
    
    var notes: [Note] = [] {
        didSet {
            debouncedSave()
        }
    }
    
    private let savePath: URL
    private var saveWorkItem: DispatchWorkItem?
    
    private init() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appDir = paths[0].appendingPathComponent("WidgetNote")
        
        if !FileManager.default.fileExists(atPath: appDir.path) {
            try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        }
        
        savePath = appDir.appendingPathComponent("notes.json")
        load()
        
        // Ensure data is saved immediately when app quits
        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.flushPendingSave()
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Note].self, from: data) {
                self.notes = decoded
            }
        }
    }
    
    private func debouncedSave() {
        saveWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSave()
        }
        
        saveWorkItem = workItem
        // Delay save by 1 second to throttle disk writes and save battery
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    private func flushPendingSave() {
        if saveWorkItem != nil {
            saveWorkItem?.cancel()
            saveWorkItem = nil
            performSave()
        }
    }
    
    private func performSave() {
        if let encoded = try? JSONEncoder().encode(notes) {
            try? encoded.write(to: savePath, options: .atomic)
        }
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }
    
    deinit {
        flushPendingSave()
    }
}
