import SwiftUI

struct TaskDueDateField: View {
    @Environment(\.appTheme) private var theme
    @Binding var isEnabled: Bool
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: toggleDate) {
                HStack {
                    Text("Срок").font(.headline)
                    Spacer()
                    OutlineBadge(title: isEnabled ? date.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "ru_RU"))) : "Не указан")
                    Image(systemName: isEnabled ? "minus" : "plus")
                }
                .frame(minHeight: 44)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityHint(isEnabled ? "Убрать срок" : "Указать срок")
            if isEnabled {
                DatePicker("Выполнить до", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(theme.text)
                    .environment(\.locale, Locale(identifier: "ru_RU"))
            }
        }
    }

    private func toggleDate() { isEnabled.toggle() }
}
