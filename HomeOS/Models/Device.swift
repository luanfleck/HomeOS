import Foundation
import SwiftUI

enum DeviceType: String, CaseIterable {
    case light = "Luz"
    case thermostat = "Termostato"
    case lock = "Fechadura"
    case camera = "Câmera"
    case speaker = "Caixa de Som"
    case sensor = "Sensor"
    case plug = "Tomada"
    case blind = "Persiana"

    var icon: String {
        switch self {
        case .light:      return "lightbulb.fill"
        case .thermostat: return "thermometer.medium"
        case .lock:       return "lock.fill"
        case .camera:     return "camera.fill"
        case .speaker:    return "hifispeaker.fill"
        case .sensor:     return "sensor.tag.radiowaves.forward.fill"
        case .plug:       return "powerplug.fill"
        case .blind:      return "blinds.vertical.closed"
        }
    }

    var accentColor: Color {
        switch self {
        case .light:      return .yellow
        case .thermostat: return .orange
        case .lock:       return .blue
        case .camera:     return .purple
        case .speaker:    return .pink
        case .sensor:     return .green
        case .plug:       return .cyan
        case .blind:      return .brown
        }
    }
}

struct Device: Identifiable, Hashable {
    let id: UUID
    var name: String
    var type: DeviceType
    var roomName: String
    var isOn: Bool
    var value: Double?

    init(
        id: UUID = UUID(),
        name: String,
        type: DeviceType,
        roomName: String,
        isOn: Bool = false,
        value: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.roomName = roomName
        self.isOn = isOn
        self.value = value
    }
}

extension Device {
    static let samples: [Device] = [
        Device(name: "Luminária Sala", type: .light, roomName: "Sala de Estar", isOn: true, value: 80),
        Device(name: "Spot Cozinha", type: .light, roomName: "Cozinha", isOn: false),
        Device(name: "Ar-Condicionado", type: .thermostat, roomName: "Quarto Principal", isOn: true, value: 23),
        Device(name: "Fechadura Principal", type: .lock, roomName: "Garagem", isOn: false),
        Device(name: "Câmera Entrada", type: .camera, roomName: "Garagem", isOn: true),
        Device(name: "Sonos Sala", type: .speaker, roomName: "Sala de Estar", isOn: true),
        Device(name: "Tomada Escritório", type: .plug, roomName: "Escritório", isOn: true),
        Device(name: "Persiana Quarto", type: .blind, roomName: "Quarto Principal", isOn: false, value: 40),
        Device(name: "Sensor de Fumaça", type: .sensor, roomName: "Cozinha", isOn: true),
        Device(name: "Luminária Escritório", type: .light, roomName: "Escritório", isOn: true, value: 100),
    ]
}
