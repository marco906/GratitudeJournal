//
//  EntryDetailViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import Foundation
import SwiftData

@Observable class EntryDetailViewModel {
    var title = ""
    var content = ""
    var mood = ""
    
    var context: ModelContext?
    var user: User?
    var entry: Entry?
    
    var isNewEntry: Bool {
        entry == nil
    }
    
    var saveBtnTitle: String {
        isNewEntry ? "Save" : "Update"
    }
    
    func setup(context: ModelContext, entry: Entry?, user: User) {
        self.context = context
        self.user = user
        
        if let entry = entry {
            self.title = entry.title
            self.content = entry.content
            self.mood = entry.mood
        }
    }
    
    func save() {
        let entryToSave = entry ?? Entry(user: user)
        entryToSave.title = title
        entryToSave.content = content
        entryToSave.mood = mood
        
        if isNewEntry {
            context?.insert(entryToSave)
        }
    }
}
