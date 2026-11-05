import Foundation

struct TaskChecklistItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var status: ChecklistStatus

    var isCompleted: Bool { status == .completed }

    init(id: UUID = UUID(), title: String, status: ChecklistStatus = .todo) {
        self.id = id
        self.title = title
        self.status = status
    }
}
