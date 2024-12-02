//
//  AppImage.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//

import SwiftUI

// Helper struct to handle image transfer
struct AppImage: Transferable, Equatable {
    let image: Image
    let data: Data
    
    // implement Transferable protocol
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let image = AppImage(data: data) else {
                throw TransferError.importFailed
            }
            
            return image
        }
    }
}

extension AppImage {
    // create AppImage from Data
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        // get jpeg data from uiImage
        guard let jpegData = uiImage.jpegData(compressionQuality: 0.8) else { return nil }
        
        let image = Image(uiImage: uiImage)
        self.init(image: image, data: jpegData)
    }
}

enum TransferError: Error {
  case importFailed
}
