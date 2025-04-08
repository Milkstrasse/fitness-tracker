//
//  ChallengeView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 29.08.23.
//

import SwiftUI

struct ChallengeView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                Image("avatar").resizable().scaleEffect(2.1).offset(x: 10, y: -5)
            }
            .frame(width: 60, height: 60).clipShape(RoundedRectangle(cornerRadius: 15))
            Triangle().fill(Color("Challenge")).frame(width: 10, height: 15).padding(.leading, 5).offset(y: -5)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15).fill(Color("Challenge"))
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        Text("challenge").font(.custom("Museo Sans Rounded", size: 16)).fontWeight(.bold).foregroundColor(Color("MainText"))
                        Text(LocalizedStringKey(user.challenges[user.currChallenge].title)).font(.custom("Museo Sans Rounded", size: 12)).foregroundColor(Color("ChallengeText"))
                    }
                    .padding(.leading, 15)
                    Spacer()
                    Text(user.challenges[user.currChallenge].isCompleted ? "\u{f00c}" : "\u{f110}").font(.custom("Font Awesome 5 Pro", size: 24)).foregroundColor(Color("ChallengeText")).frame(width: 60)
                }
            }
            .frame(height: 60)
        }
        .padding(.all, 30)
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(user: User(trackables: [], data: UserData()))
    }
}
