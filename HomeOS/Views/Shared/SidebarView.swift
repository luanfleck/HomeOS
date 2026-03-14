import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        List(SidebarSection.allCases, selection: $appState.selectedSection) { section in
            Label(section.rawValue, systemImage: section.icon)
                .tag(section)
                .font(.hosBody)
        }
        .navigationTitle("HomeOS")
        .listStyle(.sidebar)
        .tint(theme.color)
        .safeAreaInset(edge: .bottom) {
            HomeStatusFooter()
                .padding()
        }
    }
}

private struct HomeStatusFooter: View {
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HStack(spacing: HOSSpacing.sm) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 2) {
                Text("Casa Conectada")
                    .font(.hosCaption)
                    .fontWeight(.medium)
                Text("Todos os sistemas OK")
                    .font(.hosCaption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(HOSSpacing.sm)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: HOSRadius.sm))
    }
}
