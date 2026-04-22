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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Goals")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    if goals.isEmpty {
                        Text("No goals yet. Add your first goal soon.")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    } else {
                        ForEach(goals) { goal in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(goal.title)
                                    .font(.headline)

                                Text("\(goal.category) • \(goal.type.rawValue)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
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
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
