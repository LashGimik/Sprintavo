import SwiftUI

struct ProjectListControls: View {
    @Environment(\.appTheme) private var theme
    let isArchiveActive: Bool
    let onToggleArchive: () -> Void
    let onCreate: () -> Void

    var body: some View {
        ExpandingControlGroup(isExpanded: !isArchiveActive, axis: .horizontal) {
            IconButton(
                title: isArchiveActive ? "Показать рабочие проекты" : "Показать архивные проекты",
                symbol: "archivebox",
                color: isArchiveActive ? theme.accent : theme.text,
                action: onToggleArchive
            )
            .accessibilityValue(isArchiveActive ? "Архив включён" : "Архив выключен")
            .accessibilityAddTraits(isArchiveActive ? .isSelected : [])
        } secondary: {
            IconButton(title: "Создать проект", symbol: "plus", action: onCreate)
        }
    }
}
