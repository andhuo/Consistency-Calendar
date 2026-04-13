//
//  TodayView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI

struct TodayView: View {
    @State private var goals = SampleData.goals

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Goals")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach($goals) { $goal in
                        GoalCardView(goal: $goal)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Consistency Calendar")
        }
    }
}

#Preview {
    TodayView()
}
