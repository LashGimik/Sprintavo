import Foundation

enum TaskListScope: String, CaseIterable, Identifiable {
    case all = "Все"
    case active = "Активные"
    case finished = "Завершённые"

    var id: Self { self }

    func includes(_ status: TaskStatus) -> Bool {
        switch self {
        case .all: true
        case .active: !status.isFinished
        case .finished: status.isFinished
        }
    }
}
