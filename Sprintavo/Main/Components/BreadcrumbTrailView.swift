import SwiftUI

struct BreadcrumbTrailView: View {
    @Environment(\.appTheme) private var theme
    let model: MainViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(model.breadcrumbs.enumerated()), id: \.element.id) { index, crumb in
                    if index > 0 {
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .accessibilityHidden(true)
                    }
                    if let route = crumb.route {
                        Button(action: { model.navigate(to: route) }) {
                            Text(crumb.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: 140)
                        }
                        .accessibilityLabel(crumb.title)
                    } else {
                        Text(crumb.title)
                            .foregroundStyle(theme.text)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 140)
                            .accessibilityLabel(crumb.id == "current" ? currentTitle : crumb.title)
                    }
                }
            }
            .font(.subheadline)
            .foregroundStyle(theme.secondaryText)
            .padding(.trailing, 8)
        }
        .buttonStyle(.plain)
        .scrollIndicators(.hidden)
    }

    private var currentTitle: String {
        if case let .item(item) = model.currentRoute { return item.title }
        return model.headerSection.rawValue
    }
}
