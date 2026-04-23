//
//  CalendarZoom.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import Foundation

enum CalendarZoom: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: String { rawValue }
}
