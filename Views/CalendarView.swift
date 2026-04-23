//
//  CalendarView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \CheckIn.date) private var checkIns: [CheckIn]

    @State private var selectedZoom: CalendarZoom = .month
    @State private var displayDate = Date()
    @State private var selectedDate: Date?
    @State private var showingDayDetail = false

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Calendar Zoom", selection: $selectedZoom) {
                    ForEach(CalendarZoom.allCases) { zoom in
                        Text(zoom.rawValue).tag(zoom)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                headerView

                switch selectedZoom {
                case .week:
                    weekView
                case .month:
                    monthView
                case .year:
                    yearView
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Calendar")
            .sheet(isPresented: $showingDayDetail) {
                if let selectedDate {
                    DayDetailView(date: selectedDate)
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                moveBackward()
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(headerTitle)
                .font(.headline)

            Spacer()

            Button {
                moveForward()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }

    private var headerTitle: String {
        switch selectedZoom {
        case .week:
            let weekDates = datesForWeek(containing: displayDate)
            guard let first = weekDates.first, let last = weekDates.last else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
        case .month:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: displayDate)
        case .year:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: displayDate)
        }
    }

    private var weekView: some View {
        let weekDates = datesForWeek(containing: displayDate)

        return HStack(spacing: 8) {
            ForEach(weekDates, id: \.self) { date in
                DayCellView(
                    date: date,
                    isCompleted: isCompleted(on: date),
                    isSelected: isSameDay(date, selectedDate)
                ) {
                    openDay(date)
                }
            }
        }
        .padding(.horizontal)
    }

    private var monthView: some View {
        let dates = datesForMonthGrid(containing: displayDate)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(dates, id: \.self) { date in
                DayCellView(
                    date: date,
                    isCompleted: isCompleted(on: date),
                    isSelected: isSameDay(date, selectedDate),
                    isDimmed: !calendar.isDate(date, equalTo: displayDate, toGranularity: .month)
                ) {
                    openDay(date)
                }
            }
        }
        .padding(.horizontal)
    }

    private var yearView: some View {
        let months = monthsForYear(containing: displayDate)

        return ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(months, id: \.self) { monthDate in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(monthTitle(for: monthDate))
                            .font(.headline)

                        let dates = datesForMonthGrid(containing: monthDate)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                            ForEach(dates, id: \.self) { date in
                                DayCellView(
                                    date: date,
                                    isCompleted: isCompleted(on: date),
                                    isSelected: isSameDay(date, selectedDate),
                                    isDimmed: !calendar.isDate(date, equalTo: monthDate, toGranularity: .month),
                                    compact: true
                                ) {
                                    openDay(date)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal)
        }
    }

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        return formatter.shortWeekdaySymbols
    }

    private func openDay(_ date: Date) {
        selectedDate = date
        showingDayDetail = true
    }

    private func isCompleted(on date: Date) -> Bool {
        checkIns.first(where: { calendar.isDate($0.date, inSameDayAs: date) })?.isCompleted ?? false
    }

    private func isSameDay(_ lhs: Date, _ rhs: Date?) -> Bool {
        guard let rhs else { return false }
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }

    private func moveBackward() {
        switch selectedZoom {
        case .week:
            displayDate = calendar.date(byAdding: .weekOfYear, value: -1, to: displayDate) ?? displayDate
        case .month:
            displayDate = calendar.date(byAdding: .month, value: -1, to: displayDate) ?? displayDate
        case .year:
            displayDate = calendar.date(byAdding: .year, value: -1, to: displayDate) ?? displayDate
        }
    }

    private func moveForward() {
        switch selectedZoom {
        case .week:
            displayDate = calendar.date(byAdding: .weekOfYear, value: 1, to: displayDate) ?? displayDate
        case .month:
            displayDate = calendar.date(byAdding: .month, value: 1, to: displayDate) ?? displayDate
        case .year:
            displayDate = calendar.date(byAdding: .year, value: 1, to: displayDate) ?? displayDate
        }
    }

    private func datesForWeek(containing date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: interval.start) }
    }

    private func datesForMonthGrid(containing date: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: date),
            let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let lastDayOfMonth = calendar.date(byAdding: DateComponents(day: -1), to: monthInterval.end),
            let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: lastDayOfMonth)
        else {
            return []
        }

        let start = firstWeek.start
        let end = lastWeek.end
        let dayCount = calendar.dateComponents([.day], from: start, to: end).day ?? 0

        return (0..<dayCount).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    private func monthsForYear(containing date: Date) -> [Date] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: date) else { return [] }
        return (0..<12).compactMap { calendar.date(byAdding: .month, value: $0, to: yearInterval.start) }
    }

    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
