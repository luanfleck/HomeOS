import Foundation

enum AutomationTrigger: String, CaseIterable {
    case time = "Horário"
    case sunrise = "Nascer do Sol"
    case sunset = "Pôr do Sol"
    case arrival = "Chegada em Casa"
    case departure = "Saída de Casa"
    case sensor = "Sensor"

    var icon: String {
        switch self {
        case .time:      return "clock.fill"
        case .sunrise:   return "sunrise.fill"
        case .sunset:    return "sunset.fill"
        case .arrival:   return "arrow.right.circle.fill"
        case .departure: return "arrow.left.circle.fill"
        case .sensor:    return "sensor.tag.radiowaves.forward.fill"
        }
    }
}

struct Automation: Identifiable, Hashable {
    let id: UUID
    var name: String
    var trigger: AutomationTrigger
    var isEnabled: Bool
    var lastTriggeredAt: Date?

    init(
        id: UUID = UUID(),
        name: String,
        trigger: AutomationTrigger,
        isEnabled: Bool = true,
        lastTriggeredAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.trigger = trigger
        self.isEnabled = isEnabled
        self.lastTriggeredAt = lastTriggeredAt
    }
}

extension Automation {
    static let samples: [Automation] = [
        Automation(name: "Bom Dia", trigger: .sunrise, isEnabled: true, lastTriggeredAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date())),
        Automation(name: "Boa Noite", trigger: .sunset, isEnabled: true),
        Automation(name: "Chegou em Casa", trigger: .arrival, isEnabled: true, lastTriggeredAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())),
        Automation(name: "Saiu de Casa", trigger: .departure, isEnabled: false),
        Automation(name: "Despertar 7h", trigger: .time, isEnabled: true),
        Automation(name: "Alerta de Fumaça", trigger: .sensor, isEnabled: true),
    ]
}
