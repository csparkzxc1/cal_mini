import SwiftUI

struct ASCIIBox<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    init(title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            topBorder
            content()
            bottomBorder
        }
    }

    private var topBorder: some View {
        HStack(spacing: 0) {
            if let title {
                Text("\(ASCII.boxTL)\(ASCII.boxH)\(ASCII.boxH) \(title) \(ASCII.hLine(max(0, 26 - title.count)))\(ASCII.boxTR)")
                    .font(.pixel11)
                    .foregroundStyle(Color.kalDim)
            } else {
                Text(ASCII.boxTop(30))
                    .font(.pixel11)
                    .foregroundStyle(Color.kalDim)
            }
        }
    }

    private var bottomBorder: some View {
        Text(ASCII.boxBottom(30))
            .font(.pixel11)
            .foregroundStyle(Color.kalDim)
    }
}
