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
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(DataController.defaultContainer)
    }
}
