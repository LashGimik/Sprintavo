import SwiftUI

struct TaskTitleView: View {
    @State private var isExpanded = false
    @State private var collapsedHeight: CGFloat = 0
    @State private var fullHeight: CGFloat = 0
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title2.bold())
                .lineSpacing(2)
                .lineLimit(isExpanded ? nil : 3)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(title)
                .onGeometryChange(for: CGFloat.self) { geometry in
                    geometry.size.height
                } action: { height in
                    if !isExpanded { collapsedHeight = height }
                }
                .background(alignment: .topLeading) {
                    Text(title)
                        .font(.title2.bold())
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .hidden()
                        .accessibilityHidden(true)
                        .onGeometryChange(for: CGFloat.self) { geometry in
                            geometry.size.height
                        } action: { fullHeight = $0 }
                }
            if isExpanded || fullHeight > collapsedHeight + 1 {
                Button(isExpanded ? "Свернуть название" : "Показать полностью", action: toggle)
                    .font(.caption)
                    .frame(minHeight: 44)
                    .buttonStyle(.plain)
            }
        }
        .onChange(of: title) { _, _ in isExpanded = false }
    }

    private func toggle() { isExpanded.toggle() }
}
