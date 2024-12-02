//
//  ContentView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

// View for displaying a list of journal entries
struct JournalView: View {
    var user: User
    @State var model = JournalViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.date, order: .reverse)
    private var entries: [Entry]

    var body: some View {
        NavigationStack {
            content
            .navigationTitle("Journal")
            .toolbar {
                toolbar
            }
            .task {
                model.setup(userName: user.name)
            }
            .sheet(isPresented: $model.showEntrySheet, onDismiss: model.resetCurrentEntry) {
                EntryDetailView(entry: model.currentEntry, user: user)
            }
        }
    }
    
    var content: some View {
        List {
            Section {
                header
            }
            
            if entries.isEmpty {
                Button("Add your first entry") {
                    model.addEntry()
                }
            }

            ForEach(entries) { entry in
                Section {
                    entryCell(entry)
                }
                .listSectionSpacing(.compact)
            }
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(model.greetingMessage)
                .font(.body)
                .fontWeight(.semibold)
            Text("Nice to see you! Here is an overview of your gratitude journal. You can add new entries or view and edit exiting entries.")
                .font(.subheadline)
        }
        
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 16, trailing: 0))
    }
    
    func entryCell(_ entry: Entry) -> some View {
        Button {
            model.editEntry(entry)
        } label: {
            EntryCell(title: entry.title, mood: entry.mood, date: entry.date, content: entry.content, image: entry.getImage()?.image)
        }
        .tint(Color.primary)
        .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
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

// MARK: - Previews

#Preview {
    JournalView(user: User(name: "Marco"))
        .modelContainer(DataController.shared.previewContainer)
}
