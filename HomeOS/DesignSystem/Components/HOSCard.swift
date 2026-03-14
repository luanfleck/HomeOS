import SwiftUI

// MARK: - HOSCard

struct HOSCard<Content: View>: View {
    @Environment(\.hosTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    let content: Content
    var style: HOSCardStyle?
    var radius: CGFloat
    var padding: CGFloat
    var isInteractive: Bool

    @State private var isPressed = false

    init(
        style: HOSCardStyle? = nil,
        radius: CGFloat = HOSRadius.lg,
        padding: CGFloat = HOSSpacing.md,
        isInteractive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.radius = radius
        self.padding = padding
        self.isInteractive = isInteractive
        self.content = content()
    }

    private var resolvedStyle: HOSCardStyle { style ?? theme.cardStyle }

    var body: some View {
        content
            .padding(padding)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(overlayView)
            .shadow(for: resolvedStyle, colorScheme: colorScheme)
            .scaleEffect(isInteractive && isPressed ? 0.97 : 1)
            .animation(.hosSnappy, value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: 50) {} onPressingChanged: { pressing in
                if isInteractive { isPressed = pressing }
            }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch resolvedStyle {
        case .elevated:
            Color(.systemBackground)
        case .flat:
            Color(.secondarySystemBackground)
        case .outlined:
            Color(.systemBackground)
        case .glassmorphism:
            Rectangle().fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        if resolvedStyle == .outlined {
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(Color(.separator), lineWidth: 1)
        }
    }
}

private extension View {
    func shadow(for style: HOSCardStyle, colorScheme: ColorScheme) -> some View {
        let isDark = colorScheme == .dark
        switch style {
        case .elevated:
            return self.shadow(
                color: isDark ? .black.opacity(0.4) : .black.opacity(0.06),
                radius: isDark ? 12 : 10,
                y: isDark ? 4 : 3
            )
        case .flat, .outlined, .glassmorphism:
            return self.shadow(color: .clear, radius: 0)
        }
    }
}

// MARK: - HOSHighlightCard

struct HOSHighlightCard<Content: View>: View {
    @Environment(\.hosTheme) private var theme

    let content: Content
    var radius: CGFloat

    init(radius: CGFloat = HOSRadius.lg, @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.content = content()
    }

    var body: some View {
        content
            .background(theme.gradient, in: RoundedRectangle(cornerRadius: radius))
            .shadow(color: theme.color.opacity(0.35), radius: 16, y: 6)
    }
}

// MARK: - Preview Helper

#Preview {
    HStack(spacing: 16) {
        ForEach(HOSCardStyle.allCases) { style in
            HOSCard(style: style) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(style.rawValue).font(.hosHeadline)
                    Text("Preview do card").font(.hosCaption).foregroundStyle(.secondary)
                }
                .frame(width: 140, height: 80, alignment: .leading)
            }
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
