import SwiftUI

struct ScreenContainerView<Content: View>: View {
    let model: MainViewModel
    let content: Content

    init(model: MainViewModel, @ViewBuilder content: () -> Content) {
        self.model = model
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            BreadcrumbBar(model: model)
                .zIndex(1)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background { ScreenBackground() }
    }
}
