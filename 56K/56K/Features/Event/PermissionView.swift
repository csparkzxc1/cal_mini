import SwiftUI

struct PermissionView: View {
    let onRequestPermission: () async -> Void
    let isDenied: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text(ASCII.bootLogo)
                .font(KalFont.bootText)
                .foregroundStyle(Color.kalCyan)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                Text(ASCII.thinDivider)
                    .font(KalFont.pixel(10))
                    .foregroundStyle(Color.kalBorder)

                Text(isDenied ? Copy.Permission.denied : Copy.Permission.calendarNeeded)
                    .font(KalFont.bodyRegular)
                    .foregroundStyle(Color.kalWhite)
                    .multilineTextAlignment(.center)

                Text(ASCII.thinDivider)
                    .font(KalFont.pixel(10))
                    .foregroundStyle(Color.kalBorder)

                if isDenied {
                    Button(action: openSettings) {
                        Text("[\(Copy.Permission.goToSettings)]")
                            .font(KalFont.pixel(14))
                            .foregroundStyle(Color.kalGreen)
                    }
                } else {
                    Button(action: {
                        Task { await onRequestPermission() }
                    }) {
                        Text("[\(Copy.Permission.request)]")
                            .font(KalFont.pixel(14))
                            .foregroundStyle(Color.kalGreen)
                    }
                }
            }
            .padding(24)

            Spacer()
        }
        .background(Color.kalBackground)
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
