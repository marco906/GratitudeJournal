//
//  ContentView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    var user: User
    @State var model = JournalViewModel()
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
                    }
                }
            }
            .task {
                model.setup(user: user)
            }
        }
    }
}

#Preview {
    JournalView(user: User(name: "Marco"))
        .modelContainer(DataController.shared.previewContainer)
}
