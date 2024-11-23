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
    enum ModelState {
        case loading
        case normal(user: User)
        case error(message: String)
    }
    
    var state: ModelState = .loading
    private var context: ModelContext?
    
    func setup(context: ModelContext) {
        self.context = context
    }
    
    func start() {
        do {
            let user = try getOrCreateUser()
            state = .normal(user: user)
        } catch {
            state = .error(message: "Failed to load User: \(error.localizedDescription)")
        }
    }
    
    private func getOrCreateUser() throws -> User {
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
