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
                        sublabel: soundEnabled ? Copy.Settings.soundOn : Copy.Settings.soundOff,
                        isOn: $soundEnabled
                    )
                    .onChange(of: soundEnabled) { _, newValue in
                        SoundManager.shared.isSoundEnabled = newValue
                    }

                    toggleRow(
                        label: Copy.Settings.bootAnimation,
                        sublabel: skipBoot ? Copy.Settings.bootSkip : "",
                        isOn: $skipBoot
                    )
                    .onChange(of: skipBoot) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "skipBoot")
                    }

                    divider
                    sectionHeader(Copy.Settings.premium)
                    iapRow

                    divider
                    sectionHeader(Copy.Settings.about)
                    infoRow(label: "버전", value: Copy.Settings.version)
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.kalBackground)
        .navigationBarHidden(true)
    }

    private var settingsHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            HStack {
                Button(action: { dismiss() }) {
                    Text("[\(Copy.Common.back)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalCyan)
                }
                Spacer()
                Text(Copy.Settings.title)
                    .font(KalFont.headerTitle)
                    .foregroundStyle(Color.kalCyan)
                Spacer()
                Color.clear.frame(width: 50)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text("\(ASCII.selectedItem) \(title)")
                .font(KalFont.pixel(14))
                .foregroundStyle(Color.kalCyan)
            Spacer()
        }
        .padding(.vertical, 12)
    }

    private func toggleRow(label: String, sublabel: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(KalFont.bodyRegular)
                    .foregroundStyle(Color.kalWhite)
                if !sublabel.isEmpty {
                    Text(sublabel)
                        .font(KalFont.caption)
                        .foregroundStyle(Color.kalGreen)
                }
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.kalCyan)
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
                        .font(KalFont.bodyRegular)
                        .foregroundStyle(Color.kalWhite)
                    Text(Copy.IAP.description)
                        .font(KalFont.caption)
                        .foregroundStyle(Color.kalGreen)
                }
                Spacer()
                if IAPManager.shared.isPurchased {
                    Text(Copy.IAP.purchased)
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalYellow)
                } else {
                    Text(Copy.IAP.purchase)
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalCyan)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(KalFont.bodyRegular)
                .foregroundStyle(Color.kalWhite)
            Spacer()
            Text(value)
                .font(KalFont.pixel(12))
                .foregroundStyle(Color.kalGreen)
        }
        .padding(.vertical, 8)
    }

    private var divider: some View {
        Text(ASCII.thinDivider)
            .font(KalFont.pixel(8))
            .foregroundStyle(Color.kalBorder)
            .padding(.vertical, 4)
    }
}
