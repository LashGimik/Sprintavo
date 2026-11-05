import SwiftUI

struct ItemCardView: View {
    @Environment(\.appTheme) private var theme
    let item: WorkspaceItem
    var width: CGFloat = 210
    var accent: Color? = nil
    var fill: Color? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            WorkspaceItemIcon(item: item, size: 28, tint: accent ?? theme.accent)
            Text(item.title).font(.headline).foregroundStyle(theme.text)
            Text(item.subtitle)
                .lineLimit(2)
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
        }
        .frame(width: width, alignment: .leading)
        .padding(16)
        .modifier(PanelStyle(fill: fill))
    }
}
