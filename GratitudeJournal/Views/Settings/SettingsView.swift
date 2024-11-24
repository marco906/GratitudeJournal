//
//  SettingsView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

struct SettingsView: View {
    @State var model = SettingsViewModel()
    @Bindable var user: User
    
    var body: some View {
        NavigationStack {
            List{
                Section("Name") {
                    TextField("Your Name", text: $user.name)
                }
                Section("Keep your journey going") {
                    Toggle("Daily Journal Reminder", isOn: $user.allowNotifications)
                    if user.allowNotifications {
                        DatePicker("Time", selection: $model.notificationTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section {
                    Button("Delete profile and data") {
                        // TODO: Implement
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .task {
                model.setup(user: user)
                await model.syncNotifications()
            }
            
            .onChange(of: user.allowNotifications) {
                model.setAllowNotifications(user.allowNotifications)
            }
            .onChange(of: model.notificationTime, initial: false) {
                model.setNotificationTime(model.notificationTime)
            }
        }
    }
}

#Preview {
    SettingsView(user: User(name: "Marco"))
}
