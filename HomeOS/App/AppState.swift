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
}
