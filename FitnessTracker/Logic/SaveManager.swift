//
//  SaveManager.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 28.08.23.
//

import Foundation

struct SaveManager {
    static func loadUser() -> User {
        let url: URL = makeURL(forFileNamed: "user.json")
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let data: Data = try Data(contentsOf: url)
                let user: User = try JSONDecoder().decode(User.self, from: data)
                
                return user
            } catch {
                let user: User = User(trackables: [], data: UserData())
                saveUser(user: user)
                
                print("\(error)")
                
                return user
            }
        } else {
            let user: User = User(trackables: [], data: UserData())
            saveUser(user: user)
            
            return user
        }
    }
    
    static func saveUser(user: User) {
        do {
            let data: Data = try JSONEncoder().encode(user)
            let url: URL = makeURL(forFileNamed: "user.json")
            try data.write(to: url, options: [.atomic])
        } catch {
            print("\(error)")
        }
    }
    
    static func makeURL(forFileNamed fileName: String) -> URL {
        let url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent(fileName)
    }
}
