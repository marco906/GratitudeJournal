//
//  GratitudeJournalTests.swift
//  GratitudeJournalTests
//
//  Created by Marco Wenzel on 20.11.2024.
//

import Testing
import SwiftData
import Foundation
@testable import GratitudeJournal

struct MainViewModelTests {

    @Test @MainActor
    func createNewUserIfNotExists() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let model = MainViewModel()
        model.setup(context: context)
        
        let user = try model.getOrCreateUser()
        #expect(user.name == "")
        
        modelContainer.deleteAllData()
    }
    
    @Test @MainActor
    func loadExistingUser() async throws {
        let modelContainer = DataController.shared.previewContainer
        let context = modelContainer.mainContext
        
        let model = MainViewModel()
        model.setup(context: context)
        
        let user = try model.getOrCreateUser()
        #expect(user.name == "Marco")
    }
    
    @Test @MainActor
    func startShouldCompleteWithStateNormal() async throws {
        let modelContainer = DataController.shared.previewContainer
        let context = modelContainer.mainContext
        
        let model = MainViewModel()
        #expect(model.state == .loading)
        
        model.setup(context: context)
        model.start()
        
        let expextedUser = try model.getOrCreateUser()
        #expect(model.state == .normal(user: expextedUser))
    }
}

struct JournalViewModelTests {

    @Test @MainActor
    func setupGreetingMessage() async throws {
        let model = JournalViewModel()
        model.setup(userName: "Marco")
        #expect(model.greetingMessage == "Hello, Marco ☺️")
        
        model.setup(userName: "")
        #expect(model.greetingMessage == "Hello ☺️")
    }
    
    @Test @MainActor
    func addNewEntry() async throws {
        let model = JournalViewModel()
        model.addEntry()
        #expect(model.showEntrySheet)
    }
    
    @Test @MainActor
    func editEntry() async throws {
        let model = JournalViewModel()
        let entry = Entry(user: User(name: "Marco"))
        model.editEntry(entry)
        #expect(model.currentEntry == entry)
    }
    
    @Test @MainActor
    func resetEntry() async throws {
        let model = JournalViewModel()
        let entry = Entry(user: User(name: "Marco"))
        model.editEntry(entry)
        #expect(model.currentEntry == entry)
        
        model.resetCurrentEntry()
        #expect(model.currentEntry == nil)
    }
}

struct EntryDetailViewModelTests {

    @Test @MainActor
    func setupForNewEntry() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let user = User(name: "Test")
        context.insert(user)
        
        let model = EntryDetailViewModel()
        
        model.setup(context: context, entry: nil, user: user)
        #expect(model.user == user)
        #expect(model.entry == nil)
        #expect(model.title == "")
        #expect(model.content == "")
        #expect(model.emoji.wrappedValue == "😊")
        #expect(model.image == nil)
        #expect(model.isNewEntry == true)
        
        modelContainer.deleteAllData()
    }
    
    @Test @MainActor
    func setupForExistingEntry() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let user = User(name: "Test")
        context.insert(user)
        let entry = Entry(user: user)
        context.insert(entry)
        
        let model = EntryDetailViewModel()
        
        model.setup(context: context, entry: entry, user: user)
        #expect(model.user == user)
        #expect(model.entry == entry)
        #expect(model.date == entry.date)
        #expect(model.title == entry.title)
        #expect(model.content == entry.content)
        #expect(model.emoji.wrappedValue == entry.mood)
        #expect(model.image == entry.getImage()?.image)
        #expect(model.isNewEntry == false)
        
        modelContainer.deleteAllData()
    }
    
    @Test @MainActor
    func saveNewEntry() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let user = User(name: "Test")
        context.insert(user)
        
        let model = EntryDetailViewModel()
        
        model.setup(context: context, entry: nil, user: user)
        
        model.title = "Test Title"
        model.content = "Test Content"
        model.emoji.wrappedValue = "🤓"
        
        let id = model.save()!
        
        let savedModel = context.model(for: id) as! Entry
        
        #expect(savedModel.title == model.title)
        #expect(savedModel.content == model.content)
        #expect(savedModel.mood == model.emoji.wrappedValue)
        
        modelContainer.deleteAllData()
    }
    
    @Test @MainActor
    func saveExistingEntry() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let user = User(name: "Test")
        context.insert(user)
        let entry = Entry(user: user)
        context.insert(entry)
        
        let model = EntryDetailViewModel()
        
        model.setup(context: context, entry: entry, user: user)
        
        model.title = "Test Title"
        model.content = "Test Content"
        model.emoji.wrappedValue = "🤓"
        
        model.save()
        
        let savedModel = context.model(for: entry.id) as! Entry
        
        #expect(savedModel.title == model.title)
        #expect(savedModel.content == model.content)
        #expect(savedModel.mood == model.emoji.wrappedValue)
        
        modelContainer.deleteAllData()
    }
}

struct SettingsViewModelTests {
    
    @Test @MainActor
    func setup() async throws {
        let modelContainer = DataController.shared.previewContainerEmpty()
        let context = modelContainer.mainContext
        
        let user = User(name: "Test")
        user.notificationHour = 18
        user.notificationMinute = 30
        context.insert(user)
        
        let model = SettingsViewModel()
        model.setup(user: user, context: context)
        
        var components = DateComponents()
        components.hour = user.notificationHour
        components.minute = user.notificationMinute
        
        #expect(model.notificationTime == Calendar.current.date(from: components))
        #expect(model.user == user)
    }
}


