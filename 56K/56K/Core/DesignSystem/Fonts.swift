import SwiftUI

extension Font {
    static let pixel11 = Font.custom("Galmuri11", size: 11)
    static let pixel14 = Font.custom("Galmuri14", size: 14)
    static let pixel7 = Font.custom("Galmuri7", size: 7)

    static func pixelSize(_ name: String = "Galmuri11", _ size: CGFloat) -> Font {
        .custom(name, size: size)
    }
}
