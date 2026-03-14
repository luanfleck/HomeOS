import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState

    private var activeDevices: [Device] { appState.devices.filter(\.isOn) }
    private var enabledAutomations: [Automation] { appState.automations.filter(\.isEnabled) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                greetingHeader
                statsRow
                quickAccessSection
                recentActivitySection
            }
            .padding(24)
        }
        .navigationTitle("Dashboard")
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Greeting

    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(formattedDate)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Bom dia! ☀️"
        case 12..<18: return "Boa tarde! 🌤"
        default:      return "Boa noite! 🌙"
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: Date()).capitalized
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            StatCard(value: "\(appState.rooms.count)", label: "Cômodos", icon: "square.grid.2x2.fill", color: .blue)
            StatCard(value: "\(activeDevices.count)", label: "Ativos", icon: "lightbulb.fill", color: .yellow)
            StatCard(value: "\(appState.devices.count)", label: "Dispositivos", icon: "cpu.fill", color: .purple)
            StatCard(value: "\(enabledAutomations.count)", label: "Automações", icon: "wand.and.stars", color: .green)
        }
    }

    // MARK: - Quick Access

    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Acesso Rápido", icon: "bolt.fill")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(activeDevices.prefix(6)) { device in
                    ActiveDeviceCard(device: device)
                }
            }
        }
    }

    // MARK: - Recent Activity

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Cômodos", icon: "house.fill")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(appState.rooms) { room in
                    RoomCard(room: room)
                }
            }
        }
    }
}

// MARK: - Subviews

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct ActiveDeviceCard: View {
    let device: Device

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: device.type.icon)
                .font(.title3)
                .foregroundStyle(device.type.accentColor)
                .frame(width: 36, height: 36)
                .background(device.type.accentColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(device.roomName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

struct RoomCard: View {
    let room: Room

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: room.icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text(room.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text("\(room.activeDevicesCount) ativo(s)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline)
            .foregroundStyle(.primary)
    }
}
