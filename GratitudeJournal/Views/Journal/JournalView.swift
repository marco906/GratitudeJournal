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
            Section(model.greetingMessage) {
                Text("Nice to see you ☺️! Here is an overview of your gratitude journal. You can add new entries or view and edit exiting entries.")
                    .font(.callout)
            }
            
            ForEach(entries) { entry in
                Section {
                    entryCell(entry)
                }
                .listSectionSpacing(.compact)
            }
        }
    }
    
    func entryCell(_ entry: Entry) -> some View {
        Button {
            model.editEntry(entry)
        } label: {
            EntryCell(title: entry.title, mood: entry.mood, date: entry.date, content: entry.content)
        }
        .tint(Color.primary)
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
