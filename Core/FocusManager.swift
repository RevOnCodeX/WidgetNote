import Foundation
import Observation

@Observable
class FocusManager {
    static let shared = FocusManager()
    
    var pendingFocusID: UUID?
    
    private init() {}
}
