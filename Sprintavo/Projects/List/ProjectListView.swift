import SwiftUI

struct ProjectListView: View {
    let model: MainViewModel

    var body: some View {
        ItemListView(items: model.listedProjects, onOpen: model.open)
    }
}
