import SwiftUI

struct ItemRowView: View {
    @Environment(\.appTheme) private var theme
    let item: WorkspaceItem
    var accent: Color? = nil
    var showsChevron = true

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            WorkspaceItemIcon(item: item, tint: accent ?? theme.secondaryText)
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title).font(.headline).foregroundStyle(theme.text)
                Text(item.subtitle).font(.subheadline).foregroundStyle(theme.secondaryText)
            }
            Spacer(minLength: 8)
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
    }
}
