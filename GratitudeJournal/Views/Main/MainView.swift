//
//  MainView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

// Main view for the application showing a tab view
struct MainView: View {
    @State var model = MainViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        content
            .task {
                model.setup(context: modelContext)
                model.start()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch model.state {
        case .loading:
            ProgressView()
        case .normal(let user):
            TabView {
                JournalView(user: user)
                    .tabItem {
                        Label("Journal", systemImage: "book.closed")
                    }
                SettingsView(user: user)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        case .error(let message):
            Text(message)
        }
    }
}

// MARK: - Previews

#Preview {
    MainView()
        .modelContainer(DataController.shared.previewContainer)
}
