import SwiftUI

struct SectionView: View {
    let section: WorkspaceSection
    let project: WorkspaceItem?
    let model: MainViewModel

    var body: some View {
        switch section {
        case .home: HomeView(model: model)
        case .overview:
            if let project {
                ProjectDetailsView(item: project, model: model)
            } else {
                ContentUnavailableView("Выберите проект", systemImage: "folder")
            }
        case .projects: ProjectListView(model: model)
        case .tasks: TaskListView(project: project, model: model)
        case .notes: NoteListView(project: project, model: model)
        case .sprints: SprintListView(project: project, model: model)
        case .archive: ArchiveView(model: model)
        case .settings: SettingsView()
        }
    }
}
