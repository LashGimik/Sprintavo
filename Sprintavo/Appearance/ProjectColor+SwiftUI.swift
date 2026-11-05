import SwiftUI

extension ProjectColor {
    var color: Color {
        Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }

    var interfaceAccent: Color {
        let brightness = Double(red) * 0.299 + Double(green) * 0.587 + Double(blue) * 0.114
        return brightness < 65 ? Color(white: 0.65) : color
    }

    var foreground: Color {
        let brightness = Double(red) * 0.299 + Double(green) * 0.587 + Double(blue) * 0.114
        return brightness > 155 ? .black : .white
    }
}
