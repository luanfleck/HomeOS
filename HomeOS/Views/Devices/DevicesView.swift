import SwiftUI

struct DevicesView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme
    @State private var searchText = ""
    @State private var selectedType: DeviceType?
    @State private var showOnlyActive = false

    private var filteredDevices: [Device] {
        appState.devices.filter { device in
            let matchesSearch = searchText.isEmpty || device.name.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || device.type == selectedType
            let matchesActive = !showOnlyActive || device.isOn
            return matchesSearch && matchesType && matchesActive
        }
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: theme.density.gridSpacing), count: 2)
    }

    var body: some View {
        VStack(spacing: 0) {
            filterBar
            Divider()
            deviceGrid
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

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: HOSSpacing.xs) {
                FilterChip(label: "Todos", isSelected: selectedType == nil && !showOnlyActive) {
                    selectedType = nil
                    showOnlyActive = false
                }
                FilterChip(label: "Ativos", icon: "lightbulb.fill", isSelected: showOnlyActive) {
                    showOnlyActive.toggle()
                }
                Divider().frame(height: 20)
                ForEach(DeviceType.allCases, id: \.self) { type in
                    FilterChip(label: type.rawValue, icon: type.icon, isSelected: selectedType == type) {
                        selectedType = selectedType == type ? nil : type
                    }
                }
            }
            .padding(.horizontal, theme.density.padding)
            .padding(.vertical, HOSSpacing.sm)
        }
        .background(.background)
    }

    private var deviceGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: theme.density.gridSpacing) {
                ForEach($appState.devices.filter { filteredDevices.contains($0.wrappedValue) }) { $device in
                    HOSDeviceControl(device: $device, showSlider: theme.showDeviceValues)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
            .padding(theme.density.padding)
            .animation(.hosSpring, value: filteredDevices.map(\.id))
        }
    }
}

struct FilterChip: View {
    @EnvironmentObject private var theme: HOSTheme

    let label: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: { haptic(.light); action() }) {
            HStack(spacing: 4) {
                if let icon { Image(systemName: icon).font(.caption2) }
                Text(label).font(.hosLabel)
            }
            .padding(.horizontal, HOSSpacing.md)
            .padding(.vertical, 7)
            .background(isSelected ? theme.color : Color(.systemFill), in: Capsule())
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.hosSnappy, value: isSelected)
    }
}
