//
//  JournalViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class JournalViewModel {
    var showEntrySheet = false
    var currentEntry: Entry?
    
    var greetingMessage: String = ""
    
    // Setup the view model with the user name
    func setup(userName: String) {
        self.greetingMessage = userName.isEmpty ? "Hello ☺️" : "Hello, \(userName) ☺️"
    }
    
    // Add a new entry
    func addEntry() {
        showEntrySheet = true
    }
    
    // Edit an existing entry
    func editEntry(_ entry: Entry) {
        currentEntry = entry
        showEntrySheet = true
    }
    
    // Reset the current entry
    func resetCurrentEntry() {
        currentEntry = nil
    }
}
