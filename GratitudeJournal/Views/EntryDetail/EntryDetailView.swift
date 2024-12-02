//
//  EntryDetailView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

// View for creating or editing a journal entry
struct EntryDetailView: View {
    @State var model = EntryDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var entry: Entry?
    var user: User
    
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
                .confirmationDialog("Delete Entry?", isPresented: $model.showDeleteDialog, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        model.delete()
                        dismiss()
                    }
                }
                .photosPicker(isPresented: $model.showPhotosPicker, selection: $model.imageSelection)
            
        }
    }
    
    var content: some View {
        List {
            Section("Summary") {
                TextField("Title", text: $model.title)
                HStack{
                    Text("Mood")
                    Spacer()
                    EmojiTextField(text: model.emoji)
                        .frame(width: 40)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                }
                DatePicker("Date", selection: $model.date, displayedComponents: .date)
            }

            Section("Content") {
                TextField("How was your day, what where yo grateful for?", text: $model.content, axis: .vertical)
                    .lineLimit(2...15)
            }
            
            Section("Attachment") {
                if let image = model.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Button("Remove Image") {
                        model.removeImage()
                    }
                } else {
                    Button("Add Image") {
                        model.pickImage()
                    }
                }
            }
            
            if entry != nil {
                Section{
                    Button(role: .destructive) {
                        clickedDelete()
                    } label: {
                        HStack {
                            Text("Delete Entry")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }

                }
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
    
    func clickedDelete() {
        model.askToDelete()
    }
}

// MARK: - Previews

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

