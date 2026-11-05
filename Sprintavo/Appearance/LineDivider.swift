import SwiftUI

struct LineDivider: View {
    @Environment(\.appTheme) private var theme
    var color: Color? = nil

    var body: some View {
        Rectangle()
            .fill(color ?? theme.line)
            .frame(height: 1)
            .accessibilityHidden(true)
    }
}
