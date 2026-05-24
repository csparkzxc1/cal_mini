import SwiftUI
import EventKit

struct MonthView: View {
    @Bindable var store: MonthStore

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let boxWidth = 30

    var body: some View {
        VStack(spacing: 0) {
            // Top border
            Text(ASCII.boxTop(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)

            monthHeader

            // Mid divider
            Text(ASCII.boxMid(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)

            weekdayHeader

            calendarGrid

            // Bottom border
            Text(ASCII.boxBottom(boxWidth))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
        }
        .background(Color.kalBlack)
        .onAppear {
            store.loadEvents()
        }
    }

    private var monthHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: store.goToPreviousMonth) {
                    Text(ASCII.arrowL)
                        .font(.pixel14)
                        .foregroundStyle(Color.kalCyan)
                }

                Spacer()

                Text(Copy.Calendar.monthTitle(year: store.displayedYear, month: store.displayedMonth))
                    .font(.pixel14)
                    .foregroundStyle(Color.kalCyanBright)

                Spacer()

                Button(action: store.goToNextMonth) {
                    Text(ASCII.arrowR)
                        .font(.pixel14)
                        .foregroundStyle(Color.kalCyan)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            HStack {
                Spacer()
                Button(action: store.goToToday) {
                    Text("[\(Copy.Calendar.today)]")
                        .font(.pixel11)
                        .foregroundStyle(Color.kalGreen)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 4)
        }
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(Copy.Calendar.weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.pixel11)
                    .foregroundStyle(weekdayColor(index))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
        .background(Color.kalBlack)
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(store.daysInMonth.enumerated()), id: \.offset) { _, date in
                if let date {
                    DayCellView(
                        date: date,
                        dayNumber: store.dayNumber(date),
                        isToday: store.isToday(date),
                        isSelected: store.isSelected(date),
                        hasEvents: store.hasEvents(date),
                        eventCount: store.eventsFor(date).count,
                        weekday: store.weekday(date)
                    )
                    .onTapGesture {
                        store.selectDate(date)
                    }
                } else {
                    Text("")
                        .foregroundStyle(Color.kalDim)
                        .frame(height: 52)
                }
            }
        }
    }

    private func weekdayColor(_ index: Int) -> Color {
        switch index {
        case 0: return .kalRed        // 일 (Sunday)
        case 6: return .kalCyanBright // 토 (Saturday)
        default: return .kalCyan
        }
    }
}

struct DayCellView: View {
    let date: Date
    let dayNumber: Int
    let isToday: Bool
    let isSelected: Bool
    let hasEvents: Bool
    let eventCount: Int
    let weekday: Int

    var body: some View {
        VStack(spacing: 2) {
            if isToday {
                Text("\(ASCII.arrowR)\(String(format: "%02d", dayNumber))\(ASCII.arrowL)")
                    .font(.pixel11)
                    .foregroundStyle(Color.kalCyanBright)
            } else {
                Text(String(format: "%2d", dayNumber))
                    .font(.pixel11)
                    .foregroundStyle(dayColor)
            }

            if hasEvents {
                HStack(spacing: 2) {
                    ForEach(0..<min(eventCount, 3), id: \.self) { _ in
                        Text(ASCII.bullet)
                            .font(.pixel7)
                            .foregroundStyle(Color.kalGreen)
                    }
                }
            } else {
                Spacer().frame(height: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(cellBackground)
    }

    private var dayColor: Color {
        if isSelected { return .kalYellow }
        switch weekday {
        case 1: return .kalRed        // Sunday
        case 7: return .kalCyanBright // Saturday
        default: return .kalCyan
        }
    }

    private var cellBackground: Color {
        if isSelected { return .kalDarkBlue }
        return .clear
    }
}
