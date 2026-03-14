import SwiftUI

// MARK: - Dashboard View

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                DashboardGrid()
                    .padding(theme.density.padding)
            }
            .background(Color(.systemGroupedBackground))

            if appState.isCustomizingDashboard {
                customizeBanner
            }
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    haptic(.light)
                    withAnimation(.hosSpring) {
                        appState.isCustomizingDashboard.toggle()
                    }
                } label: {
                    Label(
                        appState.isCustomizingDashboard ? "Concluir" : "Personalizar",
                        systemImage: appState.isCustomizingDashboard ? "checkmark.circle.fill" : "slider.horizontal.3"
                    )
                }
                .tint(appState.isCustomizingDashboard ? .green : theme.color)
            }
        }
        .sheet(isPresented: $appState.isCustomizingDashboard.not) {
            // sheet is not used with the banner approach
        }
    }

    private var customizeBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.draw.fill")
                .foregroundStyle(theme.color)
            Text("Arraste para reordenar • Toque para mostrar/ocultar")
                .font(.hosCaption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, HOSSpacing.md)
        .padding(.vertical, HOSSpacing.sm)
        .background(.regularMaterial, in: Capsule())
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// MARK: - Dashboard Grid

struct DashboardGrid: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: theme.density.gridSpacing), count: 4),
            spacing: theme.density.gridSpacing
        ) {
            ForEach(appState.isCustomizingDashboard ? appState.widgets : appState.visibleWidgets) { widget in
                WidgetCell(widget: widget)
                    .gridCellColumns(widget.size.columns)
            }
        }
    }
}

// MARK: - Widget Cell

struct WidgetCell: View {
    @EnvironmentObject private var appState: AppState

    let widget: DashboardWidget

    var body: some View {
        ZStack(alignment: .topTrailing) {
            WidgetContent(widget: widget)
                .opacity(appState.isCustomizingDashboard && !widget.isVisible ? 0.35 : 1)

            if appState.isCustomizingDashboard {
                customizeOverlay
            }
        }
        .animation(.hosSpring, value: widget.isVisible)
    }

    private var customizeOverlay: some View {
        Button {
            haptic(.light)
            appState.toggleWidget(id: widget.id)
        } label: {
            Image(systemName: widget.isVisible ? "minus.circle.fill" : "plus.circle.fill")
                .font(.title3)
                .foregroundStyle(widget.isVisible ? .red : .green)
                .background(Circle().fill(.background).padding(2))
        }
        .buttonStyle(.plain)
        .offset(x: 8, y: -8)
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Widget Content Router

struct WidgetContent: View {
    let widget: DashboardWidget

    var body: some View {
        Group {
            switch widget.type {
            case .greeting:    GreetingWidget()
            case .stats:       StatsWidget()
            case .quickAccess: QuickAccessWidget()
            case .rooms:       RoomsWidget()
            case .weather:     WeatherWidget()
            case .security:    SecurityWidget()
            case .energy:      EnergyWidget()
            case .automations: AutomationsWidget()
            }
        }
    }
}

// MARK: - Greeting Widget

struct GreetingWidget: View {
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HOSHighlightCard {
            HStack(spacing: HOSSpacing.lg) {
                VStack(alignment: .leading, spacing: HOSSpacing.xs) {
                    Text(greetingText)
                        .font(.hosTitle)
                        .foregroundStyle(.white)
                    Text(formattedDate)
                        .font(.hosBody)
                        .foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Text(timeEmoji)
                    .font(.system(size: 56))
            }
            .padding(HOSSpacing.lg)
        }
    }

    private var greetingText: String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<12:  return "Bom dia!"
        case 12..<18: return "Boa tarde!"
        default:      return "Boa noite!"
        }
    }

    private var timeEmoji: String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<12:  return "☀️"
        case 12..<18: return "🌤"
        default:      return "🌙"
        }
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d 'de' MMMM"
        f.locale = Locale(identifier: "pt_BR")
        return f.string(from: Date()).capitalized
    }
}

// MARK: - Stats Widget

struct StatsWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    private var stats: [(String, String, String, Color)] {
        [
            ("Cômodos", "\(appState.rooms.count)", "square.grid.2x2.fill", .blue),
            ("Ativos", "\(appState.activeDevices.count)", "lightbulb.fill", .yellow),
            ("Dispositivos", "\(appState.devices.count)", "cpu.fill", theme.color),
            ("Automações", "\(appState.enabledAutomations.count)", "wand.and.stars", .green),
        ]
    }

    var body: some View {
        HStack(spacing: theme.density.gridSpacing) {
            ForEach(stats, id: \.0) { stat in
                HOSCard {
                    VStack(alignment: .leading, spacing: HOSSpacing.sm) {
                        Image(systemName: stat.2)
                            .font(.title3)
                            .foregroundStyle(stat.3)
                        Spacer()
                        Text(stat.1)
                            .font(.hosNumeric)
                            .foregroundStyle(.primary)
                        Text(stat.0)
                            .font(.hosCaption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 100)
                }
            }
        }
    }
}

// MARK: - Quick Access Widget

struct QuickAccessWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.md) {
                Label("Acesso Rápido", systemImage: "bolt.fill")
                    .font(.hosHeadline)
                    .foregroundStyle(theme.color)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: HOSSpacing.sm), count: 2),
                    spacing: HOSSpacing.sm
                ) {
                    ForEach($appState.devices.filter { appState.activeDevices.prefix(4).contains($0.wrappedValue) }) { $device in
                        HOSDeviceControl(device: $device, compact: true)
                    }
                }
            }
        }
    }
}

// MARK: - Rooms Widget

struct RoomsWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.md) {
                Label("Cômodos", systemImage: "house.fill")
                    .font(.hosHeadline)
                    .foregroundStyle(theme.color)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: HOSSpacing.sm), count: 2),
                    spacing: HOSSpacing.sm
                ) {
                    ForEach(appState.rooms.prefix(4)) { room in
                        CompactRoomTile(room: room)
                    }
                }
            }
        }
    }
}

struct CompactRoomTile: View {
    let room: Room

    var body: some View {
        HStack(spacing: HOSSpacing.sm) {
            Image(systemName: room.icon)
                .font(.body)
                .foregroundStyle(.blue)
                .frame(width: 32, height: 32)
                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: HOSRadius.xs))
            VStack(alignment: .leading, spacing: 2) {
                Text(room.name)
                    .font(.hosCaption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text("\(room.activeDevicesCount) ativo(s)")
                    .font(.hosCaption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(HOSSpacing.sm)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: HOSRadius.sm))
    }
}

// MARK: - Weather Widget

struct WeatherWidget: View {
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.sm) {
                Label("Clima", systemImage: "cloud.sun.fill")
                    .font(.hosHeadline)
                    .foregroundStyle(theme.color)
                HStack(alignment: .firstTextBaseline, spacing: HOSSpacing.xs) {
                    Text("23°")
                        .font(.hosNumeric)
                    Text("São Paulo")
                        .font(.hosBody)
                        .foregroundStyle(.secondary)
                }
                Text("Parcialmente nublado")
                    .font(.hosCaption)
                    .foregroundStyle(.secondary)
                HStack(spacing: HOSSpacing.lg) {
                    WeatherDetail(icon: "humidity.fill", value: "68%")
                    WeatherDetail(icon: "wind", value: "12 km/h")
                    WeatherDetail(icon: "umbrella.fill", value: "20%")
                }
            }
        }
    }
}

struct WeatherDetail: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.hosCaption2).foregroundStyle(.secondary)
            Text(value).font(.hosCaption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Security Widget

struct SecurityWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    private var cameras: [Device] { appState.devices.filter { $0.type == .camera } }
    private var locks: [Device]   { appState.devices.filter { $0.type == .lock } }
    private var allSecure: Bool    { locks.allSatisfy { !$0.isOn } }

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.sm) {
                HStack {
                    Label("Segurança", systemImage: "shield.fill")
                        .font(.hosHeadline)
                        .foregroundStyle(theme.color)
                    Spacer()
                    Text(allSecure ? "Seguro" : "Atenção")
                        .font(.hosCaption)
                        .fontWeight(.semibold)
                        .foregroundStyle(allSecure ? .green : .orange)
                        .padding(.horizontal, HOSSpacing.sm)
                        .padding(.vertical, 4)
                        .background(
                            (allSecure ? Color.green : Color.orange).opacity(0.12),
                            in: Capsule()
                        )
                }
                HStack(spacing: HOSSpacing.lg) {
                    SecurityStat(count: cameras.count, icon: "camera.fill", label: "Câmeras")
                    SecurityStat(count: locks.filter(\.isOn).count, icon: "lock.open.fill", label: "Abertas", color: locks.filter(\.isOn).isEmpty ? .secondary : .orange)
                    SecurityStat(count: locks.filter { !$0.isOn }.count, icon: "lock.fill", label: "Fechadas", color: .green)
                }
            }
        }
    }
}

struct SecurityStat: View {
    let count: Int
    let icon: String
    let label: String
    var color: Color = .secondary

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.title3).foregroundStyle(color)
            Text("\(count)").font(.hosHeadline).foregroundStyle(.primary)
            Text(label).font(.hosCaption2).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Energy Widget

struct EnergyWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    private var estimatedWatts: Int {
        appState.activeDevices.count * 45
    }

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.sm) {
                Label("Energia", systemImage: "leaf.fill")
                    .font(.hosHeadline)
                    .foregroundStyle(.green)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(estimatedWatts)")
                        .font(.hosNumeric)
                        .foregroundStyle(.green)
                    Text("W")
                        .font(.hosBody)
                        .foregroundStyle(.secondary)
                }
                Text("\(appState.activeDevices.count) dispositivos ativos")
                    .font(.hosCaption)
                    .foregroundStyle(.secondary)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color(.systemFill)).frame(height: 6)
                        Capsule()
                            .fill(LinearGradient(colors: [.green, .yellow], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * min(Double(estimatedWatts) / 500, 1), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}

// MARK: - Automations Widget

struct AutomationsWidget: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        HOSCard {
            VStack(alignment: .leading, spacing: HOSSpacing.md) {
                Label("Automações", systemImage: "wand.and.stars")
                    .font(.hosHeadline)
                    .foregroundStyle(theme.color)

                ForEach(appState.enabledAutomations.prefix(3)) { automation in
                    HStack(spacing: HOSSpacing.sm) {
                        Image(systemName: automation.trigger.icon)
                            .font(.body)
                            .foregroundStyle(theme.color)
                            .frame(width: 28, height: 28)
                            .background(theme.color.opacity(0.1), in: RoundedRectangle(cornerRadius: HOSRadius.xs))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(automation.name)
                                .font(.hosCaption)
                                .fontWeight(.medium)
                            Text(automation.trigger.rawValue)
                                .font(.hosCaption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if let date = automation.lastTriggeredAt {
                            Text(date, style: .relative)
                                .font(.hosCaption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Bool Toggle Helper

extension Binding where Value == Bool {
    var not: Binding<Bool> {
        Binding(get: { !self.wrappedValue }, set: { self.wrappedValue = !$0 })
    }
}
