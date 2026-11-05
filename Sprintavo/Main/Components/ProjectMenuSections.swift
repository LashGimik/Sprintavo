import SwiftUI

struct ProjectMenuSections: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let model: MainViewModel

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: dynamicTypeSize.isAccessibilitySize ? 1 : 2), spacing: 12) {
            ForEach([WorkspaceSection.overview, .tasks, .notes, .sprints]) { section in
                NavigationTile(section: section, isSelected: model.isMenuSectionActive(section)) {
                    model.select(section)
                }
                .disabled(model.selectedProject == nil)
                .opacity(model.selectedProject == nil ? 0.45 : 1)
            }
        }
    }
}
