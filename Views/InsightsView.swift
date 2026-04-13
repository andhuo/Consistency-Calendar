//
//  InsightsView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/13/26.
//

import SwiftUI

struct InsightsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Insights")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    StatCard(title: "Current Streak", value: "4 days")
                    StatCard(title: "Longest Streak", value: "12 days")
                    StatCard(title: "Completion Rate", value: "78%")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    InsightsView()
}
