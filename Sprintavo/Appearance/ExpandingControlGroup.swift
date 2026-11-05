import SwiftUI

struct ExpandingControlGroup<Primary: View, Secondary: View>: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let isExpanded: Bool
    var axis: Axis = .vertical
    var cellWidth: CGFloat = 44
    var cellHeight: CGFloat = 44
    var border: Color? = nil
    var fill: Color? = nil
    let primary: () -> Primary
    let secondary: () -> Secondary

    init(
        isExpanded: Bool,
        axis: Axis = .vertical,
        cellWidth: CGFloat = 44,
        cellHeight: CGFloat = 44,
        border: Color? = nil,
        fill: Color? = nil,
        @ViewBuilder primary: @escaping () -> Primary,
        @ViewBuilder secondary: @escaping () -> Secondary
    ) {
        self.isExpanded = isExpanded
        self.axis = axis
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.border = border
        self.fill = fill
        self.primary = primary
        self.secondary = secondary
    }

    var body: some View {
        Group {
            if axis == .vertical {
                VStack(spacing: 0) {
                    primary().frame(width: cellWidth, height: cellHeight)
                    secondaryCell
                }
            } else {
                HStack(spacing: 0) {
                    primary().frame(width: cellWidth, height: cellHeight)
                    secondaryCell
                }
            }
        }
        .buttonStyle(.plain)
        .frame(
            width: axis == .horizontal && isExpanded ? cellWidth * 2 : cellWidth,
            height: axis == .vertical && isExpanded ? cellHeight * 2 : cellHeight,
            alignment: .topLeading
        )
        .clipShape(.rect(cornerRadius: theme.cornerRadius))
        .modifier(PanelStyle(fill: fill, border: border))
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: isExpanded)
    }

    private var secondaryCell: some View {
        secondary()
            .frame(width: cellWidth, height: cellHeight)
            .overlay(alignment: axis == .vertical ? .top : .leading) {
                Rectangle()
                    .fill(border ?? theme.line)
                    .frame(width: axis == .horizontal ? 0.5 : nil, height: axis == .vertical ? 0.5 : nil)
                    .padding(axis == .vertical ? .horizontal : .vertical, 7)
                    .accessibilityHidden(true)
            }
            .offset(
                x: axis == .horizontal && !isExpanded && !reduceMotion ? -12 : 0,
                y: axis == .vertical && !isExpanded && !reduceMotion ? -12 : 0
            )
            .opacity(isExpanded ? 1 : 0)
            .allowsHitTesting(isExpanded)
            .accessibilityHidden(!isExpanded)
    }
}
