import Foundation
import Observation

@MainActor
@Observable
final class TaskChecklistViewModel {
    var items: [TaskChecklistItem] = []
    private(set) var originalItems: [TaskChecklistItem] = []
    private(set) var isEditing = false
    var error: String?

    var canApply: Bool { TaskChecklistRules.normalized(items) != nil }

    func begin(_ items: [TaskChecklistItem]) {
        self.items = items
        originalItems = items
        error = nil
        isEditing = true
    }

    func cancel() {
        items = []
        originalItems = []
        isEditing = false
        error = nil
    }

    func hasConflict(with latest: [TaskChecklistItem]) -> Bool {
        isEditing && latest != originalItems
    }
}
