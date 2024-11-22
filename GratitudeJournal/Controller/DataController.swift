//
//  DataController.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftData

@MainActor
class DataController {
    static var shared = DataController()
    static let schema = Schema([User.self, Entry.self])
    
    let defaultContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
   let previewContainer: ModelContainer = {
        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let user = User(name: "Marco")
            container.mainContext.insert(user)

            for i in 1...9 {
                let entry = Entry(user: user)
                entry.title = "Entry \(i)"
                entry.content = "Content for entry \(i)"
                entry.mood = ["😁", "😊", "😉", "😫", "🤬", "😭", "🥳"].randomElement() ?? ""
                container.mainContext.insert(entry)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
