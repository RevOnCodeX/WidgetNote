import Foundation

struct TaskItem: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String = ""
    var isCompleted: Bool = false
    var order: Int = 0
    var createdAt: Date = Date()
}
