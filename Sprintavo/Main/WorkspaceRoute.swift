import Foundation

enum WorkspaceRoute: Hashable {
    case section(WorkspaceSection, project: WorkspaceItem?)
    case item(WorkspaceItem)

    var id: String {
        switch self {
        case let .section(section, project):
            "section-" + section.rawValue + "-" + (project?.id.uuidString ?? "global")
        case let .item(item):
            "item-" + item.id.uuidString
        }
    }

    var section: WorkspaceSection {
        switch self {
        case let .section(section, _): section
        case let .item(item):
            item.isArchived ? .archive : (item.section == .projects ? .overview : item.section)
        }
    }
}
