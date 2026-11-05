import Foundation

enum TaskDetailsTab: String, CaseIterable, Identifiable {
    case parameters = "Параметры"
    case description = "Описание"
    case steps = "Шаги"

    var id: Self { self }
}
