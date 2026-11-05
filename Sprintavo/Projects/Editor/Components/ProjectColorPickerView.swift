import SwiftUI

struct ProjectColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) private var theme
    @State private var red: Double
    @State private var green: Double
    @State private var blue: Double
    let onApply: (ProjectColor) -> Void

    init(color: ProjectColor, onApply: @escaping (ProjectColor) -> Void) {
        _red = State(initialValue: Double(color.red))
        _green = State(initialValue: Double(color.green))
        _blue = State(initialValue: Double(color.blue))
        self.onApply = onApply
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Цвет проекта").font(.title2.bold())
                Spacer()
                IconButton(title: "Отменить выбор цвета", symbol: "xmark", action: close)
            }
            .padding(20)
            ScreenContent {
                ProjectPreview(name: "Предпросмотр", color: color)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 8) {
                    ForEach(ProjectColor.presets, id: \.self) { preset in
                        ProjectColorSwatch(color: preset, isSelected: preset == color) {
                            select(preset)
                        }
                    }
                }
                LineDivider()
                RGBChannelControl(title: "R · Красный", tint: .red, value: $red)
                RGBChannelControl(title: "G · Зелёный", tint: .green, value: $green)
                RGBChannelControl(title: "B · Синий", tint: .blue, value: $blue)
                FilledActionButton(title: "Выбрать цвет", action: apply)
            }
        }
        .background { ScreenBackground() }
        .foregroundStyle(theme.text)
        .preferredColorScheme(.dark)
    }

    private var color: ProjectColor {
        ProjectColor(red: channel(red), green: channel(green), blue: channel(blue))
    }

    private func channel(_ value: Double) -> Int {
        Int(value.isFinite ? min(255, max(0, value.rounded())) : 0)
    }

    private func select(_ color: ProjectColor) {
        red = Double(color.red)
        green = Double(color.green)
        blue = Double(color.blue)
    }

    private func close() { dismiss() }

    private func apply() {
        onApply(color)
        dismiss()
    }
}
