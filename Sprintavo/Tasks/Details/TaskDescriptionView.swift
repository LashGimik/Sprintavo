import SwiftUI

struct TaskDescriptionView: View {
    @State private var isEditing = false
    @State private var draft = ""
    let task: WorkspaceItem
    let onSave: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isEditing {
                ScrollView {
                    ColoredTextField(title: "Описание", placeholder: "Детали задачи", text: $draft, multiline: true)
                        .padding(.trailing, 8)
                }
                FilledActionButton(title: "Применить", action: apply)
                Button("Отмена", action: cancel)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .buttonStyle(.plain)
            } else {
                Button("Редактировать описание", systemImage: "square.and.pencil", action: beginEditing)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .buttonStyle(.plain)
                LineDivider()
                ScrollView {
                    Text(task.details.isEmpty ? "Без описания" : task.details)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                        .padding(.trailing, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func beginEditing() {
        draft = task.details
        isEditing = true
    }

    private func apply() {
        onSave(draft)
        isEditing = false
    }

    private func cancel() {
        draft = ""
        isEditing = false
    }
}
