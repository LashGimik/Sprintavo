import SwiftUI

struct NavigationDots: View {
    var size: CGFloat = 4

    var body: some View {
        Grid(horizontalSpacing: size, verticalSpacing: size) {
            ForEach(0..<3) { _ in
                GridRow {
                    ForEach(0..<3) { _ in
                        Circle().frame(width: size, height: size)
                    }
                }
            }
        }
        .accessibilityHidden(true)
    }
}
