import SwiftUI

struct BootView: View {
    @State private var lines: [BootLine] = []
    @State private var showCursor = true
    @State private var isComplete = false

    let onComplete: () -> Void

    private let logoBox: String = {
        let outerWidth = 22
        let innerWidth = outerWidth - 2
        return [
            ASCII.boxTop(outerWidth),
            ASCII.boxLine("KAL.COM  v1.0", width: innerWidth),
            ASCII.boxBottom(outerWidth),
        ].joined(separator: "\n")
    }()

    var body: some View {
        ZStack {
            Color.kalBlack
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                ForEach(lines) { line in
                    if line.isLogo {
                        Text(line.text)
                            .font(.pixel11)
                            .foregroundStyle(Color.kalCyan)
                    } else {
                        Text(line.text)
                            .font(line.font)
                            .foregroundStyle(line.color)
                    }
                }

                if !isComplete && showCursor {
                    Text(ASCII.cursor)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalCyanBright)
                }

                Spacer()

                if !isComplete {
                    Text(Copy.Boot.skip)
                        .font(.pixel7)
                        .foregroundStyle(Color.kalDim)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 20)
                }
            }
            .padding(20)
        }
        .onTapGesture {
            skipBoot()
        }
        .task {
            await runBootSequence()
        }
    }

    // MARK: - Boot Sequence

    private func runBootSequence() async {
        // 0.0s: Black screen
        try? await Task.sleep(for: .seconds(0.3))
        guard !isComplete else { return }

        // 0.3s: Banner fade in
        await typeLine(Copy.Boot.banner, color: .kalCyan, font: .pixel14)
        try? await Task.sleep(for: .seconds(0.5))
        guard !isComplete else { return }

        // 0.8s: Port info
        await typeLine(Copy.Boot.port, color: .kalCyan, font: .pixel11)
        try? await Task.sleep(for: .seconds(0.4))
        guard !isComplete else { return }

        // 1.2s: Dialing + modem sound
        SoundManager.shared.play(.modem)
        await typeLine(Copy.Boot.dialing, color: .kalCyan, font: .pixel11)
        try? await Task.sleep(for: .seconds(0.8))
        guard !isComplete else { return }

        // 2.0s: Connect
        await typeLine(Copy.Boot.connect, color: .kalCyan, font: .pixel11)
        try? await Task.sleep(for: .seconds(0.4))
        guard !isComplete else { return }

        // 2.4s: Connecting
        await typeLine(Copy.System.connecting, color: .kalCyan, font: .pixel11)
        try? await Task.sleep(for: .seconds(0.6))
        guard !isComplete else { return }

        // 3.0s: Connected in magenta
        await typeLine(Copy.System.connected, color: .kalMagenta, font: .pixel11)
        try? await Task.sleep(for: .seconds(0.4))
        guard !isComplete else { return }

        // 3.4s: Logo box
        lines.append(BootLine(text: logoBox, color: .kalCyan, font: .pixel11, isLogo: true))
        try? await Task.sleep(for: .seconds(0.6))
        guard !isComplete else { return }

        // 4.0s: Welcome + transition
        await typeLine(Copy.Boot.welcome, color: .kalGreen, font: .pixel14)
        try? await Task.sleep(for: .seconds(0.3))

        completeBoot()
    }

    /// Types out a line character by character at ~40ms per character.
    private func typeLine(
        _ text: String,
        color: Color,
        font: Font,
        charDelay: Double = 0.04
    ) async {
        let lineIndex = lines.count
        lines.append(BootLine(text: "", color: color, font: font))

        for char in text {
            guard !isComplete else { return }
            lines[lineIndex] = BootLine(
                id: lines[lineIndex].id,
                text: lines[lineIndex].text + String(char),
                color: color,
                font: font
            )
            try? await Task.sleep(for: .seconds(charDelay))
        }
    }

    // MARK: - Skip & Complete

    private func skipBoot() {
        guard !isComplete else { return }
        SoundManager.shared.stop(.modem)
        completeBoot()
    }

    private func completeBoot() {
        isComplete = true
        SoundManager.shared.stop(.modem)
        SoundManager.shared.play(.beep)
        onComplete()
    }
}

// MARK: - BootLine

struct BootLine: Identifiable {
    var id = UUID()
    let text: String
    let color: Color
    var font: Font = .pixel11
    var isLogo: Bool = false
}
