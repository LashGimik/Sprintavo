import SwiftUI

struct NavigationControlView: View {
    let canGoBack: Bool
    var buttonHeight: CGFloat = 44
    var border: Color? = nil
    var fill: Color? = nil
    let onOpenMenu: () -> Void
    let onGoBack: () -> Void

    var body: some View {
        ExpandingControlGroup(
            isExpanded: canGoBack,
            cellHeight: buttonHeight,
            border: border,
            fill: fill
        ) {
            Button(action: onOpenMenu) {
                NavigationDots()
                    .frame(width: 44, height: buttonHeight)
                    .contentShape(.rect)
            }
            .accessibilityLabel("Выбрать раздел")
        } secondary: {
            IconButton(title: "Назад", symbol: "arrow.left", action: onGoBack)
        }
    }
}
