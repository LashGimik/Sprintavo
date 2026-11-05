import SwiftUI

struct ProjectColorSwatch: View {
    let color: ProjectColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle().fill(color.color)
                .frame(width: 28, height: 28)
                .padding(6)
                .overlay {
                    Circle().strokeBorder(isSelected ? color.color : .clear, lineWidth: 1)
                }
                .frame(width: 44, height: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("RGB \(color.red), \(color.green), \(color.blue)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
