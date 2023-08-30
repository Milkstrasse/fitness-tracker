//
//  User.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import Foundation

struct User: Codable {
    var trackables: [TrackableData]
    var data: UserData
    
    var currChallenge: Int
    var challenges: [Challenge]
    
    init(trackables: [TrackableData], data: UserData) {
        self.trackables = trackables
        self.data = data
        self.currChallenge = 0
        self.challenges = []
        
        generateChallenges()
    }
    
    enum CodingKeys: String, CodingKey {
        case trackables, data, currChallenge
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        trackables = try container.decode([TrackableData].self, forKey: .trackables)
        data = try container.decode(UserData.self, forKey: .data)
        currChallenge = try container.decode(Int.self, forKey: .currChallenge)
        challenges = []
        
        generateChallenges()
        checkChallenge()
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(trackables, forKey: .trackables)
        try container.encode(data, forKey: .data)
        try container.encode(currChallenge, forKey: .currChallenge)
    }
    
    mutating func generateChallenges() {
        challenges.append(Challenge(title: "add new category", requirement: NSPredicate(format: "%K >= %@", "newCategoryAdded", NSNumber(value: true)), isCompleted: false))
        challenges.append(Challenge(title: "add 5 entries", requirement: NSPredicate(format: "%K >= %@", "entriesAdded", NSNumber(value: 5)), isCompleted: false))
        challenges.append(Challenge(title: "new personal best", requirement: NSPredicate(format: "%K >= %@", "newPersonalBest", NSNumber(value: true)), isCompleted: false))
    }
    
    mutating func addTrackable(name: String, symbol: String) {
        trackables.append(TrackableData(name: name, symbol: symbol))
        
    }
    
    mutating func editTrackable(name: String, symbol: String, dataIndex: Int) {
        trackables[dataIndex].name = name
        trackables[dataIndex].symbol = symbol
    }
    
    mutating func removeTrackable(index: Int) {
        trackables.remove(at: index)
    }
    
    mutating func checkChallenge() {
        if !Calendar.current.isDateInToday(data.lastDate) {
            data = UserData()
            currChallenge = Int.random(in: 1 ..< challenges.count)
        }
        
        challenges[currChallenge].updateCompletion(value: data)
    }
}

class UserData: NSObject, Codable {
    var lastDate: Date
    
    @objc var newCategoryAdded: Bool
    @objc var entriesAdded: Int
    @objc var entryAddedTo: Bool
    @objc var newPersonalBest: Bool
    
    override init() {
        self.lastDate = Date()
        
        self.newCategoryAdded = false
        self.entriesAdded = 0
        self.entryAddedTo = false
        self.newPersonalBest = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.lastDate = try container.decode(Date.self, forKey: .lastDate)
        self.newCategoryAdded = try container.decode(Bool.self, forKey: .newCategoryAdded)
        self.entriesAdded = try container.decode(Int.self, forKey: .entriesAdded)
        self.entryAddedTo = try container.decode(Bool.self, forKey: .entryAddedTo)
        self.newPersonalBest = try container.decode(Bool.self, forKey: .newPersonalBest)
    }
}
