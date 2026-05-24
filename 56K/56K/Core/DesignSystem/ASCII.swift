import Foundation

enum ASCII {
    static let boxTL = "╔"
    static let boxTR = "╗"
    static let boxBL = "╚"
    static let boxBR = "╝"
    static let boxH  = "═"
    static let boxV  = "║"
    static let boxML = "╠"
    static let boxMR = "╣"
    static let boxMT = "╦"
    static let boxMB = "╩"
    static let boxX  = "╬"

    static let lineTL = "┌"
    static let lineTR = "┐"
    static let lineBL = "└"
    static let lineBR = "┘"
    static let lineH  = "─"
    static let lineV  = "│"

    static let arrowL = "◀"
    static let arrowR = "▶"
    static let bullet = "●"
    static let star   = "★"
    static let diamond = "◆"
    static let cursor = "█"

    static func hLine(_ width: Int) -> String {
        String(repeating: boxH, count: width)
    }

    static func boxTop(_ width: Int) -> String {
        boxTL + hLine(width) + boxTR
    }

    static func boxBottom(_ width: Int) -> String {
        boxBL + hLine(width) + boxBR
    }

    static func boxMid(_ width: Int) -> String {
        boxML + hLine(width) + boxMR
    }

    static func boxLine(_ text: String, width: Int) -> String {
        let padding = max(0, width - text.count)
        return boxV + " " + text + String(repeating: " ", count: padding) + " " + boxV
    }
}
