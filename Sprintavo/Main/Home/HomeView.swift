import SwiftUI

struct HomeView: View {
    let model: MainViewModel

    var body: some View {
        ScreenContent {
            RecentItemsView(title: "Последние проекты", section: .projects, model: model)
            LineDivider()
            RecentItemsView(title: "Спринты", section: .sprints, model: model)
            LineDivider()
            RecentItemsView(title: "Задачи", section: .tasks, model: model)
        }
    }
}
