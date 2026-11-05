import SwiftUI

struct TaskRowView: View {
    @Environment(\.appTheme) private var theme
    let item: WorkspaceItem
    var projectName: String? = nil
    let onOpen: (WorkspaceItem) -> Void
    let onChangeStatus: (WorkspaceItem) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button(action: changeStatus) {
                TaskStatusCircle(status: item.taskStatus)
                    .frame(width: 44, height: 44)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Изменить статус задачи \(item.title): \(item.taskStatus.rawValue)")
            VStack(alignment: .leading, spacing: 0) {
                Button(action: openTask) {
                    HStack(spacing: 12) {
                        Text(item.title)
                            .font(.headline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .accessibilityLabel(item.title)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(item.taskStatus.isFinished ? theme.secondaryText : theme.text)
                        Spacer(minLength: 4)
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(theme.secondaryText)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { badges }
                    VStack(alignment: .leading, spacing: 0) { badges }
                }
                if let projectName {
                    Text(projectName).font(.caption).foregroundStyle(theme.secondaryText)
                        .padding(.bottom, 6)
                }
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder private var badges: some View {
        TaskStatusControl(status: item.taskStatus, action: changeStatus)
        if let date = item.dueDate {
            OutlineBadge(title: TaskDeadlineLabel.text(for: date, isCompleted: item.taskStatus.isFinished))
        }
    }

    private func openTask() { onOpen(item) }
    private func changeStatus() { onChangeStatus(item) }
}
