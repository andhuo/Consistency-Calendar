//
//  ProgressDataPoint.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import Foundation

struct ProgressDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let date: Date
}
