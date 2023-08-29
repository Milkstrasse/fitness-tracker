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
            ZStack() {
                Color("Main").ignoresSafeArea()
                if isLoading {
                    Color.red.ignoresSafeArea().onAppear {
                        let user: User = SaveManager.loadUser()
                        
                        DispatchQueue.global().async {
                            manager.setView(view: AnyView(MainView(user: user).environmentObject(manager)))
                            isLoading = false
                        }
                    }
                } else {
                    LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom).cornerRadius(30, corners: [.topLeft, .topRight]).ignoresSafeArea().padding(.top, 120)
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                                Image("avatar").resizable().scaleEffect(2).offset(x: 10, y: -8)
                            }
                            .frame(width: 60, height: 60).clipShape(RoundedRectangle(cornerRadius: 15))
                            Triangle().fill(Color("Challenge")).frame(width: 10, height: 15).padding(.leading, 5)
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 15).fill(Color("Challenge"))
                                VStack(alignment: .leading) {
                                    Text("Challenge".uppercased()).font(.custom("Museo Sans Rounded", size: 16)).fontWeight(.bold).foregroundColor(Color("MainText"))
                                    Text("Description").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                                }
                                .padding(.leading, 15)
                            }
                            .frame(height: 60)
                        }
                        .padding(.all, 30)
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
