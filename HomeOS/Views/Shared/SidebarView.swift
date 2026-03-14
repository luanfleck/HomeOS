import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        List(SidebarSection.allCases, selection: $appState.selectedSection) { section in
            Label(section.rawValue, systemImage: section.icon)
                .tag(section)
        }
        .navigationTitle("HomeOS")
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            HomeStatusFooter()
                .padding()
        }
    }
}

private struct HomeStatusFooter: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 2) {
                Text("Casa Conectada")
                    .font(.caption)
                    .fontWeight(.medium)
                Text("Todos os sistemas OK")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
