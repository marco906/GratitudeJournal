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
    var greetingMessage: String {
        if let name = user?.name, !name.isEmpty {
           "Hello, \(name)!"
        } else {
            "Hello!"
        }
    }
    
    private var user: User?
    
    func setup(user: User) {
        self.user = user
    }
}
