import SwiftUI

struct TaskChecklistDraftRow: View {
    @Environment(\.appTheme) private var theme
    @FocusState private var isFocused: Bool
    @Binding var item: TaskChecklistItem
    var dismissFocusTrigger = false
    let onChangeStatus: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ChecklistRowLayout(status: item.status, onChangeStatus: changeStatus, contentTopInset: 0) {
            VStack(alignment: .leading, spacing: 0) {
                TextField("Название шага", text: $item.title, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .focused($isFocused)
                    .lineLimit(1...8)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .accessibilityLabel("Название шага")
                HStack(spacing: 8) {
                    ChecklistStatusControl(status: item.status, action: changeStatus)
                    Spacer(minLength: 0)
                    IconButton(title: "Удалить шаг", symbol: "trash", color: theme.secondaryText, action: onDelete)
                }
            }
        }
        .onAppear { if item.title.isEmpty { isFocused = true } }
        .onChange(of: dismissFocusTrigger) { _, dismiss in
            if dismiss { isFocused = false }
        }
    }

    private func changeStatus() {
        isFocused = false
        onChangeStatus()
    }
}
