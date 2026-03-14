import SwiftUI

struct RoomsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme
    @State private var selectedRoom: Room?

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: theme.density.gridSpacing), count: 3)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: theme.density.gridSpacing) {
                ForEach(appState.rooms) { room in
                    RoomGridCard(room: room, isSelected: selectedRoom?.id == room.id)
                        .onTapGesture {
                            haptic(.light)
                            withAnimation(.hosSpring) {
                                selectedRoom = selectedRoom?.id == room.id ? nil : room
                            }
                        }
                }
            }
            .padding(theme.density.padding)

            if let room = selectedRoom {
                RoomDevicesSection(room: room)
                    .padding(.horizontal, theme.density.padding)
                    .padding(.bottom, theme.density.padding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("Cômodos")
        .background(Color(.systemGroupedBackground))
        .animation(.hosSpring, value: selectedRoom?.id)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Adicionar Cômodo", systemImage: "plus")
                }
            }
        }
    }
}

struct RoomGridCard: View {
    @EnvironmentObject private var theme: HOSTheme

    let room: Room
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: HOSSpacing.md) {
            HStack {
                Image(systemName: room.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : theme.color)
                    .frame(width: 48, height: 48)
                    .background(
                        isSelected ? Color.white.opacity(0.25) : theme.color.opacity(0.12),
                        in: RoundedRectangle(cornerRadius: HOSRadius.sm)
                    )
                Spacer()
                if room.activeDevicesCount > 0 {
                    Text("\(room.activeDevicesCount)")
                        .font(.hosCaption)
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? theme.color : .white)
                        .frame(width: 26, height: 26)
                        .background(isSelected ? Color.white : theme.color, in: Circle())
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.hosHeadline)
                    .foregroundStyle(isSelected ? .white : .primary)
                Text(room.activeDevicesCount == 0 ? "Nenhum ativo" : "\(room.activeDevicesCount) ativo(s)")
                    .font(.hosCaption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
            }
        }
        .padding(HOSSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            isSelected ? theme.gradient : LinearGradient(colors: [Color(.systemBackground)], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: HOSRadius.lg)
        )
        .shadow(
            color: isSelected ? theme.color.opacity(0.3) : .black.opacity(0.05),
            radius: isSelected ? 12 : 8,
            y: isSelected ? 6 : 3
        )
    }
}

struct RoomDevicesSection: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    let room: Room

    private var roomDevices: [Device] {
        appState.devices.filter { $0.roomName == room.name }
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: theme.density.gridSpacing), count: 2)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HOSSpacing.md) {
            Label("Dispositivos em \(room.name)", systemImage: room.icon)
                .font(.hosHeadline)
                .foregroundStyle(theme.color)

            if roomDevices.isEmpty {
                HOSCard {
                    HStack {
                        Spacer()
                        VStack(spacing: HOSSpacing.sm) {
                            Image(systemName: "cpu")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("Nenhum dispositivo neste cômodo")
                                .font(.hosBody)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(HOSSpacing.xl)
                }
            } else {
                LazyVGrid(columns: columns, spacing: theme.density.gridSpacing) {
                    ForEach($appState.devices.filter { roomDevices.contains($0.wrappedValue) }) { $device in
                        HOSDeviceControl(device: $device)
                    }
                }
            }
        }
    }
}
