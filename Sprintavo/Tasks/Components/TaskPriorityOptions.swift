import SwiftUI

struct TaskPriorityOptions: View {
    let priority: TaskPriority
    let onSelect: (TaskPriority) -> Void

    var body: some View {
        CompactSelectionRow(options: TaskPriority.allCases, selection: priority, title: \.rawValue, onSelect: onSelect)
    }
}
