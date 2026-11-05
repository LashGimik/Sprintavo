import SwiftUI

struct ItemLinkView: View {
    let item: WorkspaceItem
    let onOpen: (WorkspaceItem) -> Void

    var body: some View {
        Button(action: openItem) {
            ItemRowView(item: item)
        }
        .buttonStyle(.plain)
    }

    private func openItem() {
        onOpen(item)
    }
}
