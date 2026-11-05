import SwiftUI

struct ChecklistStatusPicker: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var isTitleFocused: Bool
    let model: ChecklistStatusPickerModel

    var body: some View {
        ZStack {
            Button(action: model.close) { Color.black.opacity(0.7).ignoresSafeArea() }
                .buttonStyle(.plain)
                .accessibilityLabel("Закрыть выбор статуса шага")
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Статус шага").font(.title3.bold()).accessibilityFocused($isTitleFocused)
                    Spacer()
                    IconButton(title: "Закрыть", symbol: "xmark", action: model.close)
                }
                ForEach(ChecklistStatus.allCases) { status in
                    Button(action: { model.select(status) }) {
                        HStack(spacing: 12) {
                            Image(systemName: status.symbol)
                                .foregroundStyle(status.color)
                                .frame(width: 24)
                                .accessibilityHidden(true)
                            Text(status.rawValue)
                            Spacer()
                            if model.status == status {
                                Image(systemName: "checkmark").accessibilityHidden(true)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(model.status == status ? .isSelected : [])
                }
            }
            .padding(20)
            .modifier(PanelStyle(cornerRadius: 16))
            .frame(maxWidth: 360)
            .padding(20)
            .scaleEffect(model.isPresented || reduceMotion ? 1 : 0.96)
            .accessibilityAddTraits(.isModal)
        }
        .opacity(model.isPresented ? 1 : 0)
        .allowsHitTesting(model.isPresented)
        .accessibilityHidden(!model.isPresented)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.isPresented)
        .onChange(of: model.isPresented) { _, presented in isTitleFocused = presented }
    }
}
