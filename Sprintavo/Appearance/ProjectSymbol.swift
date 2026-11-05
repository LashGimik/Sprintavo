import SwiftUI

struct ProjectSymbol: View {
    @Environment(\.appTheme) private var theme
    let color: ProjectColor
    var size: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            let points = [
                CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.18),
                CGPoint(x: geometry.size.width * 0.18, y: geometry.size.height * 0.78),
                CGPoint(x: geometry.size.width * 0.82, y: geometry.size.height * 0.78)
            ]
            ZStack {
                Path { path in
                    path.move(to: points[0])
                    path.addLine(to: points[1])
                    path.addLine(to: points[2])
                    path.closeSubpath()
                }
                .stroke(color.color.opacity(0.5), lineWidth: max(1, size / 28))
                ForEach(0..<3) { index in
                    Circle()
                        .fill(color.color)
                        .overlay { Circle().strokeBorder(theme.text.opacity(0.15), lineWidth: 0.5) }
                        .frame(width: size * 0.28, height: size * 0.28)
                        .position(points[index])
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
