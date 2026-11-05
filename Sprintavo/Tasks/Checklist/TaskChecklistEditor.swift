import SwiftUI

struct TaskChecklistEditor: View {
    @Binding var items: [TaskChecklistItem]
    let statusPicker: ChecklistStatusPickerModel
    var dismissFocusTrigger = false
    var scrollsRows = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if scrollsRows {
                ScrollView {
                    draftRows
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
            } else {
                draftRows
            }
            Button("Добавить шаг", systemImage: "plus", action: add)
                .font(.subheadline)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .buttonStyle(.plain)
            if TaskChecklistRules.normalized(items) == nil {
                Text("Заполните названия шагов или удалите пустые.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
    }

    private var draftRows: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach($items) { $item in
                TaskChecklistDraftRow(item: $item, dismissFocusTrigger: dismissFocusTrigger || statusPicker.isPresented, onChangeStatus: { chooseStatus(item.id) }, onDelete: { remove(item.id) })
                LineDivider()
            }
        }
    }

    private func chooseStatus(_ id: UUID) {
        guard let item = items.first(where: { $0.id == id }) else { return }
        statusPicker.present(status: item.status) { status in
            guard let index = items.firstIndex(where: { $0.id == id }) else { return }
            items[index].status = status
        }
    }

    private func add() { items.append(TaskChecklistItem(title: "")) }
    private func remove(_ id: UUID) { items.removeAll { $0.id == id } }
}
