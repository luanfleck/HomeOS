import SwiftUI

struct DevicesView: View {
    @EnvironmentObject private var appState: AppState
    @State private var searchText = ""
    @State private var selectedType: DeviceType?

    private var filteredDevices: [Device] {
        appState.devices.filter { device in
            let matchesSearch = searchText.isEmpty || device.name.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || device.type == selectedType
            return matchesSearch && matchesType
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            typeFilterBar
            Divider()
            deviceList
        }
        .navigationTitle("Dispositivos")
        .background(Color(.systemGroupedBackground))
        .searchable(text: $searchText, prompt: "Buscar dispositivos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Adicionar", systemImage: "plus")
                }
            }
        }
    }

    private var typeFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "Todos", isSelected: selectedType == nil) {
                    selectedType = nil
                }
                ForEach(DeviceType.allCases, id: \.self) { type in
                    FilterChip(label: type.rawValue, icon: type.icon, isSelected: selectedType == type) {
                        selectedType = selectedType == type ? nil : type
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .background(.background)
    }

    private var deviceList: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                spacing: 16
            ) {
                ForEach($appState.devices.filter { filteredDevices.contains($0.wrappedValue) }) { $device in
                    DeviceCard(device: $device)
                }
            }
            .padding(24)
        }
    }
}

struct DeviceCard: View {
    @Binding var device: Device

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: device.type.icon)
                    .font(.title2)
                    .foregroundStyle(device.isOn ? device.type.accentColor : .secondary)
                    .frame(width: 48, height: 48)
                    .background(
                        (device.isOn ? device.type.accentColor.opacity(0.15) : Color(.systemFill)),
                        in: RoundedRectangle(cornerRadius: 14)
                    )
                Spacer()
                Toggle("", isOn: $device.isOn)
                    .labelsHidden()
                    .tint(device.type.accentColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(device.isOn ? .primary : .secondary)
                Text(device.roomName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let value = device.value, device.isOn {
                deviceValueView(value: value)
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .opacity(device.isOn ? 1 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: device.isOn)
    }

    @ViewBuilder
    private func deviceValueView(value: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(formattedValue(value))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(device.type.accentColor)
                Spacer()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemFill)).frame(height: 4)
                    Capsule()
                        .fill(device.type.accentColor)
                        .frame(width: geo.size.width * (value / 100), height: 4)
                }
            }
            .frame(height: 4)
        }
    }

    private func formattedValue(_ value: Double) -> String {
        switch device.type {
        case .thermostat: return "\(Int(value))°C"
        case .blind:      return "\(Int(value))% aberto"
        default:          return "\(Int(value))%"
        }
    }
}

struct FilterChip: View {
    let label: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon).font(.caption2)
                }
                Text(label).font(.subheadline)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(isSelected ? Color.blue : Color(.systemFill), in: Capsule())
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25), value: isSelected)
    }
}
