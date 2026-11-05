import SwiftUI

struct WorkspaceItemIcon: View {
    let item: WorkspaceItem
    var size: CGFloat = 24
    var tint: Color = .secondary

    var body: some View {
        if item.section == .projects {
            ProjectSymbol(color: item.projectColor, size: size * 0.85)
                .frame(width: size, height: size)
        } else if item.section == .tasks {
            TaskStatusCircle(status: item.taskStatus, size: size)
        } else {
            Image(systemName: item.section == .tasks ? "circle" : item.section.symbol)
                .font(.system(size: size * 0.8))
                .foregroundStyle(tint)
                .frame(width: size, height: size)
                .accessibilityHidden(true)
        }
    }
}
