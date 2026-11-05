import SwiftUI

struct ProjectItemsSection: View {
    let title: String
    let items: [WorkspaceItem]
    let model: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LineDivider().padding(.bottom, 20)
            Text(title).font(.headline).accessibilityAddTraits(.isHeader)
            if items.isEmpty {
                Text("Пока нет").foregroundStyle(.secondary).padding(.top, 12)
            }
            ForEach(items) { item in
                if item.section == .tasks {
                    TaskRowView(item: item, onOpen: model.open, onChangeStatus: model.presentStatusPicker)
                } else {
                    ItemLinkView(item: item, onOpen: model.open)
                }
                LineDivider()
            }
        }
    }
}
