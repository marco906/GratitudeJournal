//
//  Entry.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var mood: String = ""
    
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
}
