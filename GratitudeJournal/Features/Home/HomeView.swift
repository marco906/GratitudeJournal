//
//  ContentView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject var model = HomeViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]

    var body: some View {
        NavigationStack {
            List {
                Text(model.greetingMessage)
                
                Section("Your Journal") {
                    ForEach(entries) { entry in
                        Text(entry.title)
                    }
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        model.addEntry()
                    }
                }
            }
            .task {
                model.setup(context: modelContext)
                model.start()
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Entry.self, inMemory: true)
}
