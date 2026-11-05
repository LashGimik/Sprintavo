import SwiftUI

struct SearchResultRow: View {
    @Environment(\.appTheme) private var theme
    let item: WorkspaceItem
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        Button(action: selectItem) {
            HStack(alignment: .top, spacing: 12) {
                WorkspaceItemIcon(item: item, tint: theme.accent)
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title).font(.subheadline.weight(.semibold)).foregroundStyle(theme.text)
                        .lineLimit(2)
                    Text(item.isArchived ? "Архив · " + item.subtitle : item.subtitle)
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .padding(12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }

    private func selectItem() {
        onSelect(item)
    }
}
