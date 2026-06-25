import Foundation
import Observation

@Observable
class WidgetExpansionManager {
    static let shared = WidgetExpansionManager()
    
    var expandedNoteID: UUID?
    var newTaskText: String = ""
    
    private init() {}
}
