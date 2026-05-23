import SwiftUI

struct BootView: View {
    @State private var lines: [BootLine] = []
    @State private var showCursor = true
    @State private var isComplete = false
    @State private var currentStep = 0

    let onComplete: () -> Void

    private let bootSequence: [(String, Double)] = [
        (ASCII.bootLogo, 0.5),
        ("", 0.3),
        (Copy.Boot.memoryCheck, 0.6),
        (Copy.Boot.dataLoading, 0.8),
        (Copy.Boot.modemConnect, 1.0),
        ("", 0.3),
        (Copy.Boot.connected, 0.4),
        (Copy.Boot.welcome, 0.5),
    ]

    var body: some View {
        ZStack {
            Color.kalBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                ForEach(lines) { line in
                    Text(line.text)
                        .font(KalFont.bootText)
                        .foregroundStyle(line.color)
                }

                if !isComplete && showCursor {
                    Text(ASCII.cursor)
                        .font(KalFont.bootText)
                        .foregroundStyle(Color.kalBrightCyan)
                }

                Spacer()

                if !isComplete {
                    Text(Copy.Boot.skip)
                        .font(KalFont.caption)
                        .foregroundStyle(Color.kalBorder)
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

    private func runBootSequence() async {
        SoundManager.shared.play(.modem)

        for (index, step) in bootSequence.enumerated() {
            guard !isComplete else { return }
            currentStep = index

            let color: Color = step.0.contains("OK") || step.0.contains("완료") || step.0.contains("환영")
                ? .kalGreen : .kalCyan

            lines.append(BootLine(text: step.0, color: color))

            try? await Task.sleep(for: .seconds(step.1))
        }

        try? await Task.sleep(for: .seconds(0.8))
        completeboot()
    }

    private func skipBoot() {
        guard !isComplete else { return }
        SoundManager.shared.stop(.modem)
        completeboot()
    }

    private func completeboot() {
        isComplete = true
        SoundManager.shared.play(.beep)
        onComplete()
    }
}

struct BootLine: Identifiable {
    let id = UUID()
    let text: String
    let color: Color
}
