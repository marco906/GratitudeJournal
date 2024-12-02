//
//  SettingsViewModel.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//
import Foundation
import SwiftUI

@MainActor
@Observable
class SettingsViewModel {
    private let nc = NotificationController.shared
    var user: User?
    var notificationTime: Date = Date()
    
    // Setup the view model with the user and set the notification time
    func setup(user: User) {
        self.user = user
        var components = DateComponents()
        components.hour = user.notificationHour
        components.minute = user.notificationMinute
        if let time = Calendar.current.date(from: components) {
            notificationTime = time
        }
    }
    
    // Sync the notification status
    func syncNotifications() async {
        user?.allowNotifications = await nc.isAuthorized()
    }
    
    // Set allow notifications, ask for permission if necessary and shedule the daily notification
    func setAllowNotifications(_ allow: Bool) {
        Task {
            if allow {
                let granted = await nc.checkAndRequestNotificationPermission()
                if granted {
                    await scheduleDailyNotification()
                } else {
                    user?.allowNotifications = false
                    openNotificationSettings()
                }
            } else {
                nc.cancelAndClearAllNotifications()
            }
        }
    }
    
    // Set the daily notification with the given time
    func setNotificationTime(_ time: Date) {
        nc.cancelAndClearAllNotifications()
        user?.notificationHour = Calendar.current.component(.hour, from: time)
        user?.notificationMinute = Calendar.current.component(.minute, from: time)
        Task {
            await scheduleDailyNotification()
        }
    }
    
    // Schedule the daily notification
    private func scheduleDailyNotification() async {
        await nc.scheduleDailyNotification(
            title: "Gratitude Journal",
            msg: "It's time for your daily journal entry!",
            hour: user?.notificationHour ?? 19,
            minute: user?.notificationMinute ?? 0
        )
    }
    
    // Open the system notification settings for the app
    private func openNotificationSettings() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
