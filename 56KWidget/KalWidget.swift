import WidgetKit
import SwiftUI

struct KalWidgetEntry: TimelineEntry {
    let date: Date
    let dayNumber: Int
    let weekday: String
    let monthYear: String
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
            monthYear: "\(year).\(month)"
        )
    }
}

struct KalWidgetEntryView: View {
    let entry: KalWidgetEntry

    var body: some View {
        VStack(spacing: 4) {
            Text("╔══56K══╗")
                .font(.custom("Galmuri11", size: 10))
                .foregroundStyle(Color(red: 0, green: 0.53, blue: 0.53))

            Text(entry.monthYear)
                .font(.custom("Galmuri11", size: 11))
                .foregroundStyle(Color(red: 0, green: 0.8, blue: 0.8))

            Text("\(entry.dayNumber)")
                .font(.custom("Galmuri11", size: 32))
                .foregroundStyle(Color(red: 0.8, green: 0.8, blue: 0.8))

            Text(entry.weekday)
                .font(.custom("Galmuri11", size: 14))
                .foregroundStyle(dayColor)

            Text("╚════════╝")
                .font(.custom("Galmuri11", size: 10))
                .foregroundStyle(Color(red: 0, green: 0.53, blue: 0.53))
        }
        .containerBackground(for: .widget) {
            Color(red: 0.05, green: 0.07, blue: 0.09)
        }
    }

    private var dayColor: Color {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: entry.date)
        switch weekday {
        case 1: return Color(red: 0.9, green: 0.3, blue: 0.3)
        case 7: return Color(red: 0.3, green: 0.5, blue: 0.9)
        default: return Color(red: 0, green: 0.8, blue: 0.2)
        }
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
