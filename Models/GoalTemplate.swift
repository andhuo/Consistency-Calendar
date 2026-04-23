//
//  GoalTemplate.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/22/26.
//

import Foundation

struct GoalTemplate: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let category: String
    let type: GoalType
    let suggestedDurationDays: Int?
    let targetValue: Double?
}

enum GoalTemplates {
    static let presets: [GoalTemplate] = [
        GoalTemplate(
            title: "75 Hard",
            category: "Challenge",
            type: .manual,
            suggestedDurationDays: 75,
            targetValue: nil
        ),
        GoalTemplate(
            title: "30 Day Gym Streak",
            category: "Fitness",
            type: .location,
            suggestedDurationDays: 30,
            targetValue: nil
        ),
        GoalTemplate(
            title: "10,000 Steps Daily",
            category: "Health",
            type: .health,
            suggestedDurationDays: 30,
            targetValue: 10000
        ),
        GoalTemplate(
            title: "No Contact",
            category: "Personal Growth",
            type: .manual,
            suggestedDurationDays: 30,
            targetValue: nil
        ),
        GoalTemplate(
            title: "Study Every Day",
            category: "Academics",
            type: .manual,
            suggestedDurationDays: 30,
            targetValue: nil
        )
    ]
}
