import SwiftUI

struct RoomsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedRoom: Room?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(appState.rooms) { room in
                    RoomGridCard(room: room, isSelected: selectedRoom?.id == room.id)
                        .onTapGesture { selectedRoom = room }
                }
            }
            .padding(24)
        }
        .navigationTitle("Cômodos")
        .background(Color(.systemGroupedBackground))
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
    let room: Room
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: room.icon)
                    .font(.title)
                    .foregroundStyle(isSelected ? .white : .blue)
                    .frame(width: 52, height: 52)
                    .background(
                        (isSelected ? Color.blue : Color.blue.opacity(0.12)),
                        in: RoundedRectangle(cornerRadius: 14)
                    )
                Spacer()
                if room.activeDevicesCount > 0 {
                    Text("\(room.activeDevicesCount)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .blue : .white)
                        .frame(width: 24, height: 24)
                        .background(isSelected ? Color.white : Color.blue, in: Circle())
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                Text("\(room.activeDevicesCount) dispositivo(s) ativo(s)")
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.blue : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.05), radius: 10, y: 4)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}
