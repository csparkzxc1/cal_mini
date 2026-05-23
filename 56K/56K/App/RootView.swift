import SwiftUI
import EventKit

struct RootView: View {
    let calendarStore: CalendarStore
    @State private var monthStore: MonthStore?
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            Group {
                switch calendarStore.authorizationStatus {
                case .fullAccess:
                    if let store = monthStore {
                        mainCalendarView(store: store)
                    }
                case .denied, .restricted:
                    PermissionView(
                        onRequestPermission: requestPermission,
                        isDenied: true
                    )
                default:
                    PermissionView(
                        onRequestPermission: requestPermission,
                        isDenied: false
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .task {
            if calendarStore.isAuthorized {
                initializeMonthStore()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private func mainCalendarView(store: MonthStore) -> some View {
        VStack(spacing: 0) {
            MonthView(store: store)

            settingsBar
        }
        .background(Color.kalBackground)
        .navigationDestination(isPresented: Binding(
            get: { store.isShowingDayView },
            set: { store.isShowingDayView = $0 }
        )) {
            if let selected = store.selectedDate {
                DayView(
                    date: selected,
                    events: store.eventsFor(selected),
                    calendarStore: calendarStore
                )
            }
        }
    }

    private var settingsBar: some View {
        VStack(spacing: 0) {
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)

            HStack {
                Text("\(ASCII.online) 접속중")
                    .font(KalFont.pixel(11))
                    .foregroundStyle(Color.kalGreen)

                Spacer()

                Button(action: { showSettings = true }) {
                    Text("[\(Copy.Settings.title)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalCyan)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func requestPermission() async {
        let granted = await calendarStore.requestAccess()
        if granted {
            initializeMonthStore()
        }
    }

    private func initializeMonthStore() {
        let store = MonthStore(calendarStore: calendarStore)
        store.loadEvents()
        monthStore = store
    }
}
