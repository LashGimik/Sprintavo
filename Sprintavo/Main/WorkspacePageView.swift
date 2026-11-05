import SwiftUI

struct WorkspacePageView: View {
    let route: WorkspaceRoute
    let model: MainViewModel

    var body: some View {
        switch route {
        case let .item(item):
            ItemDestinationView(item: item, model: model)
        case let .section(section, project):
            SectionView(section: section, project: project, model: model)
        }
    }
}
