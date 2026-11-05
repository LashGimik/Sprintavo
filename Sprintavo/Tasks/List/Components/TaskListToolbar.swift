import SwiftUI

struct TaskListToolbar: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isSearchFocused: Bool
    @Bindable var state: TaskListViewModel
    let onShowOptions: () -> Void
    var dismissFocusTrigger = false

    var body: some View {
        HStack(spacing: 8) {
            if state.isSearchPresented {
                TextField("Поиск задач", text: $state.query)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit(closeKeyboard)
                    .accessibilityLabel("Поиск в задачах проекта")
                    .transition(.opacity)
                IconButton(title: "Фильтр и порядок", symbol: "line.3.horizontal.decrease", action: showOptions)
                IconButton(title: "Закрыть поиск", symbol: "xmark", action: closeSearch)
            } else {
                Button(action: showOptions) {
                    HStack(spacing: 6) {
                        Text(state.statusFilter?.rawValue ?? scopeTitle)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Image(systemName: "chevron.down").font(.caption)
                    }
                    .font(.subheadline.weight(.medium))
                    .frame(minHeight: 44)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Выбрать фильтры и порядок задач")
                Spacer(minLength: 4)
                IconButton(title: "Найти задачу", symbol: "magnifyingglass", action: openSearch)
            }
        }
        .frame(height: 48)
        .padding(.horizontal, 12)
        .modifier(PanelStyle())
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: state.isSearchPresented)
        .onChange(of: dismissFocusTrigger) { _, dismiss in
            if dismiss { isSearchFocused = false }
        }
        .onChange(of: state.isSearchPresented) { _, presented in
            isSearchFocused = presented
        }
    }

    private var scopeTitle: String {
        state.scope == .all ? "Все задачи" : state.scope.rawValue
    }

    private func openSearch() { state.isSearchPresented = true }
    private func closeSearch() {
        closeKeyboard()
        state.query = ""
        state.isSearchPresented = false
    }
    private func closeKeyboard() { isSearchFocused = false }
    private func showOptions() {
        closeKeyboard()
        onShowOptions()
    }
}
