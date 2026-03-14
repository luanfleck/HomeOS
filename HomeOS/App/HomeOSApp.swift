import SwiftUI

@main
struct HomeOSApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var theme = HOSTheme()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(theme)
                .environment(\.hosTheme, theme)
                .tint(theme.color)
        }
    }
}
