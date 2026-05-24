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
                        detailRow(label: Copy.Field.location, value: location)
                    }
                    if let notes = event.notes, !notes.isEmpty {
                        detailRow(label: Copy.Field.memo, value: notes)
                    }
                }
                .padding(16)
            }

            Spacer()
            actionBar
        }
        .background(Color.kalBlack)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEdit) {
            EventEditView(calendarStore: calendarStore, existingEvent: event)
        }
        .alert(Copy.Confirm.deleteEvent, isPresented: $showingDeleteConfirm) {
            Button(Copy.Action.delete, role: .destructive) {
                try? calendarStore.deleteEvent(event)
                dismiss()
            }
            Button(Copy.Action.cancel, role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            Text(ASCII.hLine(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            HStack {
                Button(action: { dismiss() }) {
                    Text(Copy.Action.back)
                        .font(.pixel11)
                        .foregroundStyle(Color.kalMagenta)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Text(ASCII.hLine(30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
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
                .font(.pixel14)
                .foregroundStyle(Color.kalCyan)
        }
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateText)
                .font(.system(size: 14))
                .foregroundStyle(Color.kalGreen)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.pixel11)
                .foregroundStyle(Color.kalCyanBright)
            Text(value)
                .font(.system(size: 14))
                .foregroundStyle(Color.kalCyan)
        }
    }

    private var actionBar: some View {
        VStack(spacing: 0) {
            Text(String(repeating: ASCII.lineH, count: 30))
                .font(.pixel11)
                .foregroundStyle(Color.kalDim)
            HStack {
                Button(action: { showingEdit = true }) {
                    Text(Copy.Action.edit)
                        .font(.pixel14)
                        .foregroundStyle(Color.kalMagenta)
                }
                Spacer()
                Button(action: { showingDeleteConfirm = true }) {
                    Text(Copy.Action.delete)
                        .font(.pixel14)
                        .foregroundStyle(Color.kalRed)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}
