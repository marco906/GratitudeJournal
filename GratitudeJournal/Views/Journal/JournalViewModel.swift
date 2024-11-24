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
    
    func setup(userName: String) {
        self.greetingMessage = userName.isEmpty ? "Hello ☺️" : "Hello, \(userName) ☺️"
    }
    
    func addEntry() {
        showEntrySheet = true
    }
    
    func editEntry(_ entry: Entry) {
        currentEntry = entry
        showEntrySheet = true
    }
    
    func resetCurrentEntry() {
        currentEntry = nil
    }
}
