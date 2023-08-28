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
            Button(action: {
                manager.setView(view: AnyView(CreateEditDataView(user: user, dataIndex: -1).environmentObject(manager)))
            }) {
                ZStack {
                    Circle().fill(Color.black)
                    Text("\u{f067}").font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white)
                }
                .frame(width: 75, height: 75)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(user: User(trackables: []))
    }
}
