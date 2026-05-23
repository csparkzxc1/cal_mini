import Foundation

enum ASCII {
    // Double-line box components
    static let boxTopLeft = "╔"
    static let boxTopRight = "╗"
    static let boxBottomLeft = "╚"
    static let boxBottomRight = "╝"
    static let boxHorizontal = "═"
    static let boxVertical = "║"
    static let boxLeftT = "╠"
    static let boxRightT = "╣"
    static let boxCross = "╬"

    // Single-line box components
    static let thinTopLeft = "┌"
    static let thinTopRight = "┐"
    static let thinBottomLeft = "└"
    static let thinBottomRight = "┘"
    static let thinHorizontal = "─"
    static let thinVertical = "│"
    static let thinLeftT = "├"
    static let thinRightT = "┤"

    // Dividers
    static let thickDivider = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    static let doubleDivider = "══════════════════════════════"
    static let thinDivider = "──────────────────────────────"

    // Navigation
    static let arrowLeft = "◀"
    static let arrowRight = "▶"
    static let arrowUp = "▲"
    static let arrowDown = "▼"

    // Decorative
    static let star = "★"
    static let bullet = "●"
    static let diamond = "◆"
    static let square = "■"
    static let emptySquare = "□"
    static let pointer = "▶"
    static let cursor = "█"
    static let cursorBlink = "▌"

    // List prefixes
    static let listItem = ">"
    static let selectedItem = "▶"

    // Status
    static let online = "●"
    static let offline = "○"

    // Build a horizontal box line of given width
    static func horizontalLine(_ char: String = boxHorizontal, width: Int) -> String {
        String(repeating: char, count: width)
    }

    // Build a box top: ╔════════╗
    static func boxTop(width: Int) -> String {
        boxTopLeft + horizontalLine(width: width) + boxTopRight
    }

    // Build a box bottom: ╚════════╝
    static func boxBottom(width: Int) -> String {
        boxBottomLeft + horizontalLine(width: width) + boxBottomRight
    }

    // Build a box middle separator: ╠════════╣
    static func boxMiddle(width: Int) -> String {
        boxLeftT + horizontalLine(width: width) + boxRightT
    }

    // Wrap text in a box line: ║ text   ║
    static func boxLine(_ text: String, width: Int) -> String {
        let padding = max(0, width - text.count)
        return boxVertical + " " + text + String(repeating: " ", count: padding) + " " + boxVertical
    }

    // Boot sequence ASCII title
    static let bootLogo = """
    ╔══════════════════════════╗
    ║    5 6 K  캘 린 더      ║
    ║       v 1 . 0           ║
    ╚══════════════════════════╝
    """

    // Progress bar
    static func progressBar(filled: Int, total: Int) -> String {
        let filledStr = String(repeating: square, count: filled)
        let emptyStr = String(repeating: emptySquare, count: total - filled)
        return "[\(filledStr)\(emptyStr)]"
    }
}
