import SwiftUI

struct NavigationMenuView: View {
    @State private var isProjectPickerPresented = false
    let model: MainViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Sprintavo", action: showHome)
                    .font(.title2.bold())
                    .buttonStyle(.plain)
                    .accessibilityLabel("Sprintavo — на главную")
                Spacer()
                IconButton(title: "Закрыть меню", symbol: "xmark", action: model.closeMenu)
            }
            LineDivider()
            HStack(spacing: 10) {
                ProjectSelectorButton(project: model.selectedProject, action: openProjectPicker)
                IconButton(title: "Новый проект", symbol: "plus", action: model.presentProjectEditor)
                    .frame(width: 52, height: 52)
                    .modifier(PanelStyle())
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ProjectMenuSections(model: model)
                    LineDivider()
                    NavigationTile(section: .projects, title: "Все проекты", isSelected: model.isProjectListVisible, isWide: true) {
                        model.select(.projects)
                    }
                    NavigationTile(section: .settings, isSelected: model.currentRoute == .section(.settings, project: nil), isWide: true) {
                        model.select(.settings)
                    }
                    NavigationTile(section: .home, title: "Главный экран", isSelected: model.isHomeVisible, isWide: true) {
                        model.select(.home)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(20)
        .modifier(PanelStyle(cornerRadius: 20))
        #if os(iOS)
        .fullScreenCover(isPresented: $isProjectPickerPresented, onDismiss: resetProjectSearch) {
            ProjectPickerView(
                search: model.projectSearch,
                projects: model.records(in: .projects),
                selectedProjectID: model.selectedProject?.id,
                onSelect: model.chooseProject
            )
        }
        #else
        .sheet(isPresented: $isProjectPickerPresented, onDismiss: resetProjectSearch) {
            ProjectPickerView(
                search: model.projectSearch,
                projects: model.records(in: .projects),
                selectedProjectID: model.selectedProject?.id,
                onSelect: model.chooseProject
            )
        }
        #endif
    }

    private func openProjectPicker() {
        model.projectSearch.close()
        isProjectPickerPresented = true
    }

    private func resetProjectSearch() {
        model.projectSearch.close()
    }

    private func showHome() {
        model.select(.home)
    }
}
