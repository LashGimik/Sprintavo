import SwiftUI

struct PanelStyle: ViewModifier {
    @Environment(\.appTheme) private var theme
    var fill: Color? = nil
    var border: Color? = nil
    var cornerRadius: CGFloat? = nil

    func body(content: Content) -> some View {
        content
            .background(fill ?? theme.surface, in: .rect(cornerRadius: cornerRadius ?? theme.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius ?? theme.cornerRadius)
                    .strokeBorder(border ?? theme.line, lineWidth: 1)
                    .allowsHitTesting(false)
            }
    }
}
