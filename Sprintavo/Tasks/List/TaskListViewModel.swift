import Foundation
import Observation

@MainActor
@Observable
final class TaskListViewModel {
    var query = ""
    var isSearchPresented = false
    var scope: TaskListScope = .all
    var statusFilter: TaskStatus?
    var sortOrder: TaskSortOrder = .newest
    var areFinishedExpanded = false
    private let search = WorkspaceSearch()

    var isSearchActive: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isFinishedExpansionAutomatic: Bool {
        isSearchActive || scope == .finished || statusFilter?.isFinished == true
    }

    var showsFinished: Bool {
        areFinishedExpanded || isFinishedExpansionAutomatic
    }

    func groups(from tasks: [WorkspaceItem]) -> [TaskListGroup] {
        var matching = tasks.filter {
            $0.section == .tasks && scope.includes($0.taskStatus) &&
            (statusFilter == nil || $0.taskStatus == statusFilter)
        }
        if isSearchActive {
            matching = search.results(for: query, in: matching, limit: matching.count)
        }
        matching.sort(by: sortOrder.precedes)
        let active = matching.filter { !$0.taskStatus.isFinished }
        let finished = matching.filter { $0.taskStatus.isFinished }
        var groups: [TaskListGroup] = []
        if !active.isEmpty { groups.append(TaskListGroup(isFinished: false, tasks: active)) }
        if !finished.isEmpty { groups.append(TaskListGroup(isFinished: true, tasks: finished)) }
        return groups
    }

    func reset() {
        query = ""
        isSearchPresented = false
        scope = .all
        statusFilter = nil
        sortOrder = .newest
        areFinishedExpanded = false
    }

    func toggleFinished() { areFinishedExpanded.toggle() }
}
