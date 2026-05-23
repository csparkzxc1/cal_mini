import SwiftUI
import EventKit

struct DayView: View {
    let date: Date
    let events: [EKEvent]
    let calendarStore: CalendarStore
    @State private var showingNewEvent = false
    @Environment(\.dismiss) private var dismiss

    private var dayTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E)"
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
        .background(Color.kalBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingNewEvent) {
            EventEditView(calendarStore: calendarStore, initialDate: date)
        }
    }

    private var dayHeader: some View {
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

                Text(dayTitle)
                    .font(KalFont.headerSubtitle)
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

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            Text(Copy.Calendar.noEvents)
                .font(KalFont.bodyRegular)
                .foregroundStyle(Color.kalWhite)
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            Spacer()
        }
    }

    private var eventList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(events, id: \.eventIdentifier) { event in
                    NavigationLink(destination: EventDetailView(event: event, calendarStore: calendarStore)) {
                        EventRowView(event: event)
                    }
                }
            }
            .padding(.top, 8)
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)

            Button(action: { showingNewEvent = true }) {
                Text("[\(Copy.Event.newEvent)]")
                    .font(KalFont.pixel(14))
                    .foregroundStyle(Color.kalGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
    }
}

struct EventRowView: View {
    let event: EKEvent

    private var timeText: String {
        if event.isAllDay {
            return Copy.Calendar.allDay
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: event.startDate)
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(ASCII.listItem)
                .font(KalFont.pixel(14))
                .foregroundStyle(Color.kalCyan)

            Text(timeText)
                .font(KalFont.eventTime)
                .foregroundStyle(Color.kalGreen)
                .frame(width: 50, alignment: .leading)

            Text(event.title ?? "")
                .font(KalFont.eventTitle)
                .foregroundStyle(Color.kalWhite)
                .lineLimit(1)

            Spacer()

            if let calendarColor = event.calendar?.cgColor {
                Circle()
                    .fill(Color(cgColor: calendarColor))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.kalBackground)
    }
}
