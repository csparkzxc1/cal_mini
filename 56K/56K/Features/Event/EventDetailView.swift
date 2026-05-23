import SwiftUI
import EventKit

struct EventDetailView: View {
    let event: EKEvent
    let calendarStore: CalendarStore
    @State private var showingEdit = false
    @State private var showingDeleteConfirm = false
    @Environment(\.dismiss) private var dismiss

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        if event.isAllDay {
            formatter.dateFormat = "yyyy.MM.dd (E)"
            return "\(Copy.Calendar.allDay) \(ASCII.bullet) \(formatter.string(from: event.startDate))"
        }
        formatter.dateFormat = "yyyy.MM.dd (E) HH:mm"
        let start = formatter.string(from: event.startDate)
        formatter.dateFormat = "HH:mm"
        let end = formatter.string(from: event.endDate)
        return "\(start) ~ \(end)"
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    timeSection
                    if let location = event.location, !location.isEmpty {
                        detailRow(label: Copy.Event.location, value: location)
                    }
                    if let notes = event.notes, !notes.isEmpty {
                        detailRow(label: Copy.Event.notes, value: notes)
                    }
                }
                .padding(16)
            }

            Spacer()
            actionBar
        }
        .background(Color.kalBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEdit) {
            EventEditView(calendarStore: calendarStore, existingEvent: event)
        }
        .alert(Copy.Event.deleteConfirm, isPresented: $showingDeleteConfirm) {
            Button(Copy.Event.deleteEvent, role: .destructive) {
                try? calendarStore.deleteEvent(event)
                dismiss()
            }
            Button(Copy.Event.cancel, role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            HStack {
                Button(action: { dismiss() }) {
                    Text("[\(Copy.Common.back)]")
                        .font(KalFont.pixel(12))
                        .foregroundStyle(Color.kalCyan)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.doubleDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
        }
    }

    private var titleSection: some View {
        HStack(spacing: 8) {
            if let calendarColor = event.calendar?.cgColor {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(cgColor: calendarColor))
                    .frame(width: 4, height: 24)
            }
            Text(event.title ?? "")
                .font(KalFont.bodyLarge)
                .foregroundStyle(Color.kalWhite)
        }
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateText)
                .font(KalFont.bodyRegular)
                .foregroundStyle(Color.kalGreen)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(KalFont.caption)
                .foregroundStyle(Color.kalCyan)
            Text(value)
                .font(KalFont.bodyRegular)
                .foregroundStyle(Color.kalWhite)
        }
    }

    private var actionBar: some View {
        VStack(spacing: 0) {
            Text(ASCII.thinDivider)
                .font(KalFont.pixel(10))
                .foregroundStyle(Color.kalBorder)
            HStack {
                Button(action: { showingEdit = true }) {
                    Text("[\(Copy.Event.editEvent)]")
                        .font(KalFont.pixel(14))
                        .foregroundStyle(Color.kalCyan)
                }
                Spacer()
                Button(action: { showingDeleteConfirm = true }) {
                    Text("[\(Copy.Event.deleteEvent)]")
                        .font(KalFont.pixel(14))
                        .foregroundStyle(Color.kalRed)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}
