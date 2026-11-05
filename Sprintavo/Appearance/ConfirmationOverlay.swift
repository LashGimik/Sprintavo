import SwiftUI

struct ConfirmationOverlay: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var isTitleFocused: Bool
    let isPresented: Bool
    let title: String
    let message: String
    let confirmTitle: String
    var cancelTitle = "Продолжить"
    var confirmColor: ProjectColor = .coral
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Button(action: onCancel) {
                Color.black.opacity(0.7).ignoresSafeArea()
            }
            .buttonStyle(.plain)
            .accessibilityLabel(cancelTitle)
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.title3.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($isTitleFocused)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                FilledActionButton(title: confirmTitle, color: confirmColor, action: onConfirm)
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .modifier(PanelStyle())
            }
            .padding(24)
            .modifier(PanelStyle(cornerRadius: 16))
            .frame(maxWidth: 360)
            .padding(24)
            .scaleEffect(isPresented || reduceMotion ? 1 : 0.97)
            .accessibilityAddTraits(.isModal)
        }
        .opacity(isPresented ? 1 : 0)
        .allowsHitTesting(isPresented)
        .accessibilityHidden(!isPresented)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: isPresented)
        .onChange(of: isPresented) { _, presented in
            isTitleFocused = presented
        }
    }
}
