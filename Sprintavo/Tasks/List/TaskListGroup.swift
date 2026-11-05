import Foundation

struct TaskListGroup: Identifiable {
    let isFinished: Bool
    let tasks: [WorkspaceItem]

    var id: String { isFinished ? "finished" : "active" }
    var title: String { isFinished ? "Завершённые" : "Активные" }
}
