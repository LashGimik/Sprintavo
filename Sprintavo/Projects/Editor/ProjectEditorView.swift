import SwiftUI

struct ProjectEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) private var theme
    @State private var model = ProjectEditorViewModel()
    @State private var isColorPickerPresented = false
    @State private var isDiscardConfirmationPresented = false
    let onCreate: (WorkspaceItem) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Новый проект").font(.title2.bold())
                Spacer()
                IconButton(title: "Закрыть создание проекта", symbol: "xmark", action: requestClose)
            }
            .padding(20)
            ScreenContent {
                ProjectPreview(name: model.name, color: model.color)
                ColoredTextField(title: "Название", placeholder: "Например, мой следующий проект", text: $model.name, dismissFocusTrigger: isDiscardConfirmationPresented)
                ColoredTextField(title: "Описание · необязательно", placeholder: "Что хотите сделать в этом проекте?", text: $model.description, multiline: true, dismissFocusTrigger: isDiscardConfirmationPresented)
                Button(action: openColorPicker) {
                    HStack {
                        ProjectSymbol(color: model.color, size: 24)
                        Text("Цвет проекта").font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption)
                    }
                    .padding(16)
                    .modifier(PanelStyle())
                }
                .buttonStyle(.plain)
                FilledActionButton(title: "Создать проект", isEnabled: model.canCreate, action: create)
                Text("Пока проекты сохраняются только до закрытия приложения.")
                    .font(.footnote)
                    .foregroundStyle(theme.secondaryText)
            }
        }
        .allowsHitTesting(!isDiscardConfirmationPresented)
        .accessibilityHidden(isDiscardConfirmationPresented)
        .background { ScreenBackground() }
        .foregroundStyle(theme.text)
        .tint(theme.text)
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled(model.hasChanges)
        .sheet(isPresented: $isColorPickerPresented) {
            ProjectColorPickerView(color: model.color, onApply: applyColor)
        }
        .overlay {
            ConfirmationOverlay(
                isPresented: isDiscardConfirmationPresented,
                title: "Отменить создание проекта?",
                message: "Введённые данные будут удалены.",
                confirmTitle: "Удалить ввод",
                cancelTitle: "Продолжить заполнение",
                onConfirm: close,
                onCancel: cancelDiscard
            )
        }
    }

    private func openColorPicker() { isColorPickerPresented = true }
    private func applyColor(_ color: ProjectColor) { model.color = color }
    private func close() { dismiss() }
    private func cancelDiscard() { isDiscardConfirmationPresented = false }

    private func requestClose() {
        if model.hasChanges { isDiscardConfirmationPresented = true } else { close() }
    }

    private func create() {
        guard let project = model.makeProject() else { return }
        onCreate(project)
        dismiss()
    }
}
