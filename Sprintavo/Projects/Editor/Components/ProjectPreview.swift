import SwiftUI

struct ProjectPreview: View {
    let name: String
    let color: ProjectColor

    var body: some View {
        HStack(spacing: 14) {
            ProjectSymbol(color: color, size: 32)
            VStack(alignment: .leading, spacing: 6) {
                Text(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Новый проект" : name)
                    .font(.title3.bold())
                    .lineLimit(3)
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(PanelStyle())
    }
}
