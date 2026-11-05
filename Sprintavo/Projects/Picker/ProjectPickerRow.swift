import SwiftUI

struct ProjectPickerRow: View {
    @Environment(\.appTheme) private var theme
    let project: WorkspaceItem
    let isSelected: Bool
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        Button(action: selectProject) {
            HStack(spacing: 12) {
                ItemRowView(item: project, accent: isSelected ? theme.accent : nil, showsChevron: false)
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(theme.accent)
                        .accessibilityHidden(true)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func selectProject() {
        onSelect(project)
    }
}
