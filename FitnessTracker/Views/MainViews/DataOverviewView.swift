//
//  DataOverviewView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct DataOverviewView: View {
    @EnvironmentObject var manager: ViewManager
    
    @Binding var user: User
    let dataIndex: Int
    
    @State var addingEntry: Bool = false
    @State var count: String = ""
    
    @State var transitionToggle: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 55)
                    HStack(spacing: 0) {
                        Text(user.trackables[dataIndex].name.uppercased()).font(.custom("Museo Sans Rounded", size: 16)).fontWeight(.bold).foregroundColor(Color("MainText")).frame(width: geometry.size.width - 225, alignment: .leading).lineLimit(1).padding(.leading, 15)
                        HStack(spacing: 0) {
                            Text("record").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Text(":").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Text("\(user.trackables[dataIndex].record)").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Spacer()
                        }
                        .frame(width: 75)
                        HStack(spacing: 0) {
                            Text("average").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Text(":").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Text("\(user.trackables[dataIndex].getAverage())").font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("MainText"))
                            Spacer()
                        }
                        .frame(width: 75)
                    }
                }
                .padding(.horizontal, 30).padding(.top, 20)
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { value in
                        VStack(spacing: 5) {
                            if addingEntry {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 45)
                                    FocusTextField(text: $count, isFirstResponder: true, numbersOnly: true).frame(width: geometry.size.width - 90, height: 30, alignment: .leading).clipped()
                                    .frame(height: 30)
                                }.id(0)
                                .onAppear {
                                    value.scrollTo(0)
                                }
                            }
                            ForEach(user.trackables[dataIndex].entries.indices.reversed(), id: \.self) { index in
                                EntryView(entry: user.trackables[dataIndex].entries[index], isPressed: false, showButton: false)
                                    .opacity(transitionToggle ? 1 : 0).animation(.linear(duration: 0.1).delay(Double(user.trackables[dataIndex].entries.count - index - 1)/10), value: transitionToggle)
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
                            manager.setView(view: AnyView(MainView(user: $user).environmentObject(manager)))
                        }
                    }
                    .buttonStyle(CircleButton(size: 50, fontSize: 16))
                    ZStack {
                        if addingEntry {
                            Button("\u{f00c}") {
                                addingEntry = false
                                let result: Int = user.trackables[dataIndex].addEntry(text: count)
                                if result > 0 {
                                    if result > 1 {
                                        user.data.newPersonalBest = true
                                    }
                                    
                                    user.data.entriesAdded += 1
                                    user.checkChallenge()
                                }
                                
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
                        manager.setView(view: AnyView(CreateEditDataView(user: $user, dataIndex: dataIndex).environmentObject(manager)))
                    }
                    .buttonStyle(CircleButton(size: 50, fontSize: 16))
                }
                .padding(.bottom, addingEntry ? 0 : 20)
            }
            .padding(.vertical, 10)
            .onAppear {
                transitionToggle = true
            }
        }
    }
}

struct DataOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        DataOverviewView(user: Binding.constant(User(trackables: [TrackableData(name: "Pushups", symbol: "0xf186", entries: [5, 2, 7, 8, 6])], data: UserData())), dataIndex: 0)
    }
}

extension String {
    var isNumber: Bool {
        return self.range(of: "^[0-9]*$", options: .regularExpression) != nil
    }
}
