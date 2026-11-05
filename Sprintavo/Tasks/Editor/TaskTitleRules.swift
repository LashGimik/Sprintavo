import Foundation

enum TaskTitleRules {
    static let maximumLength = 80

    static func normalized(_ text: String) -> String? {
        let title = text.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
        guard !title.isEmpty, title.count <= maximumLength else { return nil }
        return title
    }
}
