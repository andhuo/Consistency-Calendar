//
//  Goal.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import Foundation
import SwiftData

@Model
final class Goal {
    var title: String
    var category: String
    var type: GoalType
    var createdAt: Date
    var startDate: Date
    var reminderEnabled: Bool
    var reminderHour: Int
    var reminderMinute: Int
    var targetValue: Double?
    var targetLocationName: String?
    var targetLatitude: Double?
    var targetLongitude: Double?
    var isArchived: Bool

    init(
        title: String,
        category: String,
        type: GoalType,
        createdAt: Date = Date(),
        startDate: Date = Date(),
        reminderEnabled: Bool = false,
        reminderHour: Int = 9,
        reminderMinute: Int = 0,
        targetValue: Double? = nil,
        targetLocationName: String? = nil,
        targetLatitude: Double? = nil,
        targetLongitude: Double? = nil,
        isArchived: Bool = false
    ) {
        self.title = title
        self.category = category
        self.type = type
        self.createdAt = createdAt
        self.startDate = startDate
        self.reminderEnabled = reminderEnabled
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
        self.targetValue = targetValue
        self.targetLocationName = targetLocationName
        self.targetLatitude = targetLatitude
        self.targetLongitude = targetLongitude
        self.isArchived = isArchived
    }
}
