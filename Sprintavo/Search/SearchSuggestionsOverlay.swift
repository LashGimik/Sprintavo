import SwiftUI

struct SearchSuggestionsOverlay: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var displayedResults: [WorkspaceItem] = []
    @State private var isVisible = false
    let results: [WorkspaceItem]
    let isSearchPresented: Bool
    let rowHeight: CGFloat
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        SearchSuggestionsView(results: displayedResults, onSelect: onSelect)
            .transaction { transaction in
                transaction.animation = nil
            }
            .fixedSize(horizontal: false, vertical: true)
            .mask(alignment: .top) {
                Rectangle()
                    .scaleEffect(y: isVisible || reduceMotion ? 1 : 0, anchor: .top)
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: rowHeight + (isVisible ? 8 : 0))
            .allowsHitTesting(isVisible)
            .accessibilityHidden(!isVisible)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: isVisible)
            .onChange(of: results, initial: true) { _, _ in
                updatePresentation()
            }
            .onChange(of: isSearchPresented) { _, _ in
                updatePresentation()
            }
    }

    private func updatePresentation() {
        if !results.isEmpty {
            displayedResults = results
        }
        isVisible = isSearchPresented && !results.isEmpty
    }
}
