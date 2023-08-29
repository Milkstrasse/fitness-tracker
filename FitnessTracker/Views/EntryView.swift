//
//  EntryView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 28.08.23.
//

import SwiftUI

struct EntryView: View {
    let entry: Int
    let isPressed: Bool
    let showButton: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 45)
            HStack {
                Text("\(entry)").font(.custom("Museo Sans Rounded", size: 16)).foregroundColor(Color("MainText"))
                Spacer()
                if showButton {
                    Text("\u{f00d}").font(.custom("Font Awesome 5 Pro", size: 16)).foregroundColor(Color("MainText")).frame(width: 45, height: 45).opacity(isPressed ? 0.7 : 1)
                }
            }
            .padding(.leading, 15)
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: 2, isPressed: false, showButton: true)
    }
}
