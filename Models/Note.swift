import Foundation

struct Note: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = "Today"
    var createdAt: Date = Date()
    
    // Window state
    var positionX: Double = 100
    var positionY: Double = 100
    var width: Double = 200
    var height: Double = 142
    var isVisible: Bool = true
    
    var tasks: [TaskItem] = []
}
