//
//  SettingsView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var user: User
    
    var body: some View {
        NavigationStack {
            List{
                Section("Name") {
                    TextField("Your Name", text: $user.name)
                }
                Section("Keep your journey going") {
                    Toggle("Daily Journal Reminder", isOn: $user.allowNotifications)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(user: User(name: "Marco"))
}
