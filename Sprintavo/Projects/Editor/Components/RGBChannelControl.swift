import SwiftUI

struct RGBChannelControl: View {
    @State private var input: String
    @FocusState private var isFocused: Bool
    let title: String
    let tint: Color
    @Binding var value: Double

    init(title: String, tint: Color, value: Binding<Double>) {
        self.title = title
        self.tint = tint
        _value = value
        let initialValue = value.wrappedValue
        _input = State(initialValue: String(Int(initialValue.isFinite ? min(255, max(0, initialValue.rounded())) : 0)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title).font(.subheadline.weight(.semibold))
                Spacer()
                TextField(title, text: $input)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .frame(width: 64, height: 44)
                    .modifier(PanelStyle(border: tint.opacity(0.65)))
                    .accessibilityLabel("\(title), от 0 до 255")
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
            }
            LinearValueSlider(value: $value, tint: tint)
                .accessibilityLabel(title)
                .accessibilityValue("\(input) из 255")
        }
        .onChange(of: input) { _, newInput in
            updateValue(newInput)
        }
        .onChange(of: value) { _, newValue in
            let number = newValue.isFinite ? min(255, max(0, newValue.rounded())) : 0
            if value != number { value = number }
            input = String(Int(number))
        }
        .onChange(of: isFocused) { _, focused in
            if !focused { input = String(Int(value)) }
        }
    }

    private func updateValue(_ text: String) {
        let digits = String(text.filter { $0 >= "0" && $0 <= "9" }.prefix(3))
        guard let number = Int(digits) else {
            if input != digits { input = digits }
            return
        }
        let clamped = min(255, number)
        let normalized = String(clamped)
        if input != normalized { input = normalized }
        if value != Double(clamped) { value = Double(clamped) }
    }
}
