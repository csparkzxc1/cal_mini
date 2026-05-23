import SwiftUI

extension Color {
    // Main background - deep dark CRT
    static let kalBackground = Color(red: 0.05, green: 0.07, blue: 0.09)

    // Primary text - classic PC통신 cyan
    static let kalCyan = Color(red: 0, green: 0.8, blue: 0.8)

    // Secondary text - terminal green
    static let kalGreen = Color(red: 0.2, green: 0.8, blue: 0.2)

    // Highlight/selected - amber yellow
    static let kalYellow = Color(red: 0.8, green: 0.8, blue: 0)

    // Warning/special - magenta
    static let kalMagenta = Color(red: 0.8, green: 0, blue: 0.8)

    // System/dim text - CRT white (not pure white)
    static let kalWhite = Color(red: 0.8, green: 0.8, blue: 0.8)

    // Bright active element
    static let kalBrightCyan = Color(red: 0, green: 1, blue: 1)

    // Box borders - dim cyan
    static let kalBorder = Color(red: 0, green: 0.53, blue: 0.53)

    // Error - CRT red
    static let kalRed = Color(red: 0.8, green: 0.2, blue: 0.2)

    // Sunday - subtle red for calendar
    static let kalSunday = Color(red: 0.9, green: 0.3, blue: 0.3)

    // Saturday - subtle blue for calendar
    static let kalSaturday = Color(red: 0.3, green: 0.5, blue: 0.9)

    // Selected day background
    static let kalSelected = Color(red: 0, green: 0.8, blue: 0.8).opacity(0.15)

    // Today indicator
    static let kalToday = Color(red: 0, green: 1, blue: 1).opacity(0.25)
}
