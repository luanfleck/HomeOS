import SwiftUI
import Combine

enum SidebarSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case rooms = "Cômodos"
    case devices = "Dispositivos"
    case automation = "Automações"
    case settings = "Configurações"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dashboard:   return "house.fill"
        case .rooms:       return "square.grid.2x2.fill"
        case .devices:     return "lightbulb.fill"
        case .automation:  return "wand.and.stars"
        case .settings:    return "gearshape.fill"
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var selectedSection: SidebarSection? = .dashboard
    @Published var rooms: [Room] = Room.samples
    @Published var devices: [Device] = Device.samples
    @Published var automations: [Automation] = Automation.samples
    @Published var widgets: [DashboardWidget] = DashboardWidget.defaults
    @Published var isCustomizingDashboard: Bool = false

    var activeDevices: [Device] { devices.filter(\.isOn) }
    var enabledAutomations: [Automation] { automations.filter(\.isEnabled) }
    var visibleWidgets: [DashboardWidget] {
        widgets.filter(\.isVisible).sorted { $0.order < $1.order }
    }

    func moveWidget(from source: IndexSet, to destination: Int) {
        widgets.move(fromOffsets: source, toOffset: destination)
        for (index, _) in widgets.enumerated() {
            widgets[index].order = index
        }
    }

    func toggleWidget(id: UUID) {
        if let idx = widgets.firstIndex(where: { $0.id == id }) {
            widgets[idx].isVisible.toggle()
        }
    }

    func setWidgetSize(id: UUID, size: WidgetSize) {
        if let idx = widgets.firstIndex(where: { $0.id == id }) {
            widgets[idx].size = size
        }
    }
}
