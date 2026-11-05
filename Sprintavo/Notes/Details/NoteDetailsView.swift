import SwiftUI

struct NoteDetailsView: View {
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        ItemDetailsView(item: item, model: model)
    }
}
