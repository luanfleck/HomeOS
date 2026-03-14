import SwiftUI

// MARK: - Spacing

enum HOSSpacing {
    static let xxs: CGFloat = 4
    static let xs:  CGFloat = 8
    static let sm:  CGFloat = 12
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius

enum HOSRadius {
    static let xs:  CGFloat = 8
    static let sm:  CGFloat = 12
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 20
    static let xl:  CGFloat = 28
    static let pill: CGFloat = 999
}

// MARK: - Shadow

struct HOSShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let subtle = HOSShadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    static let medium = HOSShadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
    static let strong = HOSShadow(color: .black.opacity(0.14), radius: 24, x: 0, y: 8)
    static let accent = HOSShadow(color: .blue.opacity(0.25), radius: 16, x: 0, y: 6)
}

// MARK: - Typography

extension Font {
    static var hosLargeTitle: Font  { .system(size: 34, weight: .bold, design: .rounded) }
    static var hosTitle:      Font  { .system(size: 28, weight: .bold, design: .rounded) }
    static var hosTitle2:     Font  { .system(size: 22, weight: .semibold, design: .rounded) }
    static var hosHeadline:   Font  { .system(size: 17, weight: .semibold, design: .rounded) }
    static var hosBody:       Font  { .system(size: 15, weight: .regular, design: .rounded) }
    static var hosCaption:    Font  { .system(size: 12, weight: .medium, design: .rounded) }
    static var hosCaption2:   Font  { .system(size: 11, weight: .regular, design: .rounded) }
    static var hosLabel:      Font  { .system(size: 13, weight: .medium, design: .rounded) }
    static var hosNumeric:    Font  { .system(size: 32, weight: .bold, design: .rounded).monospacedDigit() }
}

// MARK: - Animation

extension Animation {
    static var hosSpring: Animation    { .spring(response: 0.35, dampingFraction: 0.75) }
    static var hosSnappy: Animation    { .spring(response: 0.25, dampingFraction: 0.8) }
    static var hosBounce: Animation    { .spring(response: 0.45, dampingFraction: 0.6) }
    static var hosEaseOut: Animation   { .easeOut(duration: 0.25) }
}

// MARK: - View Modifiers

extension View {
    func hosShadow(_ shadow: HOSShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }

    func hosCard(radius: CGFloat = HOSRadius.lg, shadow: HOSShadow = .subtle) -> some View {
        self
            .background(.background, in: RoundedRectangle(cornerRadius: radius))
            .hosShadow(shadow)
    }
}
