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
            content
            .navigationTitle("Journal")
            .toolbar {
                toolbar
            }
            .task {
                model.setup(user: user)
            }
            .sheet(isPresented: $model.showEntrySheet, onDismiss: model.resetCurrentEntry) {
                EntryDetailView(entry: model.currentEntry, user: user)
            }
        }
    }
    
    var content: some View {
        List {
            Section("Your Journal") {
                ForEach(entries) { entry in
                    entryCell(entry)
                }
            }
        }
        .navigationTitle("Journal")
    }
    
    func entryCell(_ entry: Entry) -> some View {
        Button {
            model.editEntry(entry)
        } label: {
            Text(entry.title)
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add") {
                model.addEntry()
            }
        }
    }
}

#Preview {
    JournalView(user: User(name: "Marco"))
        .modelContainer(DataController.shared.previewContainer)
}
