import Foundation

enum TaskStatus: String, CaseIterable, Identifiable, Codable {
    case todo = "К выполнению"
    case inProgress = "В работе"
    case inReview = "На проверке"
    case blocked = "Заблокировано"
    case done = "Готово"

    case cancelled = "Отменено"

    var isFinished: Bool { self == .done || self == .cancelled }

    var id: Self { self }
}
