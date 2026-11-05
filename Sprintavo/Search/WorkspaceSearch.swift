import Foundation

struct WorkspaceSearch {
    func results(for query: String, in items: [WorkspaceItem], limit: Int) -> [WorkspaceItem] {
        let query = normalized(query)
        guard !query.isEmpty, limit > 0 else { return [] }
        let words = query.split(whereSeparator: { $0.isWhitespace }).map(String.init)
        return items.enumerated().compactMap { index, item -> (item: WorkspaceItem, score: Int, index: Int)? in
            let title = normalized(item.title)
            let steps = item.checklist.map(\.title).joined(separator: " ")
            let context = normalized(item.subtitle + " " + item.details + " " + steps)
            let score: Int
            if title == query {
                score = 0
            } else if title.hasPrefix(query) {
                score = 1
            } else if title.contains(query) {
                score = 2
            } else if words.allSatisfy({ title.contains($0) }) {
                score = 3
            } else if words.allSatisfy({ (title + " " + context).contains($0) }) {
                score = 4
            } else {
                return nil
            }
            return (item, score, index)
        }
        .sorted { lhs, rhs in
            lhs.score == rhs.score ? lhs.index < rhs.index : lhs.score < rhs.score
        }
        .prefix(limit)
        .map(\.item)
    }

    private func normalized(_ text: String) -> String {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "ru_RU"))
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }
}
