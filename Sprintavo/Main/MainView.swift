import SwiftUI

struct MainView: View {
    @State private var model = MainViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.appTheme) private var theme

    var body: some View {
        ZStack {
            ScreenContainerView(model: model) {
                ZStack {
                    ForEach(model.pages) { page in
                        WorkspacePageView(route: page.route, model: model)
                            .opacity(page.id == model.currentPageID ? 1 : 0)
                            .allowsHitTesting(page.id == model.currentPageID)
                            .accessibilityHidden(page.id != model.currentPageID)
                            .transition(.opacity)
                    }
                }
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.18), value: model.path)
            }
            .accessibilityHidden(model.isMenuPresented || model.statusPickerTaskID != nil || model.pendingTaskDeletionID != nil || model.isTaskListOptionsPresented || model.checklistStatusPicker.isPresented)
            .allowsHitTesting(!model.isMenuPresented && model.statusPickerTaskID == nil && model.pendingTaskDeletionID == nil && !model.isTaskListOptionsPresented && !model.checklistStatusPicker.isPresented)

            GeometryReader { geometry in
                ZStack {
                    Button(action: closeMenu) {
                        Color.black.opacity(0.65).ignoresSafeArea()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Закрыть выбор разделов")
                    NavigationMenuView(model: model)
                        .frame(width: min(480, max(0, geometry.size.width - 32)), height: min(660, max(0, geometry.size.height - 32)))
                        .scaleEffect(model.isMenuPresented || reduceMotion ? 1 : 0.97)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .opacity(model.isMenuPresented ? 1 : 0)
            .allowsHitTesting(model.isMenuPresented)
            .accessibilityHidden(!model.isMenuPresented)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.isMenuPresented)
        }
        .overlay {
            ChecklistStatusPicker(model: model.checklistStatusPicker)
            TaskListOptionsView(state: model.activeTaskListOptions, isPresented: $model.isTaskListOptionsPresented)
            TaskStatusPicker(
                status: model.statusPickerTaskID.flatMap { model.item(withID: $0)?.taskStatus } ?? .todo,
                isPresented: model.statusPickerTaskID != nil,
                onSelect: changeStatus,
                onCancel: model.closeStatusPicker
            )
            ConfirmationOverlay(
                isPresented: model.pendingTaskDeletionID != nil,
                title: "Удалить задачу?",
                message: "Задача будет удалена. Это действие нельзя отменить.",
                confirmTitle: "Удалить задачу",
                cancelTitle: "Оставить задачу",
                onConfirm: model.deleteRequestedTask,
                onCancel: model.cancelTaskDeletion
            )
        }
        .foregroundStyle(theme.text)
        .tint(theme.accent)
        .preferredColorScheme(.dark)
        #if os(iOS)
        .fullScreenCover(item: $model.editedTask) { task in
            if let project = model.project(for: task) {
                TaskEditorView(project: project, task: task, onSave: model.updateTask)
            }
        }
        .fullScreenCover(item: $model.taskEditorProject) { project in
            TaskEditorView(project: project, onSave: model.addTask)
        }
        .fullScreenCover(isPresented: $model.isProjectEditorPresented) {
            ProjectEditorView(onCreate: model.addProject)
        }
        #else
        .sheet(item: $model.editedTask) { task in
            if let project = model.project(for: task) {
                TaskEditorView(project: project, task: task, onSave: model.updateTask)
            }
        }
        .sheet(item: $model.taskEditorProject) { project in
            TaskEditorView(project: project, onSave: model.addTask)
        }
        .sheet(isPresented: $model.isProjectEditorPresented) {
            ProjectEditorView(onCreate: model.addProject)
        }
        #endif
    }

    private func changeStatus(_ status: TaskStatus) {
        guard let id = model.statusPickerTaskID else { return }
        model.updateStatus(of: id, to: status)
    }

    private func closeMenu() {
        model.closeMenu()
    }
}
