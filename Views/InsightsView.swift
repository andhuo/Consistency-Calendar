//
//  InsightsView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query(sort: \CheckIn.date) private var checkIns: [CheckIn]

    private var stats: ProgressStats {
        ProgressCalculator.stats(from: checkIns)
    }

    private var weeklyPoints: [ProgressDataPoint] {
        ProgressCalculator.weeklyData(from: checkIns)
    }

    private var monthlyPoints: [ProgressDataPoint] {
        ProgressCalculator.monthlyData(from: checkIns)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ProgressStatCard(
                            title: "Current Streak",
                            value: "\(stats.currentStreak)",
                            subtitle: "days"
                        )

                        ProgressStatCard(
                            title: "Longest Streak",
                            value: "\(stats.longestStreak)",
                            subtitle: "days"
                        )

                        ProgressStatCard(
                            title: "Completion Rate",
                            value: "\(Int(stats.completionRate))%",
                            subtitle: "\(stats.totalCompletedDays)/\(stats.totalLoggedDays) completed"
                        )

                        ProgressStatCard(
                            title: "Completed Days",
                            value: "\(stats.totalCompletedDays)",
                            subtitle: "tracked check-ins"
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Last 7 Days")
                            .font(.headline)

                        Chart(weeklyPoints) { point in
                            BarMark(
                                x: .value("Day", point.label),
                                y: .value("Completed", point.value)
                            )
                        }
                        .frame(height: 220)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Last 6 Months")
                            .font(.headline)

                        Chart(monthlyPoints) { point in
                            LineMark(
                                x: .value("Month", point.label),
                                y: .value("Completed", point.value)
                            )

                            PointMark(
                                x: .value("Month", point.label),
                                y: .value("Completed", point.value)
                            )
                        }
                        .frame(height: 220)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity")
                            .font(.headline)

                        if checkIns.isEmpty {
                            Text("No progress tracked yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(checkIns.sorted(by: { $0.date > $1.date }).prefix(7), id: \.date) { checkIn in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(formattedDate(checkIn.date))
                                            .font(.subheadline)
                                            .fontWeight(.medium)

                                        if !checkIn.note.isEmpty {
                                            Text(checkIn.note)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: checkIn.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(checkIn.isCompleted ? .green : .gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    InsightsView()
        .modelContainer(PreviewSeeder.makePreviewContainer())
}
