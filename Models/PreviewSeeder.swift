//
//  PreviewSeeder.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import Foundation
import SwiftData

enum PreviewSeeder {
    static func makePreviewContainer() -> ModelContainer {
        let schema = Schema([
            Goal.self,
            CheckIn.self
        ])

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let context = container.mainContext

        let today = Date()
        let calendar = Calendar.current

        for offset in 0..<10 {
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let checkIn = CheckIn(
                date: date,
                isCompleted: offset % 3 != 0,
                note: offset % 2 == 0 ? "Solid progress today." : ""
            )
            context.insert(checkIn)
        }

        return container
    }
}
