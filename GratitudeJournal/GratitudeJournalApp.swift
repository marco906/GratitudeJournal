//
//  GratitudeJournalApp.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import SwiftUI
import SwiftData

// Entry point for the application, sets the main view and model container

@main
struct GratitudeJournalApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(DataController.shared.defaultContainer)
    }
}
