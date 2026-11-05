import Foundation

enum TaskChecklistRules {
    static func normalized(_ items: [TaskChecklistItem]) -> [TaskChecklistItem]? {
        guard Set(items.map(\.id)).count == items.count else { return nil }
        var result = items
        for index in result.indices {
            result[index].title = result[index].title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !result[index].title.isEmpty else { return nil }
        }
        return result
    }
}
