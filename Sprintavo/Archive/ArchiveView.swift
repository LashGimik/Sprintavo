import SwiftUI

struct ArchiveView: View {
    let model: MainViewModel

    var body: some View {
        ItemListView(items: model.records(in: .archive), onOpen: model.open)
    }
}
