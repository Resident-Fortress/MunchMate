//
//  DietExtendedView.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/27/25.
//

import SwiftUI
import SwiftData

struct DietExtendedView: View {
    let entry: DietEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.mealType)
                .font(.title)
                .bold()

            Text("Date: \(entry.date.formatted(date: .long, time: .shortened))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            Text("Foods Eaten:")
                .font(.headline)
            ForEach(entry.foods, id: \.self) { food in
                VStack(alignment: .leading, spacing: 2) {
                    Text(food.name)
                        .font(.body)
                    if let quantity = food.quantity, !quantity.isEmpty {
                        Text("Quantity: \(quantity)")
                            .font(.caption)
                    }
                    if let foodNotes = food.notes, !foodNotes.isEmpty {
                        Text("Notes: \(foodNotes)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }

            if let notes = entry.notes, !notes.isEmpty {
                Divider()
                Text("Meal Notes:")
                    .font(.headline)
                Text(notes)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}
