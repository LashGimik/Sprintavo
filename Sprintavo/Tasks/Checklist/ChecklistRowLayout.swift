import SwiftUI

struct ChecklistRowLayout<Content: View>: View {
    @Environment(\.appTheme) private var theme
    let status: ChecklistStatus
    let onChangeStatus: () -> Void
    var contentTopInset: CGFloat = 8
    var spacing: CGFloat = 8
    let content: Content

    init(
        status: ChecklistStatus,
        onChangeStatus: @escaping () -> Void,
        contentTopInset: CGFloat = 8,
        spacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.status = status
        self.onChangeStatus = onChangeStatus
        self.contentTopInset = contentTopInset
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            Button(action: onChangeStatus) {
                Image(systemName: status == .completed ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(status == .completed ? status.color : theme.secondaryText)
                    .frame(width: 44, height: 44)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Статус шага: \(status.rawValue). Изменить")
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, contentTopInset)
        }
        .padding(.vertical, 4)
    }
}
