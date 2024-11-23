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

            let entry1 = Entry(user: user)
            entry1.title = "Lazy Sunday"
            entry1.content = "Cozy, warm and lazy. A perfect day for a long nap. Feeling grateful for my family and friends."
            entry1.mood = "😊"
            container.mainContext.insert(entry1)
            
            let entry2 = Entry(user: user)
            entry2.title = "Struggle at work"
            entry2.content = "Bit exhausted after a long day at work. But Feeling grateful for my job and my colleagues."
            entry2.mood = "😮‍💨"
            container.mainContext.insert(entry2)
            
            let entry3 = Entry(user: user)
            entry3.title = "Beautiful hike"
            entry3.content = "Went hiking with my family. Feeling grateful for the nature and the fresh air."
            entry3.mood = "⛰️"
            container.mainContext.insert(entry3)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
