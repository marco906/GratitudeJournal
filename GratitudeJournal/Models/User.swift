//
//  User.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID = UUID()
    var name: String = ""
    var allowNotifications: Bool = false
    var notificationHour: Int = 19
    var notificationMinute: Int = 0
    
    @Relationship(deleteRule: .cascade, inverse: \Entry.user)
    var entries: [Entry] = []
    
    init(name: String) {
        self.name = name
    }
}
