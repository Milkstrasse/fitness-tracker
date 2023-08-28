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
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 45)
            HStack {
                Text("\(entry)").foregroundColor(Color.white)
                Spacer()
                Text("\u{f00d}").font(.custom("Font Awesome 5 Free", size: 16)).foregroundColor(Color.white).frame(width: 45, height: 45).opacity(isPressed ? 0.7 : 1)
            }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: 2, isPressed: false)
    }
}
