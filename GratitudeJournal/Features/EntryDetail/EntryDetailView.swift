//
//  EntryDetailView.swift
//  GratitudeJournal
//
//  Created by Marco Wenzel on 22.11.2024.
//

import SwiftUI

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    EntryDetailView()
        .modelContainer(DataController.previewContainer)
}
