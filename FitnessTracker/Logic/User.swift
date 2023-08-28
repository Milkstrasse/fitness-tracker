//
//  User.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

struct User: Codable {
    var trackables: [TrackableData]
    
    mutating func addTrackable(name: String, symbol: String) {
        trackables.append(TrackableData(name: name, symbol: symbol))
    }
    
    mutating func editTrackable(name: String, symbol: String, dataIndex: Int) {
        trackables[dataIndex].name = name
        trackables[dataIndex].symbol = symbol
    }
}
