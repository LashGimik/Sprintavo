import SwiftUI

struct SectionHeader: View {
    @Environment(\.appTheme) private var theme
    let title: String
    var actionTitle = "Все"
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 12)
            Button(action: action) {
                HStack(spacing: 6) {
                    Text(actionTitle)
                    Image(systemName: "chevron.right").font(.caption)
                }
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(actionTitle): \(title)")
        }
    }
}
