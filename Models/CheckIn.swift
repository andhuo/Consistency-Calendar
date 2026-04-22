//
//  CheckIn.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/22/26.
//

import Foundation
import SwiftData

@Model
final class CheckIn {
    var date: Date
    var isCompleted: Bool
    var note: String
    var photoData: Data?
    var goal: Goal?

    init(
        date: Date,
        isCompleted: Bool = false,
        note: String = "",
        photoData: Data? = nil,
        goal: Goal? = nil
    ) {
        self.date = date
        self.isCompleted = isCompleted
        self.note = note
        self.photoData = photoData
        self.goal = goal
    }
}
