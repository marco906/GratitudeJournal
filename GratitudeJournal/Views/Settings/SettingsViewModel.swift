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
    
    func setup(user: User) {
        self.user = user
        var components = DateComponents()
        components.hour = user.notificationHour
        components.minute = user.notificationMinute
        if let time = Calendar.current.date(from: components) {
            notificationTime = time
        }
    }
    
    func syncNotifications() async {
        let status = await nc.getAuthorizationStatus()
        user?.allowNotifications = status == .authorized
    }
    
    func setAllowNotifications(_ allow: Bool) {
        Task {
            if allow {
                let granted = await checkNotificationPermissionStatus()
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
    
    func setNotificationTime(_ time: Date) {
        nc.cancelAndClearAllNotifications()
        user?.notificationHour = Calendar.current.component(.hour, from: time)
        user?.notificationMinute = Calendar.current.component(.minute, from: time)
        Task {
            await scheduleDailyNotification()
        }
    }
    
    private func scheduleDailyNotification() async {
        await nc.scheduleDailyNotification(
            title: "Gratitude Journal",
            msg: "It's time for your daily journal entry!",
            hour: user?.notificationHour ?? 19,
            minute: user?.notificationMinute ?? 0
        )
    }
    
    private func checkNotificationPermissionStatus() async -> Bool {
        let status = await nc.getAuthorizationStatus()
        switch status {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            return await nc.requestNotificationPermission()
        default:
            return false
        }
    }
    
    private func openNotificationSettings() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
