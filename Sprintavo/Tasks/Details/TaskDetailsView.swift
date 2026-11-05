import SwiftUI

struct TaskDetailsView: View {
    @State private var checklistState = TaskChecklistViewModel()
    @State private var tab: TaskDetailsTab = .parameters
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        let task = model.item(withID: item.id) ?? item
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                TaskTitleView(title: task.title)
                TaskDetailsTabs(selection: $tab)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            switch tab {
            case .parameters:
                ScreenContent { TaskParametersView(task: task, model: model) }
            case .description:
                TaskDescriptionView(task: task, onSave: applyDescription)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
            case .steps:
                TaskChecklistSection(task: task, state: checklistState, statusPicker: model.checklistStatusPicker, dismissFocusTrigger: model.pendingTaskDeletionID != nil || model.editedTask != nil, onSave: applyChecklist, onChangeStatus: chooseChecklistStatus)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }
        }
    }

    private func applyChecklist(_ items: [TaskChecklistItem], expected: [TaskChecklistItem]) -> Bool {
        model.replaceChecklist(of: item.id, with: items, expected: expected)
    }

    private func chooseChecklistStatus(_ id: UUID) {
        model.presentChecklistStatusPicker(of: item.id, itemID: id)
    }

    private func applyDescription(_ text: String) {
        model.updateDescription(of: item.id, text: text)
    }
}
