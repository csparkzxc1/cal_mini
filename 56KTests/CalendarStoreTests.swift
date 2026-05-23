import XCTest
@testable import _6K

final class CalendarStoreTests: XCTestCase {
    func testInitialAuthorizationStatus() {
        let store = CalendarStore()
        XCTAssertNotNil(store.authorizationStatus)
    }

    func testFetchEventsReturnsEmptyForFutureDate() {
        let store = CalendarStore()
        let farFuture = Calendar.current.date(byAdding: .year, value: 100, to: .now)!
        let events = store.fetchEvents(for: farFuture)
        XCTAssertTrue(events.isEmpty)
    }

    func testMonthStoreInitializesToCurrentMonth() {
        let store = CalendarStore()
        let monthStore = MonthStore(calendarStore: store)
        let now = Date.now
        let calendar = Calendar.current
        XCTAssertEqual(monthStore.displayedYear, calendar.component(.year, from: now))
        XCTAssertEqual(monthStore.displayedMonth, calendar.component(.month, from: now))
    }

    func testMonthStoreNavigateNext() {
        let store = CalendarStore()
        let monthStore = MonthStore(calendarStore: store)
        let initialMonth = monthStore.displayedMonth
        let initialYear = monthStore.displayedYear

        monthStore.goToNextMonth()

        if initialMonth == 12 {
            XCTAssertEqual(monthStore.displayedMonth, 1)
            XCTAssertEqual(monthStore.displayedYear, initialYear + 1)
        } else {
            XCTAssertEqual(monthStore.displayedMonth, initialMonth + 1)
            XCTAssertEqual(monthStore.displayedYear, initialYear)
        }
    }

    func testMonthStoreNavigatePrevious() {
        let store = CalendarStore()
        let monthStore = MonthStore(calendarStore: store)
        let initialMonth = monthStore.displayedMonth
        let initialYear = monthStore.displayedYear

        monthStore.goToPreviousMonth()

        if initialMonth == 1 {
            XCTAssertEqual(monthStore.displayedMonth, 12)
            XCTAssertEqual(monthStore.displayedYear, initialYear - 1)
        } else {
            XCTAssertEqual(monthStore.displayedMonth, initialMonth - 1)
            XCTAssertEqual(monthStore.displayedYear, initialYear)
        }
    }

    func testDaysInMonthStartsCorrectly() {
        let store = CalendarStore()
        let monthStore = MonthStore(calendarStore: store)
        let days = monthStore.daysInMonth
        XCTAssertFalse(days.isEmpty)
        XCTAssertTrue(days.count >= 28)
    }
}
