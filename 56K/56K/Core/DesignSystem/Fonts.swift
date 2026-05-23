import SwiftUI

enum KalFont {
    // Galmuri pixel font - headers, boot, ASCII, widget
    static func pixel(_ size: CGFloat) -> Font {
        .custom("Galmuri11", size: size)
    }

    // System font - body text, event details (readability first)
    static func body(_ size: CGFloat) -> Font {
        .system(size: size)
    }

    // Tokens
    static let bootTitle: Font = pixel(24)
    static let bootText: Font = pixel(14)
    static let headerTitle: Font = pixel(18)
    static let headerSubtitle: Font = pixel(14)
    static let dayNumber: Font = pixel(13)
    static let weekdayHeader: Font = pixel(12)

    static let bodyLarge: Font = .system(size: 17)
    static let bodyRegular: Font = .system(size: 15)
    static let bodySmall: Font = .system(size: 13)
    static let caption: Font = .system(size: 11)

    static let eventTitle: Font = .system(size: 16, weight: .medium)
    static let eventTime: Font = pixel(12)
    static let eventDetail: Font = .system(size: 15)

    static let widgetTitle: Font = pixel(14)
    static let widgetDay: Font = pixel(28)
    static let widgetEvent: Font = pixel(11)
}
