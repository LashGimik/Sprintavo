import SwiftUI

struct TaskDetailsControls: View {
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ExpandingControlGroup(isExpanded: true, axis: .horizontal) {
            IconButton(title: "Редактировать задачу", symbol: "pencil", action: onEdit)
        } secondary: {
            IconButton(title: "Удалить задачу", symbol: "trash", action: onDelete)
        }
    }
}
