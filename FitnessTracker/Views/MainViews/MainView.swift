//
//  MainView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: ViewManager
    
    @Binding var user: User
    
    @State var transitionToggle: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(user.trackables.indices, id: \.self) { index in
                            Button(action: {
                                manager.setView(view: AnyView(DataOverviewView(user: $user, dataIndex: index).environmentObject(manager)))
                            }) {
                                TrackableDataView(data: user.trackables[index], maxWidth: geometry.size.width)
                                    .opacity(transitionToggle ? 1 : 0).animation(.linear(duration: 0.1).delay(Double(index)/10), value: transitionToggle)
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                Button("\u{f067}") {
                    manager.setView(view: AnyView(CreateEditDataView(user: $user, dataIndex: -1).environmentObject(manager)))
                }
                .buttonStyle(CircleButton(size: 75, fontSize: 24))
            }
            .frame(width: geometry.size.width).padding(.vertical, 30)
            .onAppear {
                transitionToggle = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(user: Binding.constant(User(trackables: [TrackableData(name: "Pushups", symbol: "0xf186", entries: [5, 2, 7, 8, 6])], data: UserData())))
    }
}
