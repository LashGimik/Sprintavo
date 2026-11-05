import Foundation
import Observation

@MainActor
@Observable
final class TaskEditorViewModel {
    var title: String {
        didSet {
            if title.count > TaskTitleRules.maximumLength {
                title = String(title.prefix(TaskTitleRules.maximumLength))
            }
        }
    }
    var details: String
    var status: TaskStatus
    var priority: TaskPriority
    var hasDueDate: Bool
    var dueDate: Date
    var checklist: [TaskChecklistItem]
    private(set) var hasSubmitted = false
    private let original: WorkspaceItem?

    init(task: WorkspaceItem? = nil) {
        original = task
        title = task?.title ?? ""
        details = task?.details ?? ""
        status = task?.taskStatus ?? .todo
        priority = task?.taskPriority ?? .normal
        hasDueDate = task?.dueDate != nil
        dueDate = task?.dueDate ?? Date()
        checklist = task?.checklist ?? []
    }

    var isEditing: Bool { original != nil }

    var canCreate: Bool {
        TaskTitleRules.normalized(title) != nil && !hasSubmitted && TaskChecklistRules.normalized(checklist) != nil
    }

    var hasChanges: Bool {
        let currentDate = hasDueDate ? Calendar.current.startOfDay(for: dueDate) : nil
        let originalDate = (original?.dueDate).map { Calendar.current.startOfDay(for: $0) }
        return title != (original?.title ?? "") || details != (original?.details ?? "") ||
            status != (original?.taskStatus ?? .todo) || priority != (original?.taskPriority ?? .normal) ||
            currentDate != originalDate || checklist != (original?.checklist ?? [])
    }

    func makeTask(in project: WorkspaceItem) -> WorkspaceItem? {
        guard canCreate, project.section == .projects, !project.isArchived,
              let validTitle = TaskTitleRules.normalized(title),
              let steps = TaskChecklistRules.normalized(checklist) else { return nil }
        hasSubmitted = true
        return WorkspaceItem(
            id: original?.id ?? UUID(), section: .tasks,
            title: validTitle,
            subtitle: status.rawValue + " · " + project.title,
            details: details.trimmingCharacters(in: .whitespacesAndNewlines),
            projectID: project.id,
            taskStatus: status, taskPriority: priority,
            dueDate: hasDueDate ? Calendar.current.startOfDay(for: dueDate) : nil,
            createdAt: original?.createdAt ?? Date(), checklist: steps
        )
    }
}
