//
//  GratitudeJournalApp.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

@main
struct GratitudeJournalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Entry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
