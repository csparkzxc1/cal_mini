import EventKit
import Observation

@Observable
final class CalendarStore {
    private let store = EKEventStore()

    var authorizationStatus: EKAuthorizationStatus = .notDetermined
    var events: [EKEvent] = []
    var selectedDate: Date = .now
    var currentMonthEvents: [EKEvent] = []

    var isAuthorized: Bool {
        authorizationStatus == .fullAccess
    }

    init() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }

    func requestAccess() async -> Bool {
        do {
            let granted = try await store.requestFullAccessToEvents()
            authorizationStatus = EKEventStore.authorizationStatus(for: .event)
            return granted
        } catch {
            authorizationStatus = EKEventStore.authorizationStatus(for: .event)
            return false
        }
    }

    func fetchEvents(for date: Date) -> [EKEvent] {
        let calendar = Foundation.Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        return store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }

    func fetchEvents(from startDate: Date, to endDate: Date) -> [EKEvent] {
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        return store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }

    func fetchMonthEvents(year: Int, month: Int) -> [EKEvent] {
        let calendar = Foundation.Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            return []
        }
        let predicate = store.predicateForEvents(withStart: startOfMonth, end: endOfMonth, calendars: nil)
        return store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }

    func eventsForDay(_ date: Date, in monthEvents: [EKEvent]) -> [EKEvent] {
        let calendar = Foundation.Calendar.current
        return monthEvents.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date) ||
            calendar.isDate(event.endDate, inSameDayAs: date) ||
            (event.startDate < date && event.endDate > date)
        }
    }

    func createEvent(title: String, startDate: Date, endDate: Date, isAllDay: Bool, location: String?, notes: String?) async throws {
        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.location = location
        event.notes = notes
        event.calendar = store.defaultCalendarForNewEvents
        try store.save(event, span: .thisEvent)
    }

    func updateEvent(_ event: EKEvent, title: String, startDate: Date, endDate: Date, isAllDay: Bool, location: String?, notes: String?) throws {
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.location = location
        event.notes = notes
        try store.save(event, span: .thisEvent)
    }

    func deleteEvent(_ event: EKEvent) throws {
        try store.remove(event, span: .thisEvent)
    }
}
