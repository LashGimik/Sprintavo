import SwiftUI

struct TaskStatusControl: View {
    let status: TaskStatus
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            OutlineBadge(title: status.rawValue, tint: status.color)
                .frame(minHeight: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Статус: \(status.rawValue). Изменить")
    }
}
