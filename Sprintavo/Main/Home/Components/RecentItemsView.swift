import SwiftUI

struct RecentItemsView: View {
    let title: String
    let section: WorkspaceSection
    let model: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: title, action: showAll)
            if section == .tasks {
                VStack(spacing: 0) {
                    ForEach(model.records(in: section, scopedToProject: false).prefix(3)) { item in
                        TaskRowView(item: item, projectName: model.project(for: item)?.title, onOpen: model.open, onChangeStatus: model.presentStatusPicker)
                        LineDivider()
                    }
                }
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 12) {
                        ForEach(model.records(in: section, scopedToProject: false).prefix(3)) { item in
                            Button(action: { model.open(item) }) {
                                ItemCardView(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 2)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private func showAll() {
        model.select(section)
    }
}
