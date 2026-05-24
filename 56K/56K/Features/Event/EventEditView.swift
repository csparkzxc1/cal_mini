import SwiftUI
import EventKit

struct EventEditView: View {
    let calendarStore: CalendarStore
    var existingEvent: EKEvent?
    var initialDate: Date?

    @State private var title = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var startDate = Date.now
    @State private var endDate = Date.now.addingTimeInterval(3600)
    @State private var isAllDay = false
    @State private var showError = false
    @Environment(\.dismiss) private var dismiss

    private var isEditing: Bool { existingEvent != nil }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                editHeader

                ScrollView {
                    VStack(spacing: 16) {
                        fieldSection(label: Copy.Field.title) {
                            TextField("", text: $title)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.kalCyan)
                                .tint(Color.kalCyanBright)
                        }

                        fieldSection(label: Copy.Field.location) {
                            TextField("", text: $location)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.kalCyan)
                                .tint(Color.kalCyanBright)
                        }

                        fieldSection(label: Copy.Calendar.allDay) {
                            Toggle(isOn: $isAllDay) {
                                EmptyView()
                            }
                            .tint(Color.kalCyanBright)
                        }

                        fieldSection(label: Copy.Field.date) {
                            DatePicker("", selection: $startDate, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.kalCyanBright)
                                .colorScheme(.dark)
                        }

                        fieldSection(label: Copy.Field.time) {
                            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.kalCyanBright)
                                .colorScheme(.dark)
                        }

                        fieldSection(label: Copy.Field.memo) {
                            TextField("", text: $notes, axis: .vertical)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.kalCyan)
                                .lineLimit(3...6)
                                .tint(Color.kalCyanBright)
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.kalBlack)
            .navigationBarHidden(true)
            .onAppear(perform: populateFields)
        }
    }

    private var editHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.boxTop(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            HStack {
                Button(action: { dismiss() }) {
                    Text(Copy.Action.cancel)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalMagenta)
                }
                Spacer()
                Text(isEditing ? Copy.Action.edit : Copy.Action.newEvent)
                    .font(.pixel14)
                    .foregroundStyle(Color.kalCyanBright)
                Spacer()
                Button(action: save) {
                    Text(Copy.Action.save)
                        .font(.pixel11)
                        .foregroundStyle(title.isEmpty ? Color.kalDim : Color.kalGreen)
                }
                .disabled(title.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.boxBottom(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
        }
    }

    private func fieldSection<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.pixel11)
                .foregroundStyle(Color.kalCyanBright)
            content()
            Text(String(repeating: ASCII.lineH, count: 30))
                .font(.pixel7)
                .foregroundStyle(Color.kalDim.opacity(0.5))
        }
    }

    private func populateFields() {
        if let event = existingEvent {
            title = event.title ?? ""
            location = event.location ?? ""
            notes = event.notes ?? ""
            startDate = event.startDate
            endDate = event.endDate
            isAllDay = event.isAllDay
        } else if let initial = initialDate {
            let cal = Foundation.Calendar.current
            startDate = cal.date(bySettingHour: 9, minute: 0, second: 0, of: initial) ?? initial
            endDate = cal.date(bySettingHour: 10, minute: 0, second: 0, of: initial) ?? initial.addingTimeInterval(3600)
        }
    }

    private func save() {
        guard !title.isEmpty else { return }
        SoundManager.shared.play(.beep)

        Task {
            if let event = existingEvent {
                try? calendarStore.updateEvent(event, title: title, startDate: startDate, endDate: endDate, isAllDay: isAllDay, location: location.isEmpty ? nil : location, notes: notes.isEmpty ? nil : notes)
            } else {
                try? await calendarStore.createEvent(title: title, startDate: startDate, endDate: endDate, isAllDay: isAllDay, location: location.isEmpty ? nil : location, notes: notes.isEmpty ? nil : notes)
            }
            dismiss()
        }
    }
}
