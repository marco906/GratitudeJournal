//
//  NotificationController.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//
import Foundation
import UserNotifications

// Controller for handling user notifications
class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationController()
    
    
    private let notificationCenter = UNUserNotificationCenter.current()

    // Handle notifications received while the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Notification received in foreground: \(notification.request.content.body)")
        
        clearAllDeliveredNotifications()
    }

    // Handle notifications that triggered the app's launch or were tapped
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("App launched or resumed via notification: \(userInfo)")

        // Clean up the notification from the Notification Center
        clearAllDeliveredNotifications()

        completionHandler()
    }
    
    // Schedules a daily notification with the specified title, message, hour, and minute
    func scheduleDailyNotification(title: String, msg: String, hour: Int, minute: Int) async {
        // Configure the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = msg
        content.sound = .default

        // Configure the time components and the trigger
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Configure the notification request
        let request = UNNotificationRequest(identifier: "DailyNotification", content: content, trigger: trigger)

        // Schedule the notification
        do {
            try await notificationCenter.add(request)
            print("Daily notification scheduled at \(hour):\(minute)")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }
    
    // Checks if the user has granted permission to receive notifications
    func isAuthorized() async -> Bool {
        let status = await getAuthorizationStatus()
        return status == .authorized
    }
    
    // Get the current authorization status for notifications
    private func getAuthorizationStatus() async -> UNAuthorizationStatus {
        return await notificationCenter.notificationSettings().authorizationStatus
    }
    
    // Request permission to receive notifications
    private func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("Permission granted")
                return true
            } else {
                print("Permission denied")
            }
        } catch {
            print("Error requesting permission: \(error)")
        }
        return false
    }
    
    // Check if notifications are enabled and request permission if necessary
    func checkAndRequestNotificationPermission() async -> Bool {
        let status = await getAuthorizationStatus()
        switch status {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            return await requestNotificationPermission()
        default:
            return false
        }
    }
    
    // Cancel all scheduled notifications
    private func cancelAllScheduledNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("All scheduled notifications have been canceled.")
    }

    // Remove all delivered notifications
    private func clearAllDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        print("All delivered notifications have been cleared.")
    }

    // Cancel all scheduled notifications and remove all delivered notifications
    func cancelAndClearAllNotifications() {
        cancelAllScheduledNotifications()
        clearAllDeliveredNotifications()
    }
}
