import Foundation
import Observation

@MainActor
@Observable
final class MainViewModel {
    private(set) var rootRoute: WorkspaceRoute = .section(.home, project: nil)
    private(set) var path: [WorkspaceRoute] = []
    var isMenuPresented = false
    var isProjectEditorPresented = false
    var isTaskListOptionsPresented = false
    private(set) var activeTaskListOptions = TaskListViewModel()
    var taskEditorProject: WorkspaceItem?
    var statusPickerTaskID: UUID?
    var editedTask: WorkspaceItem?
    var pendingTaskDeletionID: UUID?
    private(set) var isShowingArchivedProjects = false
    private(set) var items: [WorkspaceItem]
    let checklistStatusPicker = ChecklistStatusPickerModel()
    let search: SearchViewModel
    let projectSearch: SearchViewModel
    @ObservationIgnored private var taskListStates: [UUID: TaskListViewModel] = [:]
    private(set) var selectedProject: WorkspaceItem?

    init() {
        let items = DemoWorkspace.items
        self.items = items
        self.search = SearchViewModel(items: items)
        let projects = items.filter { $0.section == .projects && !$0.isArchived }
        self.projectSearch = SearchViewModel(items: projects, resultLimit: projects.count)
        self.selectedProject = projects.first
    }

    var currentRoute: WorkspaceRoute { path.last ?? rootRoute }
    var headerSection: WorkspaceSection { currentRoute.section }
    var currentPageID: String { currentRoute.id }
    var canGoBack: Bool { !path.isEmpty }
    var hasBreadcrumbs: Bool { !breadcrumbs.isEmpty }

    var openedProject: WorkspaceItem? {
        switch currentRoute {
        case let .section(_, project): project
        case let .item(item): item.section == .projects ? item : project(for: item)
        }
    }

    var pages: [WorkspacePage] {
        ([rootRoute] + path).map { WorkspacePage(route: $0) }
    }

    func select(_ section: WorkspaceSection) {
        let project = isProjectSection(section) ? selectedProject : nil
        if isProjectSection(section) && project == nil {
            openMenu()
            return
        }
        let isCurrentProject = !isProjectSection(section) || openedProject?.id == project?.id
        if headerSection == section && isCurrentProject {
            closeMenu()
            search.close()
            return
        }
        rootRoute = .section(section, project: project)
        path.removeAll()
        search.close()
        closeMenu()
    }

    func open(_ item: WorkspaceItem) {
        search.close()
        navigate(to: .item(item))
    }

    func navigate(to route: WorkspaceRoute) {
        let project: WorkspaceItem?
        switch route {
        case let .section(_, context): project = context
        case let .item(item): project = item.section == .projects ? item : self.project(for: item)
        }
        if let project, !project.isArchived {
            selectedProject = project
        }
        if route.id == rootRoute.id {
            path.removeAll()
        } else if case let .section(.overview, project?) = route,
                  let index = path.firstIndex(where: { $0.id == WorkspaceRoute.item(project).id }) {
            path = Array(path.prefix(index + 1))
        } else if let index = path.firstIndex(where: { $0.id == route.id }) {
            path = Array(path.prefix(index + 1))
        } else {
            path.append(route)
        }
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    var breadcrumbs: [WorkspaceBreadcrumb] {
        guard let project = openedProject else { return [] }
        let section = headerSection
        let overview: WorkspaceRoute = .section(.overview, project: project)
        var result = [WorkspaceBreadcrumb(
            id: "project", title: project.title,
            route: section == .overview || project.isArchived ? nil : overview
        )]
        if section != .overview {
            let target: WorkspaceRoute = .section(section, project: project.isArchived ? nil : project)
            result.append(WorkspaceBreadcrumb(
                id: "section", title: section.rawValue,
                route: currentRoute == target ? nil : target
            ))
        }
        if case let .item(item) = currentRoute, item.section != .projects {
            result.append(WorkspaceBreadcrumb(id: "current", title: "…", route: nil))
        }
        return result
    }

    func openMenu() {
        search.close()
        projectSearch.close()
        isMenuPresented = true
    }

    func closeMenu() {
        projectSearch.close()
        isMenuPresented = false
    }

    func presentProjectEditor() {
        search.close()
        projectSearch.close()
        isProjectEditorPresented = true
    }

    func addProject(_ project: WorkspaceItem) {
        guard project.section == .projects, !project.isArchived,
              !items.contains(where: { $0.id == project.id }) else { return }
        items.insert(project, at: 0)
        selectedProject = project
        refreshSearch()
    }

    func item(withID id: UUID) -> WorkspaceItem? {
        items.first { $0.id == id }
    }

    var canCreateTask: Bool {
        guard case let .section(.tasks, project?) = currentRoute else { return false }
        return !project.isArchived
    }

    func presentTaskEditor() {
        guard canCreateTask, let project = openedProject else { return }
        taskEditorProject = project
    }

    func presentTaskListOptions(_ state: TaskListViewModel) {
        activeTaskListOptions = state
        isTaskListOptionsPresented = true
    }

    func taskListState(for projectID: UUID) -> TaskListViewModel {
        if let state = taskListStates[projectID] { return state }
        let state = TaskListViewModel()
        taskListStates[projectID] = state
        return state
    }

    func addTask(_ task: WorkspaceItem) {
        guard task.section == .tasks, let projectID = task.projectID,
              items.contains(where: { $0.id == projectID && $0.section == .projects && !$0.isArchived }),
              !items.contains(where: { $0.id == task.id }),
              let title = TaskTitleRules.normalized(task.title) else { return }
        guard let steps = TaskChecklistRules.normalized(task.checklist) else { return }
        var newTask = task
        newTask.checklist = steps
        newTask.title = title
        items.insert(newTask, at: 0)
        refreshSearch()
    }

    func presentStatusPicker(for task: WorkspaceItem) {
        guard task.section == .tasks, item(withID: task.id) != nil else { return }
        statusPickerTaskID = task.id
    }

    func closeStatusPicker() { statusPickerTaskID = nil }

    func updateStatus(of id: UUID, to status: TaskStatus) {
        guard let index = items.firstIndex(where: { $0.id == id && $0.section == .tasks }) else { return }
        items[index].taskStatus = status
        let projectTitle = project(for: items[index])?.title ?? ""
        items[index].subtitle = status.rawValue + (projectTitle.isEmpty ? "" : " · " + projectTitle)
        refreshSearch()
        closeStatusPicker()
    }

    var currentTask: WorkspaceItem? {
        guard case let .item(item) = currentRoute, item.section == .tasks else { return nil }
        return self.item(withID: item.id)
    }

    func editCurrentTask() {
        guard let task = currentTask else { return }
        editTask(task)
    }

    func editTask(_ task: WorkspaceItem) {
        guard let latest = item(withID: task.id), latest.section == .tasks else { return }
        editedTask = latest
    }

    func updateTask(_ task: WorkspaceItem) {
        guard let index = items.firstIndex(where: { $0.id == task.id && $0.section == .tasks }),
              items[index].projectID == task.projectID,
              let title = TaskTitleRules.normalized(task.title) else { return }
        guard let steps = TaskChecklistRules.normalized(task.checklist) else { return }
        items[index].title = title
        items[index].details = task.details.trimmingCharacters(in: .whitespacesAndNewlines)
        items[index].subtitle = task.subtitle
        items[index].taskStatus = task.taskStatus
        items[index].taskPriority = task.taskPriority
        items[index].dueDate = task.dueDate
        items[index].checklist = steps
        refreshSearch()
    }

    func replaceChecklist(of taskID: UUID, with steps: [TaskChecklistItem], expected: [TaskChecklistItem]) -> Bool {
        guard let index = items.firstIndex(where: { $0.id == taskID && $0.section == .tasks }),
              items[index].checklist == expected,
              let normalized = TaskChecklistRules.normalized(steps) else { return false }
        items[index].checklist = normalized
        refreshSearch()
        return true
    }

    func presentChecklistStatusPicker(of taskID: UUID, itemID: UUID) {
        guard let task = item(withID: taskID), task.section == .tasks,
              let step = task.checklist.first(where: { $0.id == itemID }) else { return }
        checklistStatusPicker.present(status: step.status) { [weak self] status in
            self?.updateChecklistStatus(of: taskID, itemID: itemID, to: status)
        }
    }

    private func updateChecklistStatus(of taskID: UUID, itemID: UUID, to status: ChecklistStatus) {
        guard let taskIndex = items.firstIndex(where: { $0.id == taskID && $0.section == .tasks }),
              let stepIndex = items[taskIndex].checklist.firstIndex(where: { $0.id == itemID }) else { return }
        items[taskIndex].checklist[stepIndex].status = status
        refreshSearch()
    }

    func updateDescription(of id: UUID, text: String) {
        guard let index = items.firstIndex(where: { $0.id == id && $0.section == .tasks }) else { return }
        items[index].details = text.trimmingCharacters(in: .whitespacesAndNewlines)
        refreshSearch()
    }

    func updatePriority(of id: UUID, to priority: TaskPriority) {
        guard let index = items.firstIndex(where: { $0.id == id && $0.section == .tasks }) else { return }
        items[index].taskPriority = priority
        refreshSearch()
    }

    func requestCurrentTaskDeletion() {
        pendingTaskDeletionID = currentTask?.id
    }

    func cancelTaskDeletion() { pendingTaskDeletionID = nil }

    func deleteRequestedTask() {
        guard let id = pendingTaskDeletionID else { return }
        items.removeAll { $0.id == id && $0.section == .tasks }
        if let index = path.firstIndex(where: { route in
            if case let .item(item) = route { return item.id == id }
            return false
        }) {
            path = Array(path.prefix(index))
        }
        if statusPickerTaskID == id { statusPickerTaskID = nil }
        if editedTask?.id == id { editedTask = nil }
        pendingTaskDeletionID = nil
        refreshSearch()
    }

    func updateDeadline(of id: UUID, to date: Date?) {
        guard let index = items.firstIndex(where: { $0.id == id && $0.section == .tasks }) else { return }
        items[index].dueDate = date.map { Calendar.current.startOfDay(for: $0) }
        refreshSearch()
    }

    private func refreshSearch() {
        search.updateItems(items)
        let projects = records(in: .projects)
        projectSearch.updateItems(projects, resultLimit: projects.count)
    }

    func chooseProject(_ project: WorkspaceItem) {
        guard project.section == .projects, !project.isArchived else { return }
        selectedProject = project
        projectSearch.close()
    }

    func isMenuSectionActive(_ candidate: WorkspaceSection) -> Bool {
        guard let openedProject, !openedProject.isArchived,
              selectedProject?.id == openedProject.id else { return false }
        return isProjectSection(candidate) && headerSection == candidate
    }

    var isProjectListVisible: Bool {
        currentRoute == .section(.projects, project: nil)
    }

    var isHomeVisible: Bool {
        currentRoute == .section(.home, project: nil)
    }

    var listedProjects: [WorkspaceItem] {
        records(in: isShowingArchivedProjects ? .archive : .projects)
    }

    func toggleProjectsArchive() {
        guard isProjectListVisible else { return }
        isShowingArchivedProjects.toggle()
    }

    func records(in section: WorkspaceSection, scopedToProject: Bool = true, project: WorkspaceItem? = nil) -> [WorkspaceItem] {
        items.filter { item in
            if section == .archive {
                return item.section == .projects && item.isArchived
            }
            guard item.section == section && !item.isArchived else { return false }
            if scopedToProject && isProjectSection(section) {
                guard let context = project ?? openedProject else { return false }
                return item.projectID == context.id
            }
            return true
        }
    }

    private func isProjectSection(_ section: WorkspaceSection) -> Bool {
        [.overview, .tasks, .notes, .sprints].contains(section)
    }

    func related(to project: WorkspaceItem, in section: WorkspaceSection) -> [WorkspaceItem] {
        items.filter { $0.projectID == project.id && $0.section == section }
    }

    func project(for item: WorkspaceItem) -> WorkspaceItem? {
        items.first { $0.id == item.projectID }
    }
}
