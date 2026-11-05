import SwiftUI

struct TaskStatusCircle: View {
    let status: TaskStatus
    var size: CGFloat = 22

    var body: some View {
        ZStack {
            Circle().fill(status.color.opacity(status == .done ? 0.9 : 0.12))
            if status == .inProgress || status == .inReview {
                Circle().trim(from: 0, to: status == .inReview ? 0.75 : 0.5)
                    .fill(status.color.opacity(0.7))
                    .rotationEffect(.degrees(-90))
            }
            Circle().strokeBorder(status.color, lineWidth: 1.5)
            if status == .done {
                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.5, weight: .bold))
                    .foregroundStyle(Color.black.opacity(0.8))
            } else if status == .blocked || status == .cancelled {
                Image(systemName: status == .blocked ? "exclamationmark" : "xmark")
                    .font(.system(size: size * 0.5, weight: .semibold))
                    .foregroundStyle(status.color)
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
