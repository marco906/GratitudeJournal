//
//  AppImage.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 23.11.2024.
//

import SwiftUI

struct AppImage: Transferable, Equatable {
    let image: Image
    let data: Data
    
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
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        guard let jpegData = uiImage.jpegData(compressionQuality: 0.8) else { return nil }
        
        let image = Image(uiImage: uiImage)
        self.init(image: image, data: jpegData)
    }
}

enum TransferError: Error {
  case importFailed
}
