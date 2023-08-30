//
//  Challenge.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 29.08.23.
//

import Foundation

struct Challenge {
    let title: String
    private let requirement: NSPredicate
    var isCompleted: Bool
    
    init(title: String, requirement: NSPredicate, isCompleted: Bool) {
        self.title = title
        self.requirement = requirement
        self.isCompleted = isCompleted
    }
    
    mutating func updateCompletion(value: UserData) {
        if isCompleted {
            return
        }
        
        if requirementIsMet(value: value) {
            isCompleted = true
        }
    }
    
    func requirementIsMet(value: NSObject) -> Bool {
        return requirement.evaluate(with: value)
    }
}
