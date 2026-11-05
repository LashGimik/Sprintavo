import SwiftUI

struct TaskDeadlineEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) private var theme
    @State private var hasDate: Bool
    @State private var date: Date
    let onApply: (Date?) -> Void

    init(date: Date?, onApply: @escaping (Date?) -> Void) {
        _hasDate = State(initialValue: date != nil)
        _date = State(initialValue: date ?? Date())
        self.onApply = onApply
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Срок задачи").font(.title2.bold())
                Spacer()
                IconButton(title: "Отменить изменение срока", symbol: "xmark", action: close)
            }
            .padding(20)
            ScreenContent {
                TaskDueDateField(isEnabled: $hasDate, date: $date)
                FilledActionButton(title: "Применить", action: apply)
            }
        }
        .foregroundStyle(theme.text)
        .background { ScreenBackground() }
        .preferredColorScheme(.dark)
    }

    private func close() { dismiss() }
    private func apply() {
        onApply(hasDate ? date : nil)
        dismiss()
    }
}
