import SwiftUI

@main
struct KalApp: App {
    @State private var calendarStore = CalendarStore()
    @State private var showBoot = !UserDefaults.standard.bool(forKey: "hasBooted") && !UserDefaults.standard.bool(forKey: "skipBoot")

    var body: some Scene {
        WindowGroup {
            if showBoot {
                BootView {
                    UserDefaults.standard.set(true, forKey: "hasBooted")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showBoot = false
                    }
                }
            } else {
                RootView(calendarStore: calendarStore)
            }
        }
    }
}
