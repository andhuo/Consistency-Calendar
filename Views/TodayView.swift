//
//  TodayView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

//
//  TodayView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Goal.createdAt) private var goals: [Goal]
    @State private var showingAddGoal = false

    private var activeGoalsCount: Int {
        goals.filter { !$0.isArchived }.count
    }

    private var locationGoalsCount: Int {
        goals.filter { $0.type == .location && !$0.isArchived }.count
    }

    private var healthGoalsCount: Int {
        goals.filter { $0.type == .health && !$0.isArchived }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                        .padding(.horizontal)
                        .padding(.top, 8)

                    statsSection
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Goals")
                            .font(.title2)
                            .fontWeight(.bold)

                        if goals.isEmpty {
                            emptyStateCard
                        } else {
                            ForEach(goals) { goal in
                                GoalCardView(goal: goal)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddGoal = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline)
                            .frame(width: 34, height: 34)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
                    .environment(\.modelContext, modelContext)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Consistency Calendar")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Dashboard")
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("Track momentum, stay accountable, and make each day count.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            dashboardStatCard(title: "Active Goals", value: "\(activeGoalsCount)", subtitle: "in progress")
            dashboardStatCard(title: "Location", value: "\(locationGoalsCount)", subtitle: "place-based")
            dashboardStatCard(title: "Health", value: "\(healthGoalsCount)", subtitle: "fitness goals")
        }
    }

    private var emptyStateCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No goals yet")
                .font(.headline)

            Text("Tap the + button to add a custom goal or start from a preset like 75 Hard, a gym streak, or a daily step goal.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func dashboardStatCard(title: String, value: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
