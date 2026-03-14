import SwiftUI

// MARK: - Accent Color

enum HOSAccentColor: String, CaseIterable, Identifiable {
    case blue    = "Azul"
    case indigo  = "Índigo"
    case purple  = "Roxo"
    case teal    = "Teal"
    case green   = "Verde"
    case orange  = "Laranja"
    case red     = "Vermelho"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blue:   return Color(red: 0.20, green: 0.47, blue: 0.95)
        case .indigo: return .indigo
        case .purple: return .purple
        case .teal:   return .teal
        case .green:  return Color(red: 0.17, green: 0.73, blue: 0.45)
        case .orange: return .orange
        case .red:    return Color(red: 0.92, green: 0.27, blue: 0.27)
        }
    }

    var gradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Card Style

enum HOSCardStyle: String, CaseIterable, Identifiable {
    case elevated  = "Elevado"
    case flat      = "Plano"
    case outlined  = "Contornado"
    case glassmorphism = "Vidro"

    var id: String { rawValue }
}

// MARK: - Layout Density

enum HOSLayoutDensity: String, CaseIterable, Identifiable {
    case compact  = "Compacto"
    case regular  = "Regular"
    case spacious = "Espaçoso"

    var id: String { rawValue }

    var gridSpacing: CGFloat {
        switch self {
        case .compact:  return 10
        case .regular:  return 16
        case .spacious: return 24
        }
    }

    var padding: CGFloat {
        switch self {
        case .compact:  return 16
        case .regular:  return 24
        case .spacious: return 32
        }
    }
}

// MARK: - Theme

@MainActor
final class HOSTheme: ObservableObject {

    @AppStorage("hos.accentColor") private var accentColorRaw: String = HOSAccentColor.blue.rawValue
    @AppStorage("hos.cardStyle")   private var cardStyleRaw:   String = HOSCardStyle.elevated.rawValue
    @AppStorage("hos.density")     private var densityRaw:     String = HOSLayoutDensity.regular.rawValue
    @AppStorage("hos.showValues")  var showDeviceValues: Bool = true
    @AppStorage("hos.animations")  var animationsEnabled: Bool = true

    var accentColor: HOSAccentColor {
        get { HOSAccentColor(rawValue: accentColorRaw) ?? .blue }
        set { accentColorRaw = newValue.rawValue; objectWillChange.send() }
    }

    var cardStyle: HOSCardStyle {
        get { HOSCardStyle(rawValue: cardStyleRaw) ?? .elevated }
        set { cardStyleRaw = newValue.rawValue; objectWillChange.send() }
    }

    var density: HOSLayoutDensity {
        get { HOSLayoutDensity(rawValue: densityRaw) ?? .regular }
        set { densityRaw = newValue.rawValue; objectWillChange.send() }
    }

    var color: Color { accentColor.color }
    var gradient: LinearGradient { accentColor.gradient }
}

// MARK: - Environment Key

private struct HOSThemeKey: EnvironmentKey {
    static let defaultValue = HOSTheme()
}

extension EnvironmentValues {
    var hosTheme: HOSTheme {
        get { self[HOSThemeKey.self] }
        set { self[HOSThemeKey.self] = newValue }
    }
}
