//
//  CircleButton.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 29.08.23.
//

import SwiftUI

struct CircleButton: ButtonStyle {
    let size: CGFloat
    let fontSize: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Font Awesome 5 Pro", size: fontSize))
            .foregroundColor(Color("MainText"))
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.default, value: configuration.isPressed)
            .frame(width: size, height: size)
            .background(Circle().fill(Color("Main")))
    }
}
