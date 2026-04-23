//
//  GoalCardView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    private var subtitleText: String {
        switch goal.type {
        case .manual:
            return "\(goal.category) • Manual Goal"
        case .health:
            if let targetValue = goal.targetValue {
                return "\(goal.category) • Target: \(Int(targetValue)) steps"
            } else {
                return "\(goal.category) • Health Goal"
            }
        case .location:
            if let place = goal.targetLocationName, !place.isEmpty {
                return "\(goal.category) • Place: \(place)"
            } else {
                return "\(goal.category) • Location Goal"
            }
        }
    }

    private var badgeText: String {
        switch goal.type {
        case .manual:
            return "Manual"
        case .health:
            return "Health"
        case .location:
            return "Location"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)

                    Text(subtitleText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(badgeText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())
            }

            Group {
                switch goal.type {
                case .manual:
                    Text("Manual check-in flow will connect here.")
                case .health:
                    if let targetValue = goal.targetValue {
                        Text("This goal is ready for HealthKit step progress toward \(Int(targetValue)) daily steps.")
                    } else {
                        Text("This goal is ready for HealthKit integration.")
                    }
                case .location:
                    if let place = goal.targetLocationName, !place.isEmpty {
                        Text("This goal is ready for Core Location verification near \(place).")
                    } else {
                        Text("This goal is ready for Core Location and MapKit setup.")
                    }
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GoalCardView(
        goal: Goal(
            title: "10,000 Steps",
            category: "Health",
            type: .health,
            targetValue: 10000
        )
    )
    .padding()
}
