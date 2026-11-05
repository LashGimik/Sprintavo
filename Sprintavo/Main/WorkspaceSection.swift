import Foundation

enum WorkspaceSection: String, CaseIterable, Identifiable {
    case home = "Главная"
    case overview = "Обзор"
    case projects = "Проекты"
    case tasks = "Задачи"
    case notes = "Заметки"
    case sprints = "Спринты"
    case archive = "Архив"
    case settings = "Настройки"

    var id: Self { self }
    var symbol: String {
        switch self {
        case .home: "house"
        case .overview: "square.grid.2x2"
        case .projects: "folder"
        case .tasks: "checklist"
        case .notes: "note.text"
        case .sprints: "timer"
        case .archive: "archivebox"
        case .settings: "gearshape"
        }
    }
}
