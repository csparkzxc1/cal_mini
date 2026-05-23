import SwiftUI
import EventKit

struct MonthView: View {
    @Bindable var store: MonthStore

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            monthHeader
            weekdayHeader
            calendarGrid
        }
        .background(Color.kalBackground)
        .onAppear {
            store.loadEvents()
        }
    }

    private var monthHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)

            HStack {
                Button(action: store.goToPreviousMonth) {
                    Text(ASCII.arrowLeft)
                        .font(KalFont.headerTitle)
                        .foregroundStyle(Color.kalCyan)
                }

                Spacer()

                Text(Copy.Calendar.monthTitle(year: store.displayedYear, month: store.displayedMonth))
                    .font(KalFont.headerTitle)
                    .foregroundStyle(Color.kalCyan)

                Spacer()

                Button(action: store.goToNextMonth) {
                    Text(ASCII.arrowRight)
                        .font(KalFont.headerTitle)
                        .foregroundStyle(Color.kalCyan)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            HStack {
                Spacer()
                Button(action: store.goToToday) {
                    Text("[\(Copy.Calendar.today)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalGreen)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 4)

            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
        }
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(Copy.Calendar.weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(KalFont.weekdayHeader)
                    .foregroundStyle(weekdayColor(index))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
        .background(Color.kalBackground)
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
                    Color.clear
                        .frame(height: 52)
                }
            }
        }
    }

    private func weekdayColor(_ index: Int) -> Color {
        switch index {
        case 0: return .kalSunday  // 일 (Sunday)
        case 6: return .kalSaturday // 토 (Saturday)
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
            Text("\(dayNumber)")
                .font(KalFont.dayNumber)
                .foregroundStyle(dayColor)

            if hasEvents {
                HStack(spacing: 2) {
                    ForEach(0..<min(eventCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(Color.kalGreen)
                            .frame(width: 4, height: 4)
                    }
                }
            } else {
                Spacer().frame(height: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(isToday ? Color.kalBrightCyan : Color.clear, lineWidth: 1)
        )
    }

    private var dayColor: Color {
        if isSelected { return .kalYellow }
        switch weekday {
        case 1: return .kalSunday
        case 7: return .kalSaturday
        default: return .kalWhite
        }
    }

    private var cellBackground: Color {
        if isSelected { return .kalSelected }
        if isToday { return .kalToday }
        return .clear
    }
}
