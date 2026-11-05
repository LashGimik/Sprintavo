import SwiftUI

struct TaskListView: View {
    @State private var state: TaskListViewModel
    let project: WorkspaceItem?
    let model: MainViewModel

    init(project: WorkspaceItem?, model: MainViewModel) {
        self.project = project
        self.model = model
        _state = State(initialValue: project.map { model.taskListState(for: $0.id) } ?? TaskListViewModel())
    }

    var body: some View {
        let tasks = model.records(in: .tasks, project: project)
        let groups = state.groups(from: tasks)
        VStack(spacing: 12) {
            TaskListToolbar(state: state, onShowOptions: showOptions, dismissFocusTrigger: shouldDismissSearchFocus)
            if tasks.isEmpty {
                ContentUnavailableView("Пока нет задач", systemImage: "checklist", description: Text("Нажмите «+», чтобы создать первую задачу."))
            } else if groups.isEmpty {
                ContentUnavailableView {
                    Label("Нет подходящих задач", systemImage: "magnifyingglass")
                } description: {
                    Text("Измените запрос или фильтры.")
                } actions: {
                    Button("Сбросить фильтры и поиск", action: state.reset)
                }
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(groups) { group in
                            TaskListGroupView(group: group, state: state, model: model)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }

    private var shouldDismissSearchFocus: Bool {
        model.currentRoute.id != WorkspaceRoute.section(.tasks, project: project).id ||
        model.isMenuPresented || model.taskEditorProject != nil || model.statusPickerTaskID != nil || model.isTaskListOptionsPresented
    }

    private func showOptions() { model.presentTaskListOptions(state) }
}
