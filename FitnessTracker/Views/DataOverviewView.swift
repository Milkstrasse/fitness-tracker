//
//  DataOverviewView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct DataOverviewView: View {
    @EnvironmentObject var manager: ViewManager
    
    @State var user: User
    let dataIndex: Int
    
    @State var addingEntry: Bool = false
    @State var count: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 55)
                Text(user.trackables[dataIndex].name.uppercased()).font(.custom("Museo Sans Rounded", size: 16)).fontWeight(.bold).foregroundColor(Color("MainText")).padding(.leading, 15)
            }
            .padding(.horizontal, 30).padding(.top, 20)
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { value in
                    VStack(spacing: 5) {
                        if addingEntry {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 45)
                                FocusUIKitTextField(text: $count, isFirstResponder: true, numbersOnly: true)
                                .frame(height: 30)
                            }.id(0)
                            .onAppear {
                                value.scrollTo(0)
                            }
                        }
                        ForEach(user.trackables[dataIndex].entries.indices.reversed(), id: \.self) { index in
                            EntryView(entry: user.trackables[dataIndex].entries[index], isPressed: false, showButton: false)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            if !addingEntry {
                ZStack {
                    Rectangle().fill(Color("Main"))
                    LineGraph(data: user.trackables[dataIndex]).stroke(Color("MainText"), lineWidth: 5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, 30)
                .frame(height: 220)
            }
            HStack(spacing: 10) {
                Button("\u{f00d}") {
                    if addingEntry {
                        addingEntry = false
                        count = ""
                    } else {
                        manager.setView(view: AnyView(MainView(user: user).environmentObject(manager)))
                    }
                }
                .buttonStyle(CircleButton(size: 50, fontSize: 16))
                ZStack {
                    if addingEntry {
                        Button("\u{f00c}") {
                            addingEntry = false
                            user.trackables[dataIndex].addEntry(text: count)
                            
                            SaveManager.saveUser(user: user)
                            
                            count = ""
                        }
                        .buttonStyle(CircleButton(size: 75, fontSize: 24))
                        .disabled(!count.isNumber).opacity(count.isNumber ? 1 : 0.7)
                    } else {
                        Button("\u{f067}") {
                            addingEntry = true
                        }
                        .buttonStyle(CircleButton(size: 75, fontSize: 24))
                        .disabled(user.trackables[dataIndex].entries.count > 30).opacity(user.trackables[dataIndex].entries.count > 30 ? 0.7 : 1)
                    }
                }
                Button("\u{f304}") {
                    manager.setView(view: AnyView(CreateEditDataView(user: user, dataIndex: dataIndex).environmentObject(manager)))
                }
                .buttonStyle(CircleButton(size: 50, fontSize: 16))
            }
            .padding(.bottom, addingEntry ? 0 : 20)
        }
        .padding(.vertical, 10)
    }
}

struct DataOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        DataOverviewView(user: User(trackables: [TrackableData(name: "Pushups", symbol: "0xf186", entries: [5, 2, 7, 8, 6])]), dataIndex: 0)
    }
}

extension String {
    var isNumber: Bool {
        return self.range(of: "^[0-9]*$", options: .regularExpression) != nil
    }
}
