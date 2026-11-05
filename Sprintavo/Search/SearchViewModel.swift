import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    var query = ""
    private(set) var isPresented = false
    private(set) var resultLimit: Int
    private var items: [WorkspaceItem]
    private let engine: WorkspaceSearch

    init(items: [WorkspaceItem], resultLimit: Int = 3, engine: WorkspaceSearch = WorkspaceSearch()) {
        self.items = items
        self.resultLimit = resultLimit
        self.engine = engine
    }

    var results: [WorkspaceItem] {
        engine.results(for: query, in: items, limit: resultLimit)
    }

    func updateItems(_ items: [WorkspaceItem], resultLimit: Int? = nil) {
        self.items = items
        if let resultLimit { self.resultLimit = resultLimit }
    }

    func open() {
        isPresented = true
    }

    func close() {
        isPresented = false
        query = ""
    }
}
