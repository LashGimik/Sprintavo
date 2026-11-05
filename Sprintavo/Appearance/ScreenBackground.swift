import SwiftUI

struct ScreenBackground: View {
    @Environment(\.appTheme) private var theme
    var color: Color? = nil

    var body: some View {
        (color ?? theme.background).ignoresSafeArea()
    }
}
