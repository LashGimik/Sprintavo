import Foundation

enum TaskPriority: String, CaseIterable, Identifiable, Codable {
    case low = "Низкий"
    case normal = "Обычный"
    case high = "Высокий"

    var sortRank: Int {
        switch self {
        case .high: 0
        case .normal: 1
        case .low: 2
        }
    }

    var id: Self { self }
}
