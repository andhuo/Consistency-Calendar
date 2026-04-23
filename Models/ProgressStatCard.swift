//
//  ProgressStatCard.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import SwiftUI

struct ProgressStatCard: View {
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ProgressStatCard(title: "Current Streak", value: "4", subtitle: "days")
        .padding()
}
