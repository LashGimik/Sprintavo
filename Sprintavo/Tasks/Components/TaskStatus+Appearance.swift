import SwiftUI

extension TaskStatus {
    var color: Color {
        switch self {
        case .todo: Color(red: 0.65, green: 0.67, blue: 0.69)
        case .inProgress: Color(red: 0.43, green: 0.70, blue: 0.96)
        case .inReview: Color(red: 0.71, green: 0.59, blue: 0.92)
        case .blocked: Color(red: 0.95, green: 0.63, blue: 0.35)
        case .cancelled: Color(red: 0.56, green: 0.57, blue: 0.59)
        case .done: Color(red: 0.42, green: 0.82, blue: 0.62)
        }
    }
}
