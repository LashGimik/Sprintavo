import Foundation

enum ChecklistStatus: String, CaseIterable, Identifiable, Codable {
    case todo = "К выполнению"
    case inProgress = "В работе"
    case postponed = "Отложено"
    case completed = "Выполнено"

    var id: Self { self }
}
