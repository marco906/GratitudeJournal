//
//  MainViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class MainViewModel {
    enum ModelState: Equatable {
        case loading
        case normal(user: User)
        case error(message: String)
    }
    
    var state: ModelState = .loading
    private var context: ModelContext?
    
    // Setup the view model with model context
    func setup(context: ModelContext) {
        self.context = context
    }
    
    // On start load the user and set the model state
    func start() {
        do {
            let user = try getOrCreateUser()
            state = .normal(user: user)
        } catch {
            state = .error(message: "Failed to load User: \(error.localizedDescription)")
        }
    }
    
    // Get or create the current user
    func getOrCreateUser() throws -> User {
        let fetchDescriptor = FetchDescriptor<User>()
        let users = try context?.fetch(fetchDescriptor) ?? []
        
        if let existingUser = users.first {
            return existingUser
        } else {
            let user = User(name: "")
            context?.insert(user)
            try context?.save()
            return user
        }
    }
}
