//
//  DietEntryRowView.swift
//  MunchMate
//
//  Created by Matthew Dudzinski on 6/26/25.
//

import SwiftUI
import SwiftData

struct DietEntryRowView: View {
    let entry: DietEntry
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("\(entry.mealType) - \(entry.date.formatted(date: .abbreviated, time: .shortened))")
                .font(.headline)
            Text(entry.foods.map { $0.name }.joined(separator: ", "))
                .font(.subheadline)
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
