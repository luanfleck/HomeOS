import Foundation

struct Room: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: String
    var activeDevicesCount: Int

    init(id: UUID = UUID(), name: String, icon: String, activeDevicesCount: Int = 0) {
        self.id = id
        self.name = name
        self.icon = icon
        self.activeDevicesCount = activeDevicesCount
    }
}

extension Room {
    static let samples: [Room] = [
        Room(name: "Sala de Estar", icon: "sofa.fill", activeDevicesCount: 3),
        Room(name: "Cozinha", icon: "fork.knife", activeDevicesCount: 1),
        Room(name: "Quarto Principal", icon: "bed.double.fill", activeDevicesCount: 2),
        Room(name: "Escritório", icon: "desktopcomputer", activeDevicesCount: 4),
        Room(name: "Banheiro", icon: "shower.fill", activeDevicesCount: 0),
        Room(name: "Garagem", icon: "car.fill", activeDevicesCount: 1),
    ]
}
