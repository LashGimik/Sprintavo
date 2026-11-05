import Foundation
import Observation

@MainActor
@Observable
final class ProjectEditorViewModel {
    var name = ""
    var description = ""
    var color: ProjectColor = .yellow
    private(set) var hasSubmitted = false

    var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !hasSubmitted
    }

    var hasChanges: Bool {
        !name.isEmpty || !description.isEmpty || color != .yellow
    }

    func makeProject() -> WorkspaceItem? {
        guard canCreate else { return nil }
        let title = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let details = description.trimmingCharacters(in: .whitespacesAndNewlines)
        hasSubmitted = true
        return WorkspaceItem(
            section: .projects, title: title,
            subtitle: details.isEmpty ? "Без описания" : details,
            details: details, projectColor: color
        )
    }
}
