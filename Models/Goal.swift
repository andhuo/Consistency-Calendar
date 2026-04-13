//
//  Goal.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import Foundation

struct Goal: Identifiable, Hashable {
    let id: UUID
    var title: String
    var category: String
    var createdAt: Date
    var isCompletedToday: Bool

    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        createdAt: Date = Date(),
        isCompletedToday: Bool = false
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.createdAt = createdAt
        self.isCompletedToday = isCompletedToday
    }
}
