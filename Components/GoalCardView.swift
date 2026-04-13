//
//  GoalCardView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI

struct GoalCardView: View {
    @Binding var goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)

                    Text(goal.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: goal.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(goal.isCompletedToday ? .green : .gray)
            }

            Button {
                goal.isCompletedToday.toggle()
            } label: {
                Text(goal.isCompletedToday ? "Completed Today" : "Mark Complete")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(goal.isCompletedToday ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GoalCardView(goal: .constant(Goal(title: "Go to the Gym", category: "Fitness")))
        .padding()
}
