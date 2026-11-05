import SwiftUI

struct NavigationTile: View {
    @Environment(\.appTheme) private var theme
    let section: WorkspaceSection
    var title: String? = nil
    var isSelected = false
    var isWide = false
    var accent: Color? = nil
    var iconSize: CGFloat = 20
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                if !isWide {
                    Image(systemName: section.symbol)
                        .font(.system(size: iconSize))
                        .accessibilityHidden(true)
                }
                HStack(spacing: 12) {
                    if isWide {
                        Image(systemName: section.symbol)
                            .font(.system(size: iconSize))
                            .accessibilityHidden(true)
                    }
                    Text(title ?? section.rawValue).font(.headline)
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.right").font(.caption)
                }
            }
            .foregroundStyle(isSelected ? (accent ?? theme.accent) : theme.text)
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: isWide ? 56 : 92, alignment: .leading)
            .modifier(PanelStyle(border: isSelected ? (accent ?? theme.accent) : theme.line))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
