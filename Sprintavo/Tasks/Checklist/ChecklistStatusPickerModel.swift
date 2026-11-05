import Observation

@MainActor
@Observable
final class ChecklistStatusPickerModel {
    private(set) var isPresented = false
    private(set) var status: ChecklistStatus = .todo
    @ObservationIgnored private var onSelect: ((ChecklistStatus) -> Void)?

    func present(status: ChecklistStatus, onSelect: @escaping (ChecklistStatus) -> Void) {
        self.status = status
        self.onSelect = onSelect
        isPresented = true
    }

    func select(_ status: ChecklistStatus) {
        guard isPresented else { return }
        let apply = onSelect
        self.status = status
        close()
        apply?(status)
    }

    func close() {
        isPresented = false
        onSelect = nil
    }
}
