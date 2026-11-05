import SwiftUI

struct ItemDetailsView: View {
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        ScreenContent {
            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                Text(item.subtitle).foregroundStyle(.secondary)
            }
            LineDivider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Описание").font(.headline)
                Text(item.details)
            }
            if let project = model.project(for: item) {
                LineDivider()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Проект").font(.headline)
                    ItemLinkView(item: project, onOpen: model.open)
                }
            }
        }
    }
}
