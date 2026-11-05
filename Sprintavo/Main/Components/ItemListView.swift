import SwiftUI

struct ItemListView: View {
    let items: [WorkspaceItem]
    let onOpen: (WorkspaceItem) -> Void

    var body: some View {
        if items.isEmpty {
            ContentUnavailableView("Пока пусто", systemImage: "tray", description: Text("Здесь появятся ваши данные."))
        } else {
            ScreenContent(spacing: 0) {
                ForEach(items) { item in
                    ItemLinkView(item: item, onOpen: onOpen)
                    LineDivider()
                }
            }
        }
    }
}
