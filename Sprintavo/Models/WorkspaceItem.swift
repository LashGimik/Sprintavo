import Foundation

struct WorkspaceItem: Identifiable, Hashable {
    let id: UUID
    let section: WorkspaceSection
    var title: String
    var subtitle: String
    var details: String
    let projectID: UUID?
    let isArchived: Bool
    let projectColor: ProjectColor
    var taskStatus: TaskStatus
    var taskPriority: TaskPriority
    var dueDate: Date?
    let createdAt: Date
    var checklist: [TaskChecklistItem]

    init(id: UUID = UUID(), section: WorkspaceSection, title: String, subtitle: String, details: String, projectID: UUID? = nil, isArchived: Bool = false, projectColor: ProjectColor = .yellow, taskStatus: TaskStatus = .todo, taskPriority: TaskPriority = .normal, dueDate: Date? = nil, createdAt: Date = Date(), checklist: [TaskChecklistItem] = []) {
        self.id = id
        self.section = section
        self.title = title
        self.subtitle = subtitle
        self.details = details
        self.projectID = projectID
        self.isArchived = isArchived
        self.projectColor = projectColor
        self.taskStatus = taskStatus
        self.taskPriority = taskPriority
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.checklist = checklist
    }
}
