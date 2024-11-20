//
//  ContentView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Entry]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { entry in
                    Text(entry.title)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Entry.self, inMemory: true)
}
