import SwiftUI

// MARK: - Widget Type

enum WidgetType: String, CaseIterable, Codable, Identifiable {
    case greeting       = "Saudação"
    case stats          = "Estatísticas"
    case quickAccess    = "Acesso Rápido"
    case rooms          = "Cômodos"
    case weather        = "Clima"
    case security       = "Segurança"
    case energy         = "Energia"
    case automations    = "Automações"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .greeting:    return "hand.wave.fill"
        case .stats:       return "chart.bar.fill"
        case .quickAccess: return "bolt.fill"
        case .rooms:       return "square.grid.2x2.fill"
        case .weather:     return "cloud.sun.fill"
        case .security:    return "shield.fill"
        case .energy:      return "leaf.fill"
        case .automations: return "wand.and.stars"
        }
    }

    var description: String {
        switch self {
        case .greeting:    return "Saudação com horário e data"
        case .stats:       return "Contadores de dispositivos e cômodos"
        case .quickAccess: return "Controle rápido dos dispositivos ativos"
        case .rooms:       return "Visão geral dos cômodos"
        case .weather:     return "Temperatura e condições climáticas"
        case .security:    return "Status das câmeras e fechaduras"
        case .energy:      return "Consumo energético estimado"
        case .automations: return "Automações recentes e ativas"
        }
    }

    var defaultSize: WidgetSize {
        switch self {
        case .greeting:    return .wide
        case .stats:       return .wide
        case .quickAccess: return .large
        case .rooms:       return .large
        case .weather:     return .medium
        case .security:    return .medium
        case .energy:      return .medium
        case .automations: return .medium
        }
    }
}

// MARK: - Widget Size

enum WidgetSize: String, CaseIterable, Codable, Identifiable {
    case small  = "Pequeno"
    case medium = "Médio"
    case large  = "Grande"
    case wide   = "Largo"

    var id: String { rawValue }

    var columns: Int {
        switch self {
        case .small:  return 1
        case .medium: return 2
        case .large:  return 2
        case .wide:   return 4
        }
    }

    var icon: String {
        switch self {
        case .small:  return "square"
        case .medium: return "rectangle"
        case .large:  return "square.split.2x1"
        case .wide:   return "rectangle.expand.vertical"
        }
    }
}

// MARK: - Dashboard Widget

struct DashboardWidget: Identifiable, Codable, Equatable {
    let id: UUID
    var type: WidgetType
    var size: WidgetSize
    var isVisible: Bool
    var order: Int

    init(id: UUID = UUID(), type: WidgetType, size: WidgetSize? = nil, isVisible: Bool = true, order: Int = 0) {
        self.id = id
        self.type = type
        self.size = size ?? type.defaultSize
        self.isVisible = isVisible
        self.order = order
    }
}

extension DashboardWidget {
    static let defaults: [DashboardWidget] = WidgetType.allCases.enumerated().map { index, type in
        DashboardWidget(type: type, isVisible: true, order: index)
    }
}
