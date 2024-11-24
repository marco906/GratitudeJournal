//
//  NotificationController.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//
import Foundation
import UserNotifications

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
    
    func scheduleDailyNotification(title: String, msg: String, hour: Int, minute: Int) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = msg
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyNotification", content: content, trigger: trigger)

        do {
            try await notificationCenter.add(request)
            print("Daily notification scheduled at \(hour):\(minute)")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }
    
    func isAuthorized() async -> Bool {
        let status = await getAuthorizationStatus()
        return status == .authorized
    }
    
    private func getAuthorizationStatus() async -> UNAuthorizationStatus {
        return await notificationCenter.notificationSettings().authorizationStatus
    }
    
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
    
    private func cancelAllScheduledNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("All scheduled notifications have been canceled.")
    }

    private func clearAllDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        print("All delivered notifications have been cleared.")
    }

    func cancelAndClearAllNotifications() {
        cancelAllScheduledNotifications()
        clearAllDeliveredNotifications()
    }
}
