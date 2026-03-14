import SwiftUI

struct ContentPanelView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            switch appState.selectedSection {
            case .dashboard, nil:
                DashboardView()
            case .rooms:
                RoomsView()
            case .devices:
                DevicesView()
            case .automation:
                AutomationView()
            case .settings:
                SettingsView()
            }
        }
    }
}

struct DetailPlaceholderView: View {
    @Environment(\.hosTheme) private var theme

    var body: some View {
        ContentUnavailableView(
            "Selecione um item",
            systemImage: "house.fill",
            description: Text("Escolha um item para ver os detalhes")
        )
        .foregroundStyle(theme.color)
    }
}
