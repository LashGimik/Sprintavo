import SwiftUI

struct NoteListView: View {
    let project: WorkspaceItem?
    let model: MainViewModel

    var body: some View {
        ItemListView(items: model.records(in: .notes, project: project), onOpen: model.open)
    }
}
