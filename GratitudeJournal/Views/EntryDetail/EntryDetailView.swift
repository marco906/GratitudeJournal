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
    
    var emoji: Binding<String> {
        Binding(
            get: {
                model.mood
            },
            set: { new in
                if let emoji = new.last {
                    model.mood = String(emoji)
                } else {
                    model.mood = ""
                }
            }
        )
    }
    
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
            Section("Summary") {
                TextField("Title", text: $model.title)
                HStack{
                    Text("Mood")
                    Spacer()
                    EmojiTextField(text: emoji)
                        .frame(width: 40)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                }
                DatePicker("Date", selection: $model.date, displayedComponents: .date)
            }

            Section("Content") {
                TextField("How was your day, what where yo grateful for?", text: $model.content, axis: .vertical)
                    .lineLimit(2...15)
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(model.saveBtnTitle) {
                clickedSave()
            }
            .disabled(model.saveDisabled)
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

