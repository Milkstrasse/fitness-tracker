//
//  TrackableData.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import Foundation

struct TrackableData: Codable {
    var name: String
    var symbol: String
    var record: Int
    
    var entries: [Int]
    
    init(name: String, symbol: String, entries: [Int] = []) {
        if name == "" {
            self.name = "Title"
        } else {
            self.name = name
        }
        
        self.symbol = symbol
        self.record = 0
        self.entries = entries
    }
    
    func getAverage() -> Int {
        if entries.isEmpty {
            return 0
        }
        
        var amount: Int = 0
        for entry in entries {
            amount += entry
        }
        
        return Int(roundf(Float(amount)/Float(entries.count)))
    }
    
    func getMinimum() -> Int {
        if entries.count < 2 {
            return 0
        }
        
        var minimum = entries[0]
        
        for entry in entries {
            if entry < minimum {
                minimum = entry
            }
        }
        
        return minimum
    }
    
    func getMaximum() -> Int {
        if entries.count < 2 {
            return 0
        }
        
        var maximum = entries[0]
        
        for entry in entries {
            if entry > maximum {
                maximum = entry
            }
        }
        
        return maximum
    }
    
    mutating func addEntry(text: String) {
        let count: Int = Int(text) ?? 1
        
        if entries.count < 31 {
            if count > record {
                record = count
            }
            
            entries.append(count)
        }
    }
    
    mutating func removeEntry(index: Int) {
        entries.remove(at: index)
    }
}
