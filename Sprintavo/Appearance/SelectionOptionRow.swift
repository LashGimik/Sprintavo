import SwiftUI

struct SelectionOptionRow: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(title).font(.subheadline)
            Spacer()
            if isSelected { Image(systemName: "checkmark").accessibilityHidden(true) }
        }
        .frame(maxWidth: .infinity, minHeight: 44)
        .contentShape(.rect)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
