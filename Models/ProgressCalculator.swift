//
//  ProgressCalculator.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import Foundation

enum ProgressCalculator {
    static func stats(from checkIns: [CheckIn]) -> ProgressStats {
        let sorted = checkIns.sorted { $0.date < $1.date }
        let completed = sorted.filter { $0.isCompleted }

        let totalLoggedDays = sorted.count
        let totalCompletedDays = completed.count
        let completionRate = totalLoggedDays == 0 ? 0 : (Double(totalCompletedDays) / Double(totalLoggedDays)) * 100

        let currentStreak = calculateCurrentStreak(from: sorted)
        let longestStreak = calculateLongestStreak(from: sorted)

        return ProgressStats(
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            completionRate: completionRate,
            totalCompletedDays: totalCompletedDays,
            totalLoggedDays: totalLoggedDays
        )
    }

    static func weeklyData(from checkIns: [CheckIn]) -> [ProgressDataPoint] {
        let calendar = Calendar.current
        let today = Date()

        let past7Days = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -6 + $0, to: calendar.startOfDay(for: today))
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E"

        return past7Days.map { date in
            let completedCount = checkIns.filter {
                calendar.isDate($0.date, inSameDayAs: date) && $0.isCompleted
            }.count

            return ProgressDataPoint(
                label: formatter.string(from: date),
                value: Double(completedCount),
                date: date
            )
        }
    }

    static func monthlyData(from checkIns: [CheckIn]) -> [ProgressDataPoint] {
        let calendar = Calendar.current
        let today = Date()

        let months = (0..<6).compactMap {
            calendar.date(byAdding: .month, value: -5 + $0, to: today)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        return months.map { monthDate in
            let count = checkIns.filter {
                calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) && $0.isCompleted
            }.count

            return ProgressDataPoint(
                label: formatter.string(from: monthDate),
                value: Double(count),
                date: monthDate
            )
        }
    }

    private static func calculateCurrentStreak(from checkIns: [CheckIn]) -> Int {
        let calendar = Calendar.current
        let completedDates = Set(
            checkIns.filter { $0.isCompleted }
                .map { calendar.startOfDay(for: $0.date) }
        )

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        while completedDates.contains(currentDate) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previous
        }

        return streak
    }

    private static func calculateLongestStreak(from checkIns: [CheckIn]) -> Int {
        let calendar = Calendar.current
        let completedDates = Array(
            Set(checkIns.filter { $0.isCompleted }.map { calendar.startOfDay(for: $0.date) })
        ).sorted()

        guard !completedDates.isEmpty else { return 0 }

        var longest = 1
        var current = 1

        for index in 1..<completedDates.count {
            let previous = completedDates[index - 1]
            let currentDate = completedDates[index]

            if let expectedNext = calendar.date(byAdding: .day, value: 1, to: previous),
               calendar.isDate(expectedNext, inSameDayAs: currentDate) {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }

        return longest
    }
}
