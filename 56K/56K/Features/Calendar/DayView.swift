import SwiftUI
import EventKit

struct DayView: View {
    let date: Date
    let events: [EKEvent]
    let calendarStore: CalendarStore
    @State private var showingNewEvent = false
    @Environment(\.dismiss) private var dismiss

    private let boxWidth = 32

    private var dayTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd (E)"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 0) {
            dayHeader

            if events.isEmpty {
                emptyState
            } else {
                eventList
            }

            Spacer()

            bottomBar
        }
        .background(Color.kalBlack)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingNewEvent) {
            EventEditView(calendarStore: calendarStore, initialDate: date)
        }
    }

    private var dayHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.boxTop(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)

            HStack {
                Button(action: { dismiss() }) {
                    Text(Copy.Action.back)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalCyan)
                }

                Spacer()

                Text(dayTitle)
                    .font(.pixel14)
                    .foregroundStyle(Color.kalCyanBright)

                Spacer()

                Color.clear.frame(width: 50)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Text(ASCII.boxMid(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(ASCII.hLine(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            Text(Copy.Empty.noEvents)
                .font(.pixel11)
                .foregroundStyle(Color.kalCyan)
            Text(Copy.Empty.noEventsHint)
                .font(.pixel7)
                .foregroundStyle(Color.kalDim)
            Text(ASCII.hLine(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            Spacer()
        }
    }

    private var eventList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.eventIdentifier) { index, event in
                    NavigationLink(destination: EventDetailView(event: event, calendarStore: calendarStore)) {
                        EventRowView(event: event, index: index + 1)
                    }
                }
            }
            .padding(.top, 8)
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Text(ASCII.boxBottom(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)

            Button(action: { showingNewEvent = true }) {
                Text(Copy.Action.newEvent)
                    .font(.pixel14)
                    .foregroundStyle(Color.kalMagenta)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
    }
}

struct EventRowView: View {
    let event: EKEvent
    let index: Int

    private var timeText: String {
        if event.isAllDay {
            return Copy.Calendar.allDay
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: event.startDate)
    }

    private var numberLabel: String {
        String(format: "[%04d]", index)
    }

    private var categoryLabel: String {
        if let calendar = event.calendar {
            return "[\(calendar.title)]"
        }
        return ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text(numberLabel)
                    .font(.pixel11)
                    .foregroundStyle(Color.kalDim)

                Text(categoryLabel)
                    .font(.pixel11)
                    .foregroundStyle(Color.kalMagenta)

                Text(timeText)
                    .font(.pixel11)
                    .foregroundStyle(Color.kalGreen)

                Spacer()
            }

            Text("         \(event.title ?? "")")
                .font(.system(size: 14))
                .foregroundStyle(Color.kalCyan)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.kalBlack)
    }
}
