import SwiftUI

struct FilledActionButton: View {
    @Environment(\.appTheme) private var theme
    let title: String
    var color: ProjectColor? = nil
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundStyle(color?.foreground ?? theme.text)
                .modifier(PanelStyle(fill: color?.color, border: theme.line))
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
}
