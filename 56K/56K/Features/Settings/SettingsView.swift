import SwiftUI

struct SettingsView: View {
    @State private var soundEnabled = SoundManager.shared.isSoundEnabled
    @State private var skipBoot = UserDefaults.standard.bool(forKey: "skipBoot")
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            settingsHeader

            ScrollView {
                VStack(spacing: 0) {
                    sectionHeader("시스템")

                    toggleRow(
                        label: Copy.Settings.sound,
                        sublabel: soundEnabled ? "ON" : "OFF",
                        isOn: $soundEnabled
                    )
                    .onChange(of: soundEnabled) { _, newValue in
                        SoundManager.shared.isSoundEnabled = newValue
                    }

                    toggleRow(
                        label: Copy.Settings.bootAnimation,
                        sublabel: "",
                        isOn: $skipBoot
                    )
                    .onChange(of: skipBoot) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "skipBoot")
                    }

                    divider
                    sectionHeader(Copy.Settings.purchase)
                    iapRow

                    divider
                    sectionHeader(Copy.Settings.about)
                    infoRow(label: "버전", value: Copy.Settings.version)
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.kalBlack)
        .navigationBarHidden(true)
    }

    private var settingsHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.hLine(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            HStack {
                Button(action: { dismiss() }) {
                    Text(Copy.Action.back)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalMagenta)
                }
                Spacer()
                Text(Copy.Settings.title)
                    .font(.pixel14)
                    .foregroundStyle(Color.kalCyanBright)
                Spacer()
                Color.clear.frame(width: 50)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.hLine(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text("\(ASCII.cursor) \(title)")
                .font(.pixel14)
                .foregroundStyle(Color.kalCyanBright)
            Spacer()
        }
        .padding(.vertical, 12)
    }

    private func toggleRow(label: String, sublabel: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.kalCyan)
                if !sublabel.isEmpty {
                    Text(sublabel)
                        .font(.pixel7)
                        .foregroundStyle(Color.kalGreen)
                }
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.kalCyanBright)
        }
        .padding(.vertical, 8)
    }

    private var iapRow: some View {
        Button(action: {
            Task { await IAPManager.shared.purchase() }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(Copy.IAP.title)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.kalCyan)
                    Text(Copy.IAP.description)
                        .font(.pixel7)
                        .foregroundStyle(Color.kalGreen)
                }
                Spacer()
                if IAPManager.shared.isPurchased {
                    Text(Copy.IAP.purchased)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalYellow)
                } else {
                    Text(Copy.IAP.purchase)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalMagenta)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(Color.kalCyan)
            Spacer()
            Text(value)
                .font(.pixel11)
                .foregroundStyle(Color.kalGreen)
        }
        .padding(.vertical, 8)
    }

    private var divider: some View {
        Text(String(repeating: ASCII.lineH, count: 30))
            .font(.pixel7)
            .foregroundStyle(Color.kalDim)
            .padding(.vertical, 4)
    }
}
