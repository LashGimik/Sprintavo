import SwiftUI

struct ProjectPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) private var theme
    @Bindable var search: SearchViewModel
    let projects: [WorkspaceItem]
    let selectedProjectID: UUID?
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Выбрать проект")
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                IconButton(title: "Закрыть выбор проекта", symbol: "xmark", action: close)
            }
            .padding(.horizontal, 20)
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(theme.secondaryText)
                    .accessibilityHidden(true)
                TextField("Поиск проекта", text: $search.query)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .accessibilityLabel("Поиск проекта")
                if !search.query.isEmpty {
                    IconButton(title: "Очистить поиск", symbol: "xmark.circle", action: clearQuery)
                }
            }
            .padding(.horizontal, 12)
            .frame(minHeight: 48)
            .modifier(PanelStyle())
            .padding(.horizontal, 20)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(visibleProjects) { project in
                        ProjectPickerRow(project: project, isSelected: project.id == selectedProjectID, onSelect: selectProject)
                        LineDivider()
                    }
                }
                .padding(.horizontal, 20)
            }
            .overlay {
                if visibleProjects.isEmpty {
                    ContentUnavailableView(
                        projects.isEmpty ? "Нет проектов" : "Ничего не найдено",
                        systemImage: "folder",
                        description: Text(projects.isEmpty ? "Здесь появятся ваши проекты." : "Попробуйте другое название.")
                    )
                }
            }
        }
        .padding(.top, 12)
        .background { ScreenBackground() }
        .foregroundStyle(theme.text)
        .tint(theme.accent)
        .preferredColorScheme(.dark)
    }

    private var visibleProjects: [WorkspaceItem] {
        search.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? projects : search.results
    }

    private func clearQuery() {
        search.query = ""
    }

    private func close() {
        search.close()
        dismiss()
    }

    private func selectProject(_ project: WorkspaceItem) {
        onSelect(project)
        close()
    }
}
