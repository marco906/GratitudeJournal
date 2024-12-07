//
//  EntryDetailViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

@Observable class EntryDetailViewModel {
    var date = Date()
    var title = ""
    var content = ""
    private var mood = "😊"
    
    var context: ModelContext?
    var user: User?
    var entry: Entry?
    
    var showDeleteDialog = false
    
    private var imageStore: AppImage?
    var image: Image? { imageStore?.image }
    
    var showPhotosPicker: Bool = false
    
    // Handles photo selection
    var imageSelection: PhotosPickerItem? {
        didSet {
            guard let imageSelection = imageSelection else {
                imageStore = nil
                return
            }
            Task {
                imageStore = try? await imageSelection.loadTransferable(type: AppImage.self)
            }
        }
    }
    
    var isNewEntry: Bool {
        entry == nil
    }
    
    var saveBtnTitle: String {
        isNewEntry ? "Save" : "Update"
    }
    
    var navTitle: String {
        isNewEntry ? "New Journal Entry" : "Edit Journal Entry"
    }
    
    var saveDisabled: Bool {
        title.isEmpty || content.isEmpty || mood.isEmpty
    }
    
    var emoji: Binding<String> {
        Binding(
            get: {
                self.mood
            },
            set: { new in
                if let emoji = new.last {
                    self.mood = String(emoji)
                } else {
                    self.mood = ""
                }
            }
        )
    }
    
    // Setup the view model, passing in the context, user and optional existing entry
    func setup(context: ModelContext, entry: Entry?, user: User) {
        self.context = context
        self.user = user
        
        // If we are editing an existing entry, set the values from the entry
        if let entry = entry {
            self.date = entry.date
            self.title = entry.title
            self.content = entry.content
            self.mood = entry.mood
            self.entry = entry
            self.imageStore = entry.getImage()
        }
    }
    
    // Save the entry to the persistent store
    @discardableResult
    func save() -> PersistentIdentifier? {
        guard let user = user else { return nil }
        let entryToSave = entry ?? Entry(user: user)
        entryToSave.date = date
        entryToSave.title = title
        entryToSave.content = content
        entryToSave.mood = mood
        entryToSave.setImageData(imageStore?.data)
        
        // If this is a new entry, insert it into the context
        if isNewEntry {
            context?.insert(entryToSave)
        }
        try? context?.save()
        return entryToSave.id
    }
    
    // Ask the user if they want to delete the entry and show a dialog
    func askToDelete() {
        showDeleteDialog = true
    }
    
    // Delete the entry
    func delete() {
        guard let entry = entry else { return }
        context?.delete(entry)
        try? context?.save()
    }
    
    // Show the photo picker
    func pickImage() {
        showPhotosPicker = true
    }
    
    // Remove the selected image
    func removeImage() {
        imageSelection = nil
    }
}
