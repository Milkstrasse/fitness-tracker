//
//  MainView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: ViewManager
    
    let user: User
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(user.trackables.indices, id: \.self) { index in
                        Button(action: {
                            manager.setView(view: AnyView(DataOverviewView(user: user, dataIndex: index).environmentObject(manager)))
                        }) {
                            TrackableDataView(data: user.trackables[index])
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            Button("\u{f067}") {
                manager.setView(view: AnyView(CreateEditDataView(user: user, dataIndex: -1).environmentObject(manager)))
            }
            .buttonStyle(CircleButton(size: 75, fontSize: 24))
        }
        .padding(.vertical, 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(user: User(trackables: [TrackableData(name: "Pushups", symbol: "0xf186", entries: [5, 2, 7, 8, 6])]))
    }
}
