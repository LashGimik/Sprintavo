import Foundation

struct ProjectColor: Hashable, Codable {
    let red: Int
    let green: Int
    let blue: Int

    init(red: Int, green: Int, blue: Int) {
        self.red = min(255, max(0, red))
        self.green = min(255, max(0, green))
        self.blue = min(255, max(0, blue))
    }

    static let yellow = ProjectColor(red: 235, green: 242, blue: 77)
    static let coral = ProjectColor(red: 245, green: 128, blue: 112)
    static let blue = ProjectColor(red: 107, green: 180, blue: 245)
    static let mint = ProjectColor(red: 112, green: 210, blue: 172)
    static let lilac = ProjectColor(red: 182, green: 150, blue: 235)
    static let gray = ProjectColor(red: 165, green: 173, blue: 180)
    static let presets: [ProjectColor] = [.yellow, .coral, .blue, .mint, .lilac, .gray]
}
