import Foundation

enum TaskSortOrder: String, CaseIterable, Identifiable {
    case newest = "Сначала новые"
    case deadline = "По сроку"
    case priority = "По приоритету"

    var id: Self { self }

    func precedes(_ lhs: WorkspaceItem, _ rhs: WorkspaceItem) -> Bool {
        switch self {
        case .newest: break
        case .deadline:
            switch (lhs.dueDate, rhs.dueDate) {
            case let (left?, right?) where left != right: return left < right
            case (_?, nil): return true
            case (nil, _?): return false
            default: break
            }
        case .priority:
            if lhs.taskPriority.sortRank != rhs.taskPriority.sortRank {
                return lhs.taskPriority.sortRank < rhs.taskPriority.sortRank
            }
        }
        if lhs.createdAt != rhs.createdAt { return lhs.createdAt > rhs.createdAt }
        return lhs.id.uuidString < rhs.id.uuidString
    }
}
