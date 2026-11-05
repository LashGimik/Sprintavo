import SwiftUI

struct TaskEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) private var theme
    @State private var model: TaskEditorViewModel
    @State private var checklistStatusPicker = ChecklistStatusPickerModel()
    @State private var isStatusPickerPresented = false
    @State private var isDiscardPresented = false
    let project: WorkspaceItem
    let onSave: (WorkspaceItem) -> Void

    init(project: WorkspaceItem, task: WorkspaceItem? = nil, onSave: @escaping (WorkspaceItem) -> Void) {
        self.project = project
        self.onSave = onSave
        _model = State(initialValue: TaskEditorViewModel(task: task))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(model.isEditing ? "Редактирование задачи" : "Новая задача").font(.title2.bold())
                Spacer()
                IconButton(title: "Закрыть", symbol: "xmark", action: requestClose)
            }
            .padding(20)
            ScreenContent {
                Label {
                    Text(project.title).font(.subheadline)
                } icon: {
                    ProjectSymbol(color: project.projectColor)
                }
                ColoredTextField(title: "Название", placeholder: "Что нужно сделать?", text: $model.title, dismissFocusTrigger: isDiscardPresented || isStatusPickerPresented || checklistStatusPicker.isPresented, maximumLength: TaskTitleRules.maximumLength)
                Text("\(model.title.count) / \(TaskTitleRules.maximumLength)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                if model.title.count > TaskTitleRules.maximumLength {
                    Text("Сократите название до \(TaskTitleRules.maximumLength) символов.")
                        .font(.footnote).foregroundStyle(theme.secondaryText)
                }
                ColoredTextField(title: "Описание · необязательно", placeholder: "Детали задачи", text: $model.details, multiline: true, dismissFocusTrigger: isDiscardPresented || isStatusPickerPresented || checklistStatusPicker.isPresented)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Шаги задачи · необязательно").font(.headline)
                    TaskChecklistEditor(items: $model.checklist, statusPicker: checklistStatusPicker, dismissFocusTrigger: isDiscardPresented || isStatusPickerPresented || checklistStatusPicker.isPresented)
                }
                HStack {
                    Text("Статус").font(.headline)
                    Spacer()
                    TaskStatusControl(status: model.status, action: showStatusPicker)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Приоритет").font(.headline)
                    TaskPriorityOptions(priority: model.priority, onSelect: selectPriority)
                }
                LineDivider()
                TaskDueDateField(isEnabled: $model.hasDueDate, date: $model.dueDate)
                FilledActionButton(title: model.isEditing ? "Применить изменения" : "Создать задачу", isEnabled: model.canCreate, action: create)
            }
        }
        .allowsHitTesting(!isStatusPickerPresented && !isDiscardPresented && !checklistStatusPicker.isPresented)
        .accessibilityHidden(isStatusPickerPresented || isDiscardPresented || checklistStatusPicker.isPresented)
        .background { ScreenBackground() }
        .foregroundStyle(theme.text)
        .tint(theme.text)
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled(model.hasChanges)
        .onDisappear { checklistStatusPicker.close() }
        .overlay {
            ChecklistStatusPicker(model: checklistStatusPicker)
            TaskStatusPicker(status: model.status, isPresented: isStatusPickerPresented, onSelect: selectStatus, onCancel: closeStatusPicker)
            ConfirmationOverlay(isPresented: isDiscardPresented, title: model.isEditing ? "Отменить изменения?" : "Отменить создание задачи?", message: "Введённые данные будут удалены.", confirmTitle: "Удалить ввод", cancelTitle: "Продолжить заполнение", onConfirm: close, onCancel: cancelDiscard)
        }
    }

    private func selectPriority(_ priority: TaskPriority) { model.priority = priority }
    private func showStatusPicker() { isStatusPickerPresented = true }
    private func closeStatusPicker() { isStatusPickerPresented = false }
    private func selectStatus(_ status: TaskStatus) {
        model.status = status
        closeStatusPicker()
    }
    private func requestClose() {
        if model.hasChanges { isDiscardPresented = true } else { close() }
    }
    private func cancelDiscard() { isDiscardPresented = false }
    private func close() { dismiss() }
    private func create() {
        guard let task = model.makeTask(in: project) else { return }
        onSave(task)
        dismiss()
    }
}
