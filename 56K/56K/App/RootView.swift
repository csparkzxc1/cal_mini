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
        .background(Color.kalBlack)
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
            Text(String(repeating: ASCII.lineH, count: 30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)

            HStack {
                Text("\(ASCII.bullet) \(Copy.System.connecting)")
                    .font(.pixel11)
                    .foregroundStyle(Color.kalGreen)

                Spacer()

                Button(action: { showSettings = true }) {
                    Text("[\(Copy.Settings.title)]")
                        .font(.pixel11)
                        .foregroundStyle(Color.kalMagenta)
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
