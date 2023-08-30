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
    
    @State var user: User = User(trackables: [], data: UserData())
    
    var body: some Scene {
        WindowGroup {
            ZStack() {
                Color("Main").ignoresSafeArea()
                if isLoading {
                    Color.red.ignoresSafeArea().onAppear {
                        user = SaveManager.loadUser()
                        
                        DispatchQueue.global().async {
                            manager.setView(view: AnyView(MainView(user: $user).environmentObject(manager)))
                            isLoading = false
                        }
                    }
                } else {
                    LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom).cornerRadius(30, corners: [.topLeft, .topRight]).ignoresSafeArea().padding(.top, 120)
                    VStack(spacing: 0) {
                        ChallengeView(user: user)
                        manager.getCurrentView()
                    }
                }
            }
        }
    }
}

//https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
