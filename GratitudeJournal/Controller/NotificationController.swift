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
            print("Daily notification scheduled.")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        return await notificationCenter.notificationSettings().authorizationStatus
    }
    
    func requestNotificationPermission() async -> Bool {
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
}
