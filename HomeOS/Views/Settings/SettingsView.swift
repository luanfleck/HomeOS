import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var theme: HOSTheme
    @EnvironmentObject private var appState: AppState
    @State private var homeName = "Minha Casa"

    var body: some View {
        Form {
            appearanceSection
            layoutSection
            deviceSection
            dashboardSection
            connectivitySection
            aboutSection
        }
        .navigationTitle("Configurações")
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        Section {
            accentColorPicker
            cardStylePicker
        } header: {
            Label("Aparência", systemImage: "paintbrush.fill")
        }
    }

    private var accentColorPicker: some View {
        VStack(alignment: .leading, spacing: HOSSpacing.sm) {
            Text("Cor de destaque")
                .font(.hosBody)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: HOSSpacing.sm) {
                    ForEach(HOSAccentColor.allCases) { accent in
                        ColorSwatch(
                            color: accent.color,
                            label: accent.rawValue,
                            isSelected: theme.accentColor == accent
                        ) {
                            haptic(.light)
                            withAnimation(.hosSnappy) { theme.accentColor = accent }
                        }
                    }
                }
                .padding(.vertical, HOSSpacing.xs)
            }
        }
        .padding(.vertical, HOSSpacing.xs)
    }

    private var cardStylePicker: some View {
        VStack(alignment: .leading, spacing: HOSSpacing.sm) {
            Text("Estilo dos cartões")
                .font(.hosBody)
            HStack(spacing: HOSSpacing.sm) {
                ForEach(HOSCardStyle.allCases) { style in
                    CardStyleButton(style: style, isSelected: theme.cardStyle == style) {
                        haptic(.light)
                        withAnimation(.hosSnappy) { theme.cardStyle = style }
                    }
                }
            }
        }
        .padding(.vertical, HOSSpacing.xs)
    }

    // MARK: - Layout

    private var layoutSection: some View {
        Section {
            VStack(alignment: .leading, spacing: HOSSpacing.sm) {
                Text("Densidade do layout")
                    .font(.hosBody)
                Picker("Densidade", selection: Binding(
                    get: { theme.density },
                    set: { haptic(.light); theme.density = $0 }
                )) {
                    ForEach(HOSLayoutDensity.allCases) { d in
                        Text(d.rawValue).tag(d)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.vertical, HOSSpacing.xs)

            Toggle(isOn: Binding(get: { theme.animationsEnabled }, set: { theme.animationsEnabled = $0 })) {
                Label("Animações", systemImage: "sparkles")
            }
        } header: {
            Label("Layout", systemImage: "rectangle.3.group.fill")
        }
    }

    // MARK: - Devices

    private var deviceSection: some View {
        Section {
            Toggle(isOn: Binding(get: { theme.showDeviceValues }, set: { theme.showDeviceValues = $0 })) {
                Label("Mostrar valores nos cartões", systemImage: "slider.horizontal.3")
            }
        } header: {
            Label("Dispositivos", systemImage: "lightbulb.fill")
        } footer: {
            Text("Exibe sliders de brilho/temperatura diretamente nos cartões de dispositivos.")
        }
    }

    // MARK: - Dashboard

    private var dashboardSection: some View {
        Section {
            ForEach($appState.widgets) { $widget in
                HStack {
                    Image(systemName: widget.type.icon)
                        .foregroundStyle(theme.color)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(widget.type.rawValue)
                            .font(.hosBody)
                        Text(widget.type.description)
                            .font(.hosCaption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Picker("", selection: $widget.size) {
                        ForEach(WidgetSize.allCases) { size in
                            Label(size.rawValue, systemImage: size.icon).tag(size)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 110)
                    Toggle("", isOn: $widget.isVisible)
                        .labelsHidden()
                        .tint(theme.color)
                }
            }
            .onMove { appState.moveWidget(from: $0, to: $1) }
        } header: {
            Label("Widgets do Dashboard", systemImage: "square.grid.2x2.fill")
        } footer: {
            Text("Ative, desative e reordene os widgets. Arraste para reposicionar.")
        }
    }

    // MARK: - Connectivity

    private var connectivitySection: some View {
        Section {
            LabeledContent {
                HStack(spacing: 6) {
                    Circle().fill(.green).frame(width: 8, height: 8)
                    Text("Conectado").foregroundStyle(.green).font(.hosBody)
                }
            } label: {
                Label("Status da Rede", systemImage: "wifi")
            }
            LabeledContent("Gateway") { Text("192.168.1.1").foregroundStyle(.secondary) }
            LabeledContent("Dispositivos na Rede") { Text("14").foregroundStyle(.secondary) }
        } header: {
            Label("Conectividade", systemImage: "network")
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section {
            LabeledContent("Versão") { Text("1.0.0").foregroundStyle(.secondary) }
            LabeledContent("Build") { Text("2026.03.14").foregroundStyle(.secondary) }
            Button("Termos de Uso") {}
            Button("Política de Privacidade") {}
        } header: {
            Label("Sobre", systemImage: "info.circle.fill")
        }
    }
}

// MARK: - Color Swatch

struct ColorSwatch: View {
    let color: Color
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? color : .clear, lineWidth: 2)
                        .padding(-4)
                )
                Text(label)
                    .font(.hosCaption2)
                    .foregroundStyle(isSelected ? color : .secondary)
            }
        }
        .buttonStyle(.plain)
        .animation(.hosSnappy, value: isSelected)
    }
}

// MARK: - Card Style Button

struct CardStyleButton: View {
    @Environment(\.hosTheme) private var theme

    let style: HOSCardStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: HOSSpacing.xs) {
                HOSCard(style: style, padding: HOSSpacing.sm) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? theme.color.opacity(0.2) : Color(.systemFill))
                        .frame(height: 28)
                }
                Text(style.rawValue)
                    .font(.hosCaption2)
                    .foregroundStyle(isSelected ? theme.color : .secondary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: HOSRadius.sm)
                    .strokeBorder(isSelected ? theme.color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .animation(.hosSnappy, value: isSelected)
    }
}
