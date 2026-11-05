import SwiftUI

struct TaskListGroupView: View {
    let group: TaskListGroup
    @Bindable var state: TaskListViewModel
    let model: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if group.isFinished && !state.isFinishedExpansionAutomatic {
                Button(action: state.toggleFinished) {
                    HStack {
                        Text("\(group.title) · \(group.tasks.count)").font(.subheadline.weight(.semibold))
                        Spacer()
                        Image(systemName: state.showsFinished ? "chevron.up" : "chevron.down").font(.caption)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityValue(state.showsFinished ? "Развёрнуто" : "Свёрнуто")
            } else {
                Text("\(group.title) · \(group.tasks.count)")
                    .font(.subheadline.weight(.semibold))
                    .frame(minHeight: 44)
                    .accessibilityAddTraits(.isHeader)
            }
            if !group.isFinished || state.showsFinished {
                ForEach(group.tasks) { task in
                    TaskRowView(item: task, onOpen: model.open, onChangeStatus: model.presentStatusPicker)
                    LineDivider()
                }
            }
        }
    }
}
