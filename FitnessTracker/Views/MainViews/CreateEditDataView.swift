//
//  CreateEditDataView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct CreateEditDataView: View {
    @EnvironmentObject var manager: ViewManager
    
    @Binding var user: User
    @State var dataIndex: Int
    
    @State var name: String = ""
    @State var selectIndex: Int = 0
    
    let symbols: [String] = ["0xf005", "0xf004", "0xf186", "0xf043", "0xf5bb", "0xf06d", "0xf06c", "0xf6fc", "0xf54c", "0xf135", "0xf094", "0xf7ec", "0xf02e", "0xf024"]
    
    @State var buttonPressed: Int = -1
    
    @State var transitionToggle: Bool = false
    
    func createSymbol(string: String) -> String {
        let icon: UInt16 = UInt16(Float64(string) ?? 0xf128)
        return String(Character(UnicodeScalar(icon)!))
    }
    
    func getSelectIndex(symbol: String) -> Int {
        for index in symbols.indices {
            if symbol == symbols[index] {
                return index
            }
        }
        
        return 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 55)
                    FocusTextField(text: $name, isFirstResponder: true, numbersOnly: false)
                        .frame(width: geometry.size.width - 90, height: 30, alignment: .leading).clipped()
                }
                .padding(.top, 20).padding(.horizontal, 30)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(symbols.indices, id: \.self) { index in
                            Button(action: {
                                selectIndex = index
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15).fill(selectIndex == index ? Color("MainText") : Color("Main"))
                                    Text(createSymbol(string: symbols[index])).font(.custom("Font Awesome 5 Pro", size: 16)).foregroundColor(selectIndex == index ? Color("Main") : Color("MainText"))
                                }
                                .frame(width: 45, height: 45)
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                if dataIndex != -1 {
                    ScrollView(.vertical, showsIndicators: false) {
                        if !user.trackables[dataIndex].entries.isEmpty {
                            VStack(spacing: 5) {
                                ForEach(user.trackables[dataIndex].entries.indices.reversed(), id: \.self) { index in
                                    ZStack(alignment: .trailing) {
                                        EntryView(entry: user.trackables[dataIndex].entries[index], isPressed: buttonPressed == index, showButton: true)
                                        Button(action: {
                                            user.trackables[dataIndex].removeEntry(index: index)
                                        }) {
                                            Color.clear.frame(width: 45, height: 45)
                                        }
                                        .simultaneousGesture(DragGesture(minimumDistance: 0)
                                            .onChanged({ _ in
                                                buttonPressed = index
                                            })
                                            .onEnded({ _ in
                                                buttonPressed = -1
                                            })
                                        )
                                    }
                                    .opacity(transitionToggle ? 1 : 0).animation(.linear(duration: 0.1).delay(Double(user.trackables[dataIndex].entries.count - index - 1)/10), value: transitionToggle)
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                } else {
                    Spacer()
                }
                HStack(spacing: 10) {
                    Button("\u{f00d}") {
                        if dataIndex == -1 {
                            manager.setView(view: AnyView(MainView(user: $user).environmentObject(manager)))
                        } else {
                            manager.setView(view: AnyView(DataOverviewView(user: $user, dataIndex: dataIndex).environmentObject(manager)))
                        }
                    }
                    .buttonStyle(CircleButton(size: 50, fontSize: 16))
                    Button("\u{f00c}") {
                        if dataIndex == -1 {
                            user.addTrackable(name: name, symbol: symbols[selectIndex])
                            user.data.newCategoryAdded = true
                            user.checkChallenge()
                            
                            manager.setView(view: AnyView(DataOverviewView(user: $user, dataIndex: user.trackables.count - 1).environmentObject(manager)))
                        } else {
                            user.editTrackable(name: name, symbol: symbols[selectIndex], dataIndex: dataIndex)
                            manager.setView(view: AnyView(DataOverviewView(user: $user, dataIndex: dataIndex).environmentObject(manager)))
                        }
                        
                        SaveManager.saveUser(user: user)
                    }
                    .buttonStyle(CircleButton(size: 75, fontSize: 24))
                    Button("\u{f2ed}") {
                        user.removeTrackable(index: dataIndex)
                        dataIndex = -1
                        
                        manager.setView(view: AnyView(MainView(user: $user).environmentObject(manager)))
                        
                        SaveManager.saveUser(user: user)
                    }
                    .buttonStyle(CircleButton(size: 50, fontSize: 16))
                    .disabled(dataIndex == -1).opacity(dataIndex == -1 ? 0.7 : 1)
                }
            }
            .padding(.vertical, 10)
            .onAppear {
                if dataIndex != -1 {
                    name = user.trackables[dataIndex].name
                    selectIndex = getSelectIndex(symbol: user.trackables[dataIndex].symbol)
                }
                
                transitionToggle = true
            }
        }
    }
}

struct CreateEditDataView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEditDataView(user: Binding.constant(User(trackables: [], data: UserData())), dataIndex: -1)
    }
}
