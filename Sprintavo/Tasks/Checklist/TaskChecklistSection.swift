import SwiftUI

struct TaskChecklistSection: View {
    let task: WorkspaceItem
    @Bindable var state: TaskChecklistViewModel
    let statusPicker: ChecklistStatusPickerModel
    var dismissFocusTrigger = false
    let onSave: ([TaskChecklistItem], [TaskChecklistItem]) -> Bool
    let onChangeStatus: (UUID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Шаги задачи").font(.headline).accessibilityAddTraits(.isHeader)
                Spacer()
                Text("\(task.checklist.filter(\.isCompleted).count) из \(task.checklist.count)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            if state.isEditing {
                TaskChecklistEditor(items: $state.items, statusPicker: statusPicker, dismissFocusTrigger: dismissFocusTrigger, scrollsRows: true)
                if state.hasConflict(with: task.checklist) {
                    Text("Список изменился в другом редакторе. Отмените ввод и откройте актуальную версию.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if let error = state.error {
                    Text(error).font(.footnote).foregroundStyle(.secondary)
                }
                FilledActionButton(title: "Применить шаги", isEnabled: state.canApply && !state.hasConflict(with: task.checklist), action: apply)
                Button("Отмена", action: state.cancel)
                    .frame(maxWidth: .infinity, minHeight: 44).buttonStyle(.plain)
            } else {
                Button(task.checklist.isEmpty ? "Добавить шаги" : "Изменить шаги", systemImage: "square.and.pencil", action: begin)
                    .font(.subheadline).frame(minHeight: 44).buttonStyle(.plain)
                LineDivider()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        if task.checklist.isEmpty {
                            Text("Разбейте задачу на небольшие шаги.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                        ForEach(task.checklist) { item in
                            TaskChecklistRow(item: item, onChangeStatus: onChangeStatus)
                            LineDivider()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func begin() { state.begin(task.checklist) }

    private func apply() {
        guard state.canApply, !state.hasConflict(with: task.checklist) else { return }
        if onSave(state.items, state.originalItems) {
            state.cancel()
        } else {
            state.error = "Не удалось применить шаги. Проверьте актуальный список."
        }
    }
}
