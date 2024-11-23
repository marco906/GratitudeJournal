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
    
    func setup(user: User) {
        self.user = user
    }
    
    func syncNotifications() async {
        user?.allowNotifications = await checkNotificationPermissionStatus()
    }
    
    func setAllowNotifications() {
        Task {
            let granted = await checkNotificationPermissionStatus()
            if granted {
                await scheduleDailyNotification()
            } else {
                user?.allowNotifications = false
                openNotificationSettings()
            }
        }
    }
    
    private func scheduleDailyNotification() async {
        await nc.scheduleDailyNotification(
            title: "Gratitude Journal",
            msg: "It's time for your daily journal entry!",
            hour: 14,
            minute: 59
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
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
