import SwiftUI

struct TaskStatusPicker: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var displayedStatus: TaskStatus = .todo
    @AccessibilityFocusState private var isTitleFocused: Bool
    let status: TaskStatus
    let isPresented: Bool
    let onSelect: (TaskStatus) -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Button(action: onCancel) {
                Color.black.opacity(0.7).ignoresSafeArea()
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Закрыть выбор статуса")
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Статус задачи").font(.title3.bold()).accessibilityFocused($isTitleFocused)
                    Spacer()
                    IconButton(title: "Закрыть", symbol: "xmark", action: onCancel)
                }
                ForEach(TaskStatus.allCases) { option in
                    Button(action: { onSelect(option) }) {
                        HStack(spacing: 12) {
                            TaskStatusCircle(status: option)
                            Text(option.rawValue)
                            Spacer()
                            if displayedStatus == option {
                                Image(systemName: "checkmark").foregroundStyle(option.color)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(displayedStatus == option ? .isSelected : [])
                }
            }
            .padding(20)
            .modifier(PanelStyle(cornerRadius: 16))
            .frame(maxWidth: 360)
            .padding(20)
            .accessibilityAddTraits(.isModal)
            .scaleEffect(isPresented || reduceMotion ? 1 : 0.96)
        }
        .opacity(isPresented ? 1 : 0)
        .allowsHitTesting(isPresented)
        .accessibilityHidden(!isPresented)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: isPresented)
        .onChange(of: isPresented, initial: true) { _, presented in
            if presented { displayedStatus = status }
            isTitleFocused = presented
        }
        .onChange(of: status) { _, newStatus in
            if isPresented { displayedStatus = newStatus }
        }
    }
}
