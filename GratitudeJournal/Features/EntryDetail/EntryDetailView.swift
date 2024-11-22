//
//  EntryDetailView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

struct EntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var entry: Entry?
    var user: User
    @State var model = EntryDetailViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(model.navTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbar
                }
                .task {
                    model.setup(context: modelContext, entry: entry, user: user)
                }
        }
    }
    
    var content: some View {
        List {
            Section("Title") {
                TextField("Entry Title", text: $model.title)
            }
            Section("Text") {
                TextField("How was your day?", text: $model.content, axis: .vertical)
            }
            Section("Mood") {
                TextField("Your mood as Emoji", text: $model.mood)
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(model.saveBtnTitle) {
                clickedSave()
            }
        }
    }
    
    func clickedSave() {
        model.save()
        dismiss()
    }
}

#Preview("New Entry") {
    EntryDetailView(user: User(name: "Marco"))
        .modelContainer(DataController.shared.previewContainer)
}

#Preview("Edit Entry") {
    let user = User(name: "Marco")
    let entry = Entry(user: user)
    entry.title = "Lazy Sunday"
    entry.content = "Cozy, warm and lazy. A perfect day for a long nap."
    entry.mood = "😊"
    return EntryDetailView(entry: entry, user: user)
        .modelContainer(DataController.shared.previewContainer)
}

