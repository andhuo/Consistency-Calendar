//
//  CalendarView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI

struct CalendarView: View {
    private let days = Array(1...30)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 7),
                    spacing: 12
                ) {
                    ForEach(days, id: \.self) { day in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(day % 3 == 0 ? Color.green.opacity(0.25) : Color.gray.opacity(0.15))
                                .frame(height: 48)

                            Text("\(day)")
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    CalendarView()
}
