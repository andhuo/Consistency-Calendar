//
//  DayCellView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import SwiftUI

struct DayCellView: View {
    let date: Date
    let isCompleted: Bool
    let isSelected: Bool
    var isDimmed: Bool = false
    var compact: Bool = false
    let action: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        Button(action: action) {
            Text("\(calendar.component(.day, from: date))")
                .font(compact ? .caption2 : .body)
                .fontWeight(isSelected ? .bold : .regular)
                .frame(maxWidth: .infinity)
                .frame(height: compact ? 24 : 40)
                .background(backgroundStyle)
                .foregroundStyle(foregroundStyle)
                .clipShape(RoundedRectangle(cornerRadius: compact ? 6 : 10))
        }
        .buttonStyle(.plain)
    }

    private var backgroundStyle: Color {
        if isSelected {
            return .blue.opacity(0.35)
        } else if isCompleted {
            return .green.opacity(0.25)
        } else {
            return .gray.opacity(0.12)
        }
    }

    private var foregroundStyle: Color {
        if isDimmed {
            return .gray
        } else {
            return .primary
        }
    }
}

#Preview {
    DayCellView(
        date: Date(),
        isCompleted: true,
        isSelected: false
    ) {}
    .padding()
}
