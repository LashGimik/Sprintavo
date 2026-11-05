import SwiftUI

struct BreadcrumbBar: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .largeTitle) private var rowHeight: CGFloat = 44
    let model: MainViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            NavigationControlView(
                canGoBack: model.canGoBack,
                buttonHeight: rowHeight,
                onOpenMenu: openMenu,
                onGoBack: model.goBack
            )
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    if model.isHomeVisible {
                        HomeSearchView(model: model.search, rowHeight: rowHeight, onSelect: model.open)
                    } else {
                        HStack {
                            Text(model.headerSection.rawValue)
                                .font(.largeTitle.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .accessibilityAddTraits(.isHeader)
                            Spacer(minLength: 0)
                            if model.currentTask != nil {
                                TaskDetailsControls(onEdit: model.editCurrentTask, onDelete: model.requestCurrentTaskDeletion)
                            }
                            if model.canCreateTask {
                                IconButton(title: "Создать задачу", symbol: "plus", action: model.presentTaskEditor)
                                    .modifier(PanelStyle())
                            }
                            if model.isProjectListVisible {
                                ProjectListControls(
                                    isArchiveActive: model.isShowingArchivedProjects,
                                    onToggleArchive: model.toggleProjectsArchive,
                                    onCreate: model.presentProjectEditor
                                )
                            }
                        }
                    }
                }
                .frame(height: rowHeight)
                .zIndex(1)
                BreadcrumbTrailView(model: model)
                    .frame(height: rowHeight)
                    .opacity(model.hasBreadcrumbs ? 1 : 0)
                    .allowsHitTesting(model.hasBreadcrumbs)
                    .accessibilityHidden(!model.hasBreadcrumbs)
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: model.hasBreadcrumbs)
            }
        }
        .frame(height: rowHeight * 2, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func openMenu() {
        model.openMenu()
    }
}
