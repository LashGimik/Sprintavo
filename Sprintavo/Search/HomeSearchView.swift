import SwiftUI

struct HomeSearchView: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var model: SearchViewModel
    @FocusState private var isInputFocused: Bool
    var rowHeight: CGFloat = 44
    var title = "Sprintavo"
    var placeholder = "Поиск"
    var searchLabel = "Поиск по проектам, задачам, заметкам и спринтам"
    let onSelect: (WorkspaceItem) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                if model.isPresented {
                    TextField(placeholder, text: $model.query)
                        .textFieldStyle(.plain)
                        .font(.body)
                        .focused($isInputFocused)
                        .submitLabel(.search)
                        .autocorrectionDisabled()
                        .accessibilityLabel(searchLabel)
                        .transition(.opacity)
                } else {
                    Text(title)
                        .font(.title2.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity)
                        .accessibilityAddTraits(.isHeader)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity)
            Button(action: toggleSearch) {
                Image(systemName: model.isPresented ? "xmark" : "magnifyingglass")
                    .contentTransition(reduceMotion ? .opacity : .symbolEffect(.replace))
                    .font(.title3.weight(model.isPresented ? .semibold : .regular))
                    .foregroundStyle(model.isPresented ? theme.text : theme.secondaryText)
                    .frame(width: 44, height: rowHeight)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(model.isPresented ? "Закрыть поиск" : "Открыть поиск")
        }
        .frame(height: rowHeight)
        .overlay(alignment: .top) {
            SearchSuggestionsOverlay(
                results: model.results,
                isSearchPresented: model.isPresented,
                rowHeight: rowHeight,
                onSelect: selectItem
            )
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: model.isPresented)
        .onChange(of: model.isPresented) { _, isPresented in
            isInputFocused = isPresented
        }
        .onAppear {
            isInputFocused = model.isPresented
        }
    }

    private func toggleSearch() {
        if model.isPresented {
            isInputFocused = false
            model.close()
        } else {
            model.open()
        }
    }

    private func selectItem(_ item: WorkspaceItem) {
        isInputFocused = false
        model.close()
        onSelect(item)
    }
}
