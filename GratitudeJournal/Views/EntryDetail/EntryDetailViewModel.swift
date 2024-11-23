//
//  EntryDetailViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Observable class EntryDetailViewModel {
    var date = Date()
    var title = ""
    var content = ""
    var mood = "😊"
    
    var context: ModelContext?
    var user: User?
    var entry: Entry?
    
    var showDeleteDialog = false
    
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
    
    func setup(context: ModelContext, entry: Entry?, user: User) {
        self.context = context
        self.user = user
        
        if let entry = entry {
            self.date = entry.date
            self.title = entry.title
            self.content = entry.content
            self.mood = entry.mood
            self.entry = entry
        }
    }
    
    func save() {
        let entryToSave = entry ?? Entry(user: user)
        entryToSave.date = date
        entryToSave.title = title
        entryToSave.content = content
        entryToSave.mood = mood
        
        if isNewEntry {
            context?.insert(entryToSave)
        }
    }
    
    func delete() {
        guard let entry = entry else { return }
        context?.delete(entry)
    }
}
