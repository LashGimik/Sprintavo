import SwiftUI

struct TaskListOptionsView: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var state: TaskListViewModel
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Button(action: close) { Color.black.opacity(0.7).ignoresSafeArea() }
                .buttonStyle(.plain)
                .accessibilityLabel("Закрыть фильтры")
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Фильтр и порядок").font(.title3.bold())
                    Spacer()
                    IconButton(title: "Закрыть фильтры", symbol: "xmark", action: close)
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Показывать").font(.headline)
                        CompactSelectionRow(options: TaskListScope.allCases, selection: state.scope, title: \.rawValue) {
                            state.scope = $0
                        }
                        LineDivider().padding(.vertical, 8)
                        Text("Статус").font(.headline)
                        Button(action: clearStatus) {
                            SelectionOptionRow(title: "Любой статус", isSelected: state.statusFilter == nil)
                        }
                        .buttonStyle(.plain)
                        ForEach(TaskStatus.allCases) { status in
                            Button(action: { state.statusFilter = status }) {
                                SelectionOptionRow(title: status.rawValue, isSelected: state.statusFilter == status)
                            }
                            .buttonStyle(.plain)
                        }
                        LineDivider().padding(.vertical, 8)
                        Text("Порядок внутри групп").font(.headline)
                        ForEach(TaskSortOrder.allCases) { order in
                            Button(action: { state.sortOrder = order }) {
                                SelectionOptionRow(title: order.rawValue, isSelected: state.sortOrder == order)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                Button("Сбросить фильтры и поиск", action: state.reset)
                    .font(.subheadline).frame(minHeight: 44)
                FilledActionButton(title: "Готово", action: close)
            }
            .padding(20)
            .frame(maxHeight: 560)
            .modifier(PanelStyle(cornerRadius: 16))
            .frame(maxWidth: 360)
            .padding(20)
            .scaleEffect(isPresented || reduceMotion ? 1 : 0.97)
            .accessibilityAddTraits(.isModal)
        }
        .foregroundStyle(theme.text)
        .opacity(isPresented ? 1 : 0)
        .allowsHitTesting(isPresented)
        .accessibilityHidden(!isPresented)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: isPresented)
    }

    private func clearStatus() { state.statusFilter = nil }
    private func close() { isPresented = false }
}
