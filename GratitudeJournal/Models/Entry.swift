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
    var imageData: Data?
    
    var user: User?
    
    var image: Image? {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    init(user: User?) {
        self.user = user
    }
}
