import SwiftUI

struct ColoredTextField: View {
    @Environment(\.appTheme) private var theme
    @FocusState private var isFocused: Bool
    @State private var inputText = ""
    let title: String
    let placeholder: String
    @Binding var text: String
    var accent: Color? = nil
    var multiline = false
    var dismissFocusTrigger = false
    var maximumLength: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.weight(.semibold))
                .foregroundStyle(accent ?? theme.text)
            TextField(placeholder, text: maximumLength == nil ? $text : $inputText, axis: multiline ? .vertical : .horizontal)
                .textFieldStyle(.plain)
                .lineLimit(multiline ? 5 : 1)
                .focused($isFocused)
                .tint(accent ?? theme.text)
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: multiline ? 110 : 52, alignment: .topLeading)
                .modifier(PanelStyle(
                    fill: theme.surface,
                    border: isFocused ? (accent ?? theme.secondaryText) : theme.line
                ))
                .accessibilityLabel(title)
        }
        .onAppear { inputText = text }
        .onChange(of: inputText) { _, value in
            guard let maximumLength, value != text else { return }
            let limited = String(value.prefix(maximumLength))
            if inputText != limited { inputText = limited }
            if text != limited { text = limited }
        }
        .onChange(of: text) { _, value in
            if inputText != value { inputText = value }
        }
        .onChange(of: dismissFocusTrigger) { _, shouldDismiss in
            if shouldDismiss { isFocused = false }
        }
    }
}
