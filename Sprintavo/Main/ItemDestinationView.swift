import SwiftUI

struct ItemDestinationView: View {
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        switch item.section {
        case .projects: ProjectDetailsView(item: item, model: model)
        case .tasks: TaskDetailsView(item: item, model: model)
        case .notes: NoteDetailsView(item: item, model: model)
        case .sprints: SprintDetailsView(item: item, model: model)
        default: ContentUnavailableView("Экран недоступен", systemImage: "questionmark.folder")
        }
    }
}
