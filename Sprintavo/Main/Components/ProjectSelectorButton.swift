import SwiftUI

struct ProjectSelectorButton: View {
    @Environment(\.appTheme) private var theme
    let project: WorkspaceItem?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ProjectSymbol(color: project?.projectColor ?? .gray)
                Text(project?.title ?? "Выберите проект")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.secondaryText)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .modifier(PanelStyle())
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Открыть выбор проекта")
    }
}
