import WidgetKit
import SwiftUI

struct KalWidgetEntry: TimelineEntry {
    let date: Date
    let dayNumber: Int
    let weekday: String
    let monthYear: String
    let events: [(time: String, title: String)]
}

struct KalWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> KalWidgetEntry {
        makeEntry(for: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (KalWidgetEntry) -> Void) {
        completion(makeEntry(for: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KalWidgetEntry>) -> Void) {
        let now = Date.now
        let entry = makeEntry(for: now)

        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func makeEntry(for date: Date) -> KalWidgetEntry {
        let calendar = Calendar.current
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return KalWidgetEntry(
            date: date,
            dayNumber: day,
            weekday: weekdays[weekdayIndex],
            monthYear: String(format: "%d/%02d", year, month),
            events: []
        )
    }
}

// MARK: - Widget Colors (hardcoded for widget target)
private enum WidgetColors {
    static let background = Color(red: 0, green: 0, blue: 0)
    static let cyan = Color(red: 0, green: 0.8, blue: 0.8)
    static let bright = Color(red: 0, green: 1, blue: 1)
    static let red = Color(red: 1, green: 0.2, blue: 0.2)
    static let dim = Color(red: 0, green: 0.4, blue: 0.4)
}

struct KalWidgetEntryView: View {
    let entry: KalWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Top border with month/year
            Text("┌─ \(entry.monthYear) ─────┐")
                .font(.custom("Galmuri7", size: 9))
                .foregroundStyle(WidgetColors.dim)

            // Day number and weekday
            HStack(spacing: 0) {
                Text("│ ")
                    .font(.custom("Galmuri7", size: 9))
                    .foregroundStyle(WidgetColors.dim)
                Text("\(entry.dayNumber) (\(entry.weekday))")
                    .font(.custom("Galmuri11", size: 14))
                    .foregroundStyle(dayColor)
                Spacer()
                Text("│")
                    .font(.custom("Galmuri7", size: 9))
                    .foregroundStyle(WidgetColors.dim)
            }

            // Divider
            Text("│ ───────── \u{2003}  │")
                .font(.custom("Galmuri7", size: 9))
                .foregroundStyle(WidgetColors.dim)

            // Events (up to 2)
            if entry.events.isEmpty {
                eventRow(time: "", title: "일정 없음")
                eventRow(time: "", title: "")
            } else {
                ForEach(0..<min(entry.events.count, 2), id: \.self) { i in
                    eventRow(time: entry.events[i].time, title: entry.events[i].title)
                }
                if entry.events.count < 2 {
                    eventRow(time: "", title: "")
                }
            }

            // Bottom border
            Text("└───────────────┘")
                .font(.custom("Galmuri7", size: 9))
                .foregroundStyle(WidgetColors.dim)
        }
        .containerBackground(for: .widget) {
            WidgetColors.background
        }
    }

    private func eventRow(time: String, title: String) -> some View {
        HStack(spacing: 0) {
            Text("│ ")
                .font(.custom("Galmuri7", size: 9))
                .foregroundStyle(WidgetColors.dim)
            if !time.isEmpty {
                Text("\(time) \(title)")
                    .font(.custom("Galmuri11", size: 11))
                    .foregroundStyle(WidgetColors.cyan)
                    .lineLimit(1)
            } else if !title.isEmpty {
                Text(title)
                    .font(.custom("Galmuri11", size: 11))
                    .foregroundStyle(WidgetColors.cyan)
                    .lineLimit(1)
            }
            Spacer()
            Text("│")
                .font(.custom("Galmuri7", size: 9))
                .foregroundStyle(WidgetColors.dim)
        }
    }

    private var dayColor: Color {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: entry.date)
        let isToday = calendar.isDateInToday(entry.date)
        if weekday == 1 { return WidgetColors.red }
        if isToday { return WidgetColors.bright }
        return WidgetColors.cyan
    }
}

@main
struct KalWidget: Widget {
    let kind = "KalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: KalWidgetProvider()) { entry in
            KalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("56K 캘린더")
        .description("오늘 날짜를 PC통신 감성으로")
        .supportedFamilies([.systemSmall])
    }
}
