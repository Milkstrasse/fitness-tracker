//
//  TrackableDataView.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct TrackableDataView: View {
    let data: TrackableData
    
    func createSymbol(string: String) -> String {
        let icon: UInt16 = UInt16(Float64(string) ?? 0xf128)
        return String(Character(UnicodeScalar(icon)!))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).fill(Color("Main")).frame(height: 60)
            HStack(spacing: 0) {
                Text(createSymbol(string: data.symbol)).font(.custom("Font Awesome 5 Pro", size: 24)).foregroundColor(Color("MainText")).frame(width: 60)
                VStack(alignment: .leading) {
                    Text(data.name.uppercased()).font(.custom("Museo Sans Rounded", size: 16)).fontWeight(.bold).foregroundColor(Color.white)
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("PB:").font(.custom("Museo Sans Rounded", size: 16)).foregroundColor(Color("MainText"))
                            Text("\(data.record)").font(.custom("Museo Sans Rounded", size: 16)).foregroundColor(Color("MainText"))
                        }
                        HStack(spacing: 0) {
                            Text("AVG:").font(.custom("Museo Sans Rounded", size: 16)).foregroundColor(Color.white)
                            Text("\(data.getAverage())").font(.custom("Museo Sans Rounded", size: 16)).foregroundColor(Color("MainText"))
                        }
                        .padding(.leading, 75)
                    }
                }
                Spacer()
                Text(createSymbol(string: "0xf054")).font(.custom("Font Awesome 5 Pro", size: 24)).foregroundColor(Color("MainText")).frame(width: 60)
            }
        }
    }
}

struct TrackableDataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackableDataView(data: TrackableData(name: "Pushups", symbol: "0xf186", entries: [5, 2, 7, 8, 6]))
    }
}
