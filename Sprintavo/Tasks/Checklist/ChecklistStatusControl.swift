import SwiftUI

struct ChecklistStatusControl: View {
    let status: ChecklistStatus
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            OutlineBadge(title: status.rawValue, tint: status.color)
                .fixedSize(horizontal: true, vertical: false)
                .frame(minHeight: 44, alignment: .leading)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Статус шага: \(status.rawValue). Изменить")
    }
}
