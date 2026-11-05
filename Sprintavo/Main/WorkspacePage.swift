import Foundation

struct WorkspacePage: Identifiable {
    let route: WorkspaceRoute

    var id: String { route.id }
}
