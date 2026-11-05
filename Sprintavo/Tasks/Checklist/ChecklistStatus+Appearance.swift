import SwiftUI

extension ChecklistStatus {
    var symbol: String {
        switch self {
        case .todo: "square"
        case .inProgress: "circle.lefthalf.filled"
        case .postponed: "pause.circle"
        case .completed: "checkmark.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .todo: .gray
        case .inProgress: Color(red: 0.43, green: 0.70, blue: 0.96)
        case .postponed: Color(red: 0.95, green: 0.68, blue: 0.40)
        case .completed: Color(red: 0.42, green: 0.82, blue: 0.62)
        }
    }
}
