import SwiftUI

struct TaskParametersView: View {
    @State private var isDeadlineEditorPresented = false
    let task: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Статус").font(.subheadline)
                Spacer()
                TaskStatusControl(status: task.taskStatus, action: showStatusPicker)
            }
            LineDivider()
            HStack {
                Text("Срок").font(.subheadline)
                Spacer()
                Button(action: showDeadlineEditor) {
                    OutlineBadge(title: task.dueDate.map {
                        $0.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "ru_RU")))
                    } ?? "Не указан")
                    .frame(minHeight: 44)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Изменить срок задачи")
            }
            LineDivider()
            Text("Приоритет").font(.subheadline)
            TaskPriorityOptions(priority: task.taskPriority, onSelect: changePriority)
        }
        .sheet(isPresented: $isDeadlineEditorPresented) {
            TaskDeadlineEditor(date: task.dueDate, onApply: applyDeadline)
        }
    }

    private func showStatusPicker() { model.presentStatusPicker(for: task) }
    private func showDeadlineEditor() { isDeadlineEditorPresented = true }
    private func applyDeadline(_ date: Date?) { model.updateDeadline(of: task.id, to: date) }
    private func changePriority(_ priority: TaskPriority) { model.updatePriority(of: task.id, to: priority) }
}
