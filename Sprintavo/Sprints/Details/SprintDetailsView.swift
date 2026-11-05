import SwiftUI

struct SprintDetailsView: View {
    let item: WorkspaceItem
    let model: MainViewModel

    var body: some View {
        ItemDetailsView(item: item, model: model)
    }
}
