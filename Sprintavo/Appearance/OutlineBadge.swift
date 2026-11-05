import SwiftUI

struct OutlineBadge: View {
    @Environment(\.appTheme) private var theme
    let title: String
    var tint: Color? = nil

    var body: some View {
        Text(title)
            .font(.caption.weight(.medium))
            .foregroundStyle(tint ?? theme.secondaryText)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background((tint ?? .clear).opacity(0.08), in: .rect(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(tint?.opacity(0.45) ?? theme.line, lineWidth: 1)
            }
    }
}
