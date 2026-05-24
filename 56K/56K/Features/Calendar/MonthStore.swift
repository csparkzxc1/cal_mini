import SwiftUI
import EventKit
import Observation

@Observable
final class MonthStore {
    let calendarStore: CalendarStore

    var displayedYear: Int
    var displayedMonth: Int
    var selectedDate: Date?
    var monthEvents: [EKEvent] = []
    var isShowingDayView = false

    private let calendar = Foundation.Calendar.current

    init(calendarStore: CalendarStore) {
        self.calendarStore = calendarStore
        let now = Date.now
        self.displayedYear = calendar.component(.year, from: now)
        self.displayedMonth = calendar.component(.month, from: now)

        calendarStore.onChange = { [weak self] in
            self?.loadEvents()
        }
    }

    var today: Date { Date.now }

    var daysInMonth: [Date?] {
        var components = DateComponents()
        components.year = displayedYear
        components.month = displayedMonth
        components.day = 1

        guard let firstOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        // Sunday = 1, so offset = firstWeekday - 1
        let offset = firstWeekday - 1

        var days: [Date?] = Array(repeating: nil, count: offset)

        for day in range {
            var dayComponents = DateComponents()
            dayComponents.year = displayedYear
            dayComponents.month = displayedMonth
            dayComponents.day = day
            if let date = calendar.date(from: dayComponents) {
                days.append(date)
            }
        }

        return days
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }

    func dayNumber(_ date: Date) -> Int {
        calendar.component(.day, from: date)
    }

    func weekday(_ date: Date) -> Int {
        calendar.component(.weekday, from: date)
    }

    func eventsFor(_ date: Date) -> [EKEvent] {
        calendarStore.eventsForDay(date, in: monthEvents)
    }

    func hasEvents(_ date: Date) -> Bool {
        !eventsFor(date).isEmpty
    }

    func goToNextMonth() {
        if displayedMonth == 12 {
            displayedMonth = 1
            displayedYear += 1
        } else {
            displayedMonth += 1
        }
        loadEvents()
    }

    func goToPreviousMonth() {
        if displayedMonth == 1 {
            displayedMonth = 12
            displayedYear -= 1
        } else {
            displayedMonth -= 1
        }
        loadEvents()
    }

    func goToToday() {
        let now = Date.now
        displayedYear = calendar.component(.year, from: now)
        displayedMonth = calendar.component(.month, from: now)
        selectedDate = now
        loadEvents()
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        isShowingDayView = true
    }

    func loadEvents() {
        guard calendarStore.isAuthorized else { return }
        monthEvents = calendarStore.fetchMonthEvents(year: displayedYear, month: displayedMonth)
    }
}
