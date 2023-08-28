//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

class ViewManager: ObservableObject {
    @Published var currentView: AnyView = AnyView(Color.yellow.ignoresSafeArea())
    
    func setView(view: AnyView) {
        DispatchQueue.main.async {
            self.currentView = AnyView(view)
        }
    }
    
    func getCurrentView() -> AnyView {
        return currentView
    }
}

@main
struct FitnessTrackerApp: App {
    @StateObject var manager: ViewManager = ViewManager()
    @State var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.blue.ignoresSafeArea()
                if isLoading {
                    Color.red.ignoresSafeArea().onAppear {
                        let user: User = SaveManager.loadUser()
                        
                        DispatchQueue.global().async {
                            manager.setView(view: AnyView(MainView(user: user).environmentObject(manager)))
                            isLoading = false
                        }
                    }
                } else {
                    manager.getCurrentView()
                }
            }
        }
    }
}
