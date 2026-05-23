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
                        fieldSection(label: Copy.Event.title) {
                            TextField(Copy.Event.titlePlaceholder, text: $title)
                                .font(KalFont.bodyRegular)
                                .foregroundStyle(Color.kalWhite)
                                .tint(Color.kalCyan)
                        }

                        fieldSection(label: Copy.Event.location) {
                            TextField(Copy.Event.locationPlaceholder, text: $location)
                                .font(KalFont.bodyRegular)
                                .foregroundStyle(Color.kalWhite)
                                .tint(Color.kalCyan)
                        }

                        fieldSection(label: Copy.Event.allDay) {
                            Toggle(isOn: $isAllDay) {
                                EmptyView()
                            }
                            .tint(Color.kalCyan)
                        }

                        fieldSection(label: Copy.Event.startDate) {
                            DatePicker("", selection: $startDate, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.kalCyan)
                                .colorScheme(.dark)
                        }

                        fieldSection(label: Copy.Event.endDate) {
                            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.kalCyan)
                                .colorScheme(.dark)
                        }

                        fieldSection(label: Copy.Event.notes) {
                            TextField(Copy.Event.notesPlaceholder, text: $notes, axis: .vertical)
                                .font(KalFont.bodyRegular)
                                .foregroundStyle(Color.kalWhite)
                                .lineLimit(3...6)
                                .tint(Color.kalCyan)
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.kalBackground)
            .navigationBarHidden(true)
            .onAppear(perform: populateFields)
        }
    }

    private var editHeader: some View {
        VStack(spacing: 0) {
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            HStack {
                Button(action: { dismiss() }) {
                    Text("[\(Copy.Event.cancel)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalCyan)
                }
                Spacer()
                Text(isEditing ? Copy.Event.editEvent : Copy.Event.newEvent)
                    .font(KalFont.headerSubtitle)
                    .foregroundStyle(Color.kalCyan)
                Spacer()
                Button(action: save) {
                    Text("[\(Copy.Event.save)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(title.isEmpty ? Color.kalBorder : Color.kalGreen)
                }
                .disabled(title.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
        }
    }

    private func fieldSection<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(KalFont.pixel(12))
                .foregroundStyle(Color.kalCyan)
            content()
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(8))
                .foregroundStyle(Color.kalBorder.opacity(0.5))
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
        SoundManager.shared.play(.success)

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
