import SwiftUI

struct SearchSuggestionsView: View {
    let results: [WorkspaceItem]
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(results.enumerated()), id: \.element.id) { index, item in
                if index > 0 {
                    LineDivider().padding(.horizontal, 12)
                }
                SearchResultRow(item: item, onSelect: onSelect)
            }
        }
        .modifier(PanelStyle())
    }
}
