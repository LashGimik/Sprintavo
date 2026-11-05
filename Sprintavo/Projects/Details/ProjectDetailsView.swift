import SwiftUI

struct ProjectDetailsView: View {
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        ScreenContent {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 14) {
                    ProjectSymbol(color: item.projectColor, size: 28)
                    Text(item.title)
                        .font(.title2.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)
                }
                Text(item.details).foregroundStyle(.secondary)
                if item.isArchived {
                    Label("В архиве", systemImage: "archivebox")
                }
            }
            ProjectItemsSection(title: "Задачи", items: model.related(to: item, in: .tasks), model: model)
            ProjectItemsSection(title: "Спринты", items: model.related(to: item, in: .sprints), model: model)
            ProjectItemsSection(title: "Заметки", items: model.related(to: item, in: .notes), model: model)
        }
    }
}
