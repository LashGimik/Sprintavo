import SwiftUI

struct LinearValueSlider: View {
    @Environment(\.appTheme) private var theme
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...255
    var step: Double = 1
    var tint: Color = .accentColor
    var thumbSize: CGFloat = 24

    var body: some View {
        GeometryReader { geometry in
            let travel = max(0, geometry.size.width - thumbSize)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(theme.line)
                    .frame(height: 4)
                    .padding(.horizontal, thumbSize / 2)
                Capsule()
                    .fill(tint)
                    .frame(width: travel * progress, height: 4)
                    .offset(x: thumbSize / 2)
                Circle()
                    .fill(theme.surface)
                    .overlay { Circle().strokeBorder(tint, lineWidth: 2) }
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: travel * progress)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(.rect)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        update(at: gesture.location.x, width: geometry.size.width)
                    }
            )
        }
        .frame(height: max(44, thumbSize))
        .accessibilityElement(children: .ignore)
        .accessibilityValue(value.formatted(.number.precision(.fractionLength(0))))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: setValue(value + step)
            case .decrement: setValue(value - step)
            @unknown default: break
            }
        }
    }

    private var progress: CGFloat {
        guard range.upperBound > range.lowerBound, value.isFinite else { return 0 }
        return CGFloat(min(1, max(0, (value - range.lowerBound) / (range.upperBound - range.lowerBound))))
    }

    private func update(at position: CGFloat, width: CGFloat) {
        let travel = width - thumbSize
        guard travel > 0 else { return }
        let fraction = min(1, max(0, Double((position - thumbSize / 2) / travel)))
        setValue(range.lowerBound + fraction * (range.upperBound - range.lowerBound))
    }

    private func setValue(_ proposed: Double) {
        guard proposed.isFinite, step > 0 else { return }
        let rounded = range.lowerBound + ((proposed - range.lowerBound) / step).rounded() * step
        value = min(range.upperBound, max(range.lowerBound, rounded))
    }
}
