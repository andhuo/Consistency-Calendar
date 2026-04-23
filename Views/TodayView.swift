//
//  TodayView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Query(sort: \Goal.createdAt) private var goals: [Goal]
    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Goals")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    if goals.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("No goals yet.")
                                .font(.headline)

                            Text("Tap the + button to add a custom goal or start from a preset like 75 Hard, a gym streak, or a daily step goal.")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                    } else {
                        ForEach(goals) { goal in
                            GoalCardView(goal: goal)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Consistency Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
        }
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
