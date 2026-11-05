import SwiftUI

struct CompactSelectionRow<Option: Identifiable & Equatable>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let options: [Option]
    let selection: Option
    let title: KeyPath<Option, String>
    let onSelect: (Option) -> Void

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            ScrollView(.horizontal) {
                HStack(spacing: 6) {
                    ForEach(options) { option in
                        CompactSelectionButton(title: option[keyPath: title], isSelected: option == selection, fillsWidth: false) {
                            onSelect(option)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        } else {
            HStack(spacing: 6) {
                ForEach(options) { option in
                    CompactSelectionButton(title: option[keyPath: title], isSelected: option == selection) {
                        onSelect(option)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
