import SwiftUI

struct TaskChecklistRow: View {
    @Environment(\.appTheme) private var theme
    let item: TaskChecklistItem
    let onChangeStatus: (UUID) -> Void

    var body: some View {
        ChecklistRowLayout(status: item.status, onChangeStatus: chooseStatus) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.body)
                    .foregroundStyle(item.isCompleted ? theme.text.opacity(0.75) : theme.text)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ChecklistStatusControl(status: item.status, action: chooseStatus)
            }
        }
    }

    private func chooseStatus() { onChangeStatus(item.id) }
}
