//
//  CreateEditDataView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct CreateEditDataView: View {
    @EnvironmentObject var manager: ViewManager
    
    @State var user: User
    let dataIndex: Int
    
    @State var name: String = ""
    @State var selectIndex: Int = 0
    
    let symbols: [String] = ["0xf005", "0xf004", "0xf186", "0xf185", "0xf06d", "0xf043", "0xf56b", "0xf06c"]
    
    @State var buttonPressed: Int = -1
    
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
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 55)
                FocusUIKitTextField(text: $name, isFirstResponder: true, numbersOnly: false)
                .frame(height: 30)
            }
            .padding(.bottom, 10).padding(.horizontal, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(symbols.indices, id: \.self) { index in
                        Button(action: {
                            selectIndex = index
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(selectIndex == index ? Color.pink : Color.yellow)
                                Text(createSymbol(string: symbols[index])).font(.custom("Font Awesome 5 Free", size: 16)).foregroundColor(Color.white)
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
                                    EntryView(entry: user.trackables[dataIndex].entries[index], isPressed: buttonPressed == index)
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
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
            Spacer()
            Button(action: {
                if dataIndex == -1 {
                    user.addTrackable(name: name, symbol: symbols[selectIndex])
                    manager.setView(view: AnyView(DataOverviewView(user: user, dataIndex: user.trackables.count - 1).environmentObject(manager)))
                } else {
                    user.editTrackable(name: name, symbol: symbols[selectIndex], dataIndex: dataIndex)
                    manager.setView(view: AnyView(DataOverviewView(user: user, dataIndex: dataIndex).environmentObject(manager)))
                }
                
                SaveManager.saveUser(user: user)
            }) {
                ZStack {
                    Circle().fill(Color.black)
                    Text("\u{f00c}").font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white)
                }
                .frame(width: 75, height: 75)
            }
        }
        .onAppear {
            if dataIndex != -1 {
                name = user.trackables[dataIndex].name
                selectIndex = getSelectIndex(symbol: user.trackables[dataIndex].symbol)
            }
        }
    }
}

struct CreateEditDataView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEditDataView(user: User(trackables: []), dataIndex: -1)
    }
}
