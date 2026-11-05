import SwiftUI

struct CompactSelectionButton: View {
    @Environment(\.appTheme) private var theme
    let title: String
    let isSelected: Bool
    var fillsWidth = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? theme.text : theme.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: !fillsWidth, vertical: false)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(maxWidth: fillsWidth ? .infinity : nil)
                .modifier(PanelStyle(border: isSelected ? theme.secondaryText : theme.line, cornerRadius: 8))
                .frame(minHeight: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: fillsWidth ? .infinity : nil)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
