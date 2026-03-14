import SwiftUI

// MARK: - HOSDeviceControl

struct HOSDeviceControl: View {
    @Environment(\.hosTheme) private var theme
    @Binding var device: Device

    var showSlider: Bool = true
    var compact: Bool = false

    @State private var showDetail = false
    @State private var localValue: Double

    init(device: Binding<Device>, showSlider: Bool = true, compact: Bool = false) {
        self._device = device
        self.showSlider = showSlider
        self.compact = compact
        self._localValue = State(initialValue: device.wrappedValue.value ?? 50)
    }

    private var hasSlider: Bool {
        showSlider && device.value != nil && [.light, .thermostat, .blind].contains(device.type)
    }

    var body: some View {
        HOSCard(isInteractive: true) {
            VStack(alignment: .leading, spacing: compact ? HOSSpacing.sm : HOSSpacing.md) {
                topRow
                nameRow
                if hasSlider && device.isOn && !compact {
                    sliderRow
                }
            }
        }
        .onTapGesture { if compact { toggleDevice() } }
        .sheet(isPresented: $showDetail) {
            DeviceDetailSheet(device: $device)
                .presentationDetents([.medium])
                .presentationCornerRadius(HOSRadius.xl)
        }
        .onLongPressGesture(minimumDuration: 0.4) {
            haptic(.medium)
            showDetail = true
        }
    }

    // MARK: - Subviews

    private var topRow: some View {
        HStack(alignment: .top) {
            ZStack {
                RoundedRectangle(cornerRadius: HOSRadius.sm)
                    .fill(device.isOn
                          ? device.type.accentColor.opacity(0.18)
                          : Color(.systemFill))
                    .frame(width: compact ? 36 : 44, height: compact ? 36 : 44)
                Image(systemName: device.type.icon)
                    .font(compact ? .body : .title3)
                    .foregroundStyle(device.isOn ? device.type.accentColor : .secondary)
            }
            Spacer()
            HOSToggle(isOn: $device.isOn, color: device.type.accentColor)
        }
    }

    private var nameRow: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(device.name)
                .font(compact ? .hosCaption : .hosLabel)
                .fontWeight(.semibold)
                .foregroundStyle(device.isOn ? .primary : .secondary)
                .lineLimit(1)
            Text(device.roomName)
                .font(.hosCaption2)
                .foregroundStyle(.tertiary)
                .lineLimit(1)
        }
    }

    private var sliderRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(sliderLabel)
                    .font(.hosCaption)
                    .foregroundStyle(theme.color)
                    .fontWeight(.semibold)
                Spacer()
            }
            Slider(value: $localValue, in: sliderRange, step: 1)
                .tint(device.type.accentColor)
                .onChange(of: localValue) { _, v in device.value = v }
        }
    }

    private var sliderRange: ClosedRange<Double> {
        switch device.type {
        case .thermostat: return 16...30
        default:          return 0...100
        }
    }

    private var sliderLabel: String {
        switch device.type {
        case .thermostat: return "\(Int(localValue))°C"
        case .blind:      return "\(Int(localValue))% aberto"
        default:          return "\(Int(localValue))%"
        }
    }

    private func toggleDevice() {
        haptic(.light)
        withAnimation(.hosSnappy) { device.isOn.toggle() }
    }
}

// MARK: - HOSToggle

struct HOSToggle: View {
    @Binding var isOn: Bool
    var color: Color = .blue

    var body: some View {
        Button {
            haptic(.light)
            withAnimation(.hosSnappy) { isOn.toggle() }
        } label: {
            ZStack {
                Capsule()
                    .fill(isOn ? color : Color(.systemFill))
                    .frame(width: 44, height: 26)
                    .animation(.hosSnappy, value: isOn)
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
                    .offset(x: isOn ? 9 : -9)
                    .animation(.hosSpring, value: isOn)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Device Detail Sheet

struct DeviceDetailSheet: View {
    @Environment(\.hosTheme) private var theme
    @Environment(\.dismiss) private var dismiss
    @Binding var device: Device
    @State private var localValue: Double

    init(device: Binding<Device>) {
        self._device = device
        self._localValue = State(initialValue: device.wrappedValue.value ?? 50)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HOSSpacing.lg) {
                    deviceHero
                    controlSection
                }
                .padding(HOSSpacing.lg)
            }
            .navigationTitle(device.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }

    private var deviceHero: some View {
        HOSHighlightCard {
            HStack(spacing: HOSSpacing.lg) {
                Image(systemName: device.type.icon)
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 6) {
                    Text(device.type.rawValue)
                        .font(.hosCaption)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(device.name)
                        .font(.hosTitle2)
                        .foregroundStyle(.white)
                    Text(device.roomName)
                        .font(.hosLabel)
                        .foregroundStyle(.white.opacity(0.75))
                }
                Spacer()
                HOSToggle(isOn: $device.isOn, color: .white)
            }
            .padding(HOSSpacing.lg)
        }
    }

    @ViewBuilder
    private var controlSection: some View {
        if let _ = device.value, [.light, .thermostat, .blind].contains(device.type) {
            HOSCard {
                VStack(alignment: .leading, spacing: HOSSpacing.md) {
                    Label(controlTitle, systemImage: controlIcon)
                        .font(.hosHeadline)
                    HStack {
                        Text(formattedValue)
                            .font(.hosNumeric)
                            .foregroundStyle(theme.color)
                        Spacer()
                    }
                    Slider(value: $localValue, in: sliderRange, step: 1)
                        .tint(device.type.accentColor)
                        .disabled(!device.isOn)
                        .onChange(of: localValue) { _, v in device.value = v }
                    HStack {
                        Text(minLabel).font(.hosCaption2).foregroundStyle(.secondary)
                        Spacer()
                        Text(maxLabel).font(.hosCaption2).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var controlTitle: String {
        switch device.type {
        case .thermostat: return "Temperatura"
        case .blind:      return "Abertura"
        default:          return "Intensidade"
        }
    }

    private var controlIcon: String {
        switch device.type {
        case .thermostat: return "thermometer.medium"
        case .blind:      return "blinds.vertical.open"
        default:          return "sun.max.fill"
        }
    }

    private var formattedValue: String {
        switch device.type {
        case .thermostat: return "\(Int(localValue))°C"
        case .blind:      return "\(Int(localValue))%"
        default:          return "\(Int(localValue))%"
        }
    }

    private var sliderRange: ClosedRange<Double> {
        device.type == .thermostat ? 16...30 : 0...100
    }

    private var minLabel: String { device.type == .thermostat ? "16°C" : "0%" }
    private var maxLabel: String { device.type == .thermostat ? "30°C" : "100%" }
}

// MARK: - Haptic

func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
