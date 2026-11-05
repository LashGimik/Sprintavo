import SwiftUI

struct AppTheme {
    var background = Color(red: 0.065, green: 0.069, blue: 0.073)
    var surface = Color(red: 0.095, green: 0.10, blue: 0.105)
    var text = Color(red: 0.95, green: 0.95, blue: 0.93)
    var secondaryText = Color(red: 0.62, green: 0.64, blue: 0.63)
    var accent = Color(red: 0.92, green: 0.95, blue: 0.30)
    var line = Color(red: 0.25, green: 0.26, blue: 0.26)
    var cornerRadius: CGFloat = 10
}

extension EnvironmentValues {
    @Entry var appTheme = AppTheme()
}
