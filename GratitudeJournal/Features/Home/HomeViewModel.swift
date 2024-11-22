//
//  HomeViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class HomeViewModel {
    enum ModelState {
        case loading
        case normal
        case error(message: String)
    }
    
    var state: ModelState = .loading
    var greetingMessage: String {
        if let name = user?.name {
           "Hello, \(name)!"
        } else {
            "Hello!"
        }
    }
    
    private var user: User?
    private var context: ModelContext?
    
    func setup(context: ModelContext) {
        self.context = context
    }
    
    func start() {
        do {
            try getOrCreateUser()
            state = .normal
        } catch {
            state = .error(message: "Failed to load User: \(error.localizedDescription)")
        }
    }
    
    func getOrCreateUser() throws {
        var fetchDescriptor = FetchDescriptor<User>()
        fetchDescriptor.propertiesToFetch = [\.name]
        
        let users = try context?.fetch(fetchDescriptor) ?? []
        
        if let existingUser = users.first {
            user = existingUser
        } else {
            let user = User()
            context?.insert(user)
            try context?.save()
        }
    }
    
    func addEntry() {
        let entry = Entry(user: user)
        context?.insert(entry)
        try? context?.save()
    }
}
