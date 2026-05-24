import SwiftUI

struct PermissionView: View {
    let onRequestPermission: () async -> Void
    let isDenied: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 2) {
                Text(ASCII.boxTop(20))
                Text(ASCII.boxLine("KAL.COM v1.0", width: 20))
                Text(ASCII.boxBottom(20))
            }
            .font(.pixel14)
            .foregroundStyle(Color.kalCyan)
            .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                Text(String(repeating: ASCII.lineH, count: 30))
                    .font(.pixel11)
                    .foregroundStyle(Color.kalDim)

                Text(isDenied ? Copy.System.permDenied : Copy.System.permNeeded)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.kalCyan)
                    .multilineTextAlignment(.center)

                Text(String(repeating: ASCII.lineH, count: 30))
                    .font(.pixel11)
                    .foregroundStyle(Color.kalDim)

                if isDenied {
                    Button(action: openSettings) {
                        Text("[\(Copy.System.goToSettings)]")
                            .font(.pixel14)
                            .foregroundStyle(Color.kalGreen)
                    }
                } else {
                    Button(action: {
                        Task { await onRequestPermission() }
                    }) {
                        Text("[\(Copy.System.requestPerm)]")
                            .font(.pixel14)
                            .foregroundStyle(Color.kalGreen)
                    }
                }
            }
            .padding(24)

            Spacer()
        }
        .background(Color.kalBlack)
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
