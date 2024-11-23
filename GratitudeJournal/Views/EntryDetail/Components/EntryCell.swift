//
//  EntryCell.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//

import SwiftUI

struct EntryCell: View {
    var title: String
    var mood: String
    var date: Date
    var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(mood)
                    .font(.callout)
                Text(title)
                Spacer()
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Text(content)
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }
}

#Preview {
    List {
        EntryCell(title: "Lazy Sunday", mood: "😊", date: Date(), content: "Cozy, warm and lazy. A perfect day for a long nap. Feeling good, grateful for everything.")
    }
}
