//
//  GoalType.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/22/26.
//

import Foundation

enum GoalType: String, Codable, CaseIterable, Identifiable {
    case manual = "Manual"
    case health = "Health"
    case location = "Location"

    var id: String { rawValue }
}
