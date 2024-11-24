//
//  Entry.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Entry {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String = ""
    var content: String = ""
    var mood: String = ""
    
    @Attribute(.externalStorage)
    private var imageData: Data?
    
    var user: User?
    
    init(user: User) {
        self.user = user
    }
    
    func setImageData(_ data: Data?) {
        imageData = data
    }
    
    func getImage() -> AppImage? {
        if let imageData = imageData {
            return AppImage(data: imageData)
        } else {
            return nil
        }
    }
}
