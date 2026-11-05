import SwiftUI

struct SprintListView: View {
    let project: WorkspaceItem?
    let model: MainViewModel

    var body: some View {
        ItemListView(items: model.records(in: .sprints, project: project), onOpen: model.open)
    }
}
