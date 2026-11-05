import SwiftUI

struct TaskDetailsTabs: View {
    @Binding var selection: TaskDetailsTab

    var body: some View {
        CompactSelectionRow(options: TaskDetailsTab.allCases, selection: selection, title: \.rawValue) {
            selection = $0
        }
    }
}
