import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScreenContent {
            Text("Приложение").font(.headline)
            LabeledContent("Название", value: "Sprintavo")
            LineDivider()
            LabeledContent("Режим", value: "Демонстрационный")
            LineDivider()
            Text("Данные").font(.headline)
            Text("Показаны встроенные примеры. Хранение на устройстве и синхронизация пока не подключены.")
                .foregroundStyle(.secondary)
        }
    }
}
