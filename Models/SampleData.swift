//
//  SampleData.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import Foundation

enum SampleData {
    static let goals: [Goal] = [
        Goal(title: "Go to the Gym", category: "Fitness"),
        Goal(title: "Track Calories", category: "Health", isCompletedToday: true),
        Goal(title: "No Contact", category: "Personal Growth")
    ]
}
