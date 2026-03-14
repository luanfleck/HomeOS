import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } content: {
            ContentPanelView()
        } detail: {
            DetailPlaceholderView()
        }
        .navigationSplitViewStyle(.balanced)
    }
}
