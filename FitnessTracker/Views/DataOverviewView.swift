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
                RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 55)
                Text(user.trackables[dataIndex].name.uppercased()).foregroundColor(Color.white)
            }
            .padding(.horizontal, 30).padding(.top, 20)
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { value in
                    VStack(spacing: 5) {
                        if addingEntry {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 45)
                                FocusUIKitTextField(text: $count, isFirstResponder: true, numbersOnly: true)
                                .frame(height: 30)
                            }.id(0)
                            .onAppear {
                                value.scrollTo(0)
                            }
                        }
                        ForEach(user.trackables[dataIndex].entries.indices.reversed(), id: \.self) { index in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 45)
                                Text("\(user.trackables[dataIndex].entries[index])").foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            if !addingEntry {
                ZStack {
                    Rectangle().fill(Color.red)
                    LineGraph(data: user.trackables[dataIndex]).stroke(.white, lineWidth: 5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, 30)
                .frame(height: 220)
            }
            HStack(spacing: 10) {
                Button(action: {
                    if addingEntry {
                        addingEntry = false
                        count = ""
                    } else {
                        manager.setView(view: AnyView(MainView(user: user).environmentObject(manager)))
                    }
                }) {
                    ZStack {
                        Circle().fill(Color.black)
                        Text("\u{f00d}").font(.custom("Font Awesome 5 Free", size: 20)).foregroundColor(Color.white)
                    }
                    .frame(width: 50, height: 50)
                }
                ZStack {
                    if addingEntry {
                        Button(action: {
                            addingEntry = false
                            user.trackables[dataIndex].addEntry(text: count)
                            
                            SaveManager.saveUser(user: user)
                            
                            count = ""
                        }) {
                            ZStack {
                                Circle().fill(Color.black)
                                Text("\u{f00c}").font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white)
                            }
                            .frame(width: 75, height: 75)
                        }
                        .disabled(!count.isNumber)
                    } else {
                        Button(action: {
                            addingEntry = true
                        }) {
                            ZStack {
                                Circle().fill(Color.black)
                                Text("\u{f067}").font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white)
                            }
                            .frame(width: 75, height: 75)
                        }
                        .disabled(user.trackables[dataIndex].entries.count > 30)
                    }
                }
                Button(action: {
                    manager.setView(view: AnyView(CreateEditDataView(user: user, dataIndex: dataIndex).environmentObject(manager)))
                }) {
                    ZStack {
                        Circle().fill(Color.black)
                        Text("\u{f304}").font(.custom("Font Awesome 5 Free", size: 20)).foregroundColor(Color.white)
                    }
                    .frame(width: 50, height: 50)
                }
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
