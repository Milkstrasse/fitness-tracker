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
            RoundedRectangle(cornerRadius: 15).fill(Color.yellow).frame(height: 60)
            HStack(spacing: 0) {
                Text(createSymbol(string: data.symbol)).font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white).frame(width: 60)
                VStack(alignment: .leading) {
                    Text(data.name.uppercased()).foregroundColor(Color.white)
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text("PB:").foregroundColor(Color.white)
                            Text("\(data.record)").foregroundColor(Color.white)
                        }
                        HStack(spacing: 0) {
                            Text("AVG:").foregroundColor(Color.white)
                            Text("\(data.getAverage())").foregroundColor(Color.white)
                        }
                        .padding(.leading, 75)
                    }
                }
                Spacer()
                Text(createSymbol(string: "0xf054")).font(.custom("Font Awesome 5 Free", size: 24)).foregroundColor(Color.white).frame(width: 60)
            }
        }
    }
}

struct TrackableDataView_Previews: PreviewProvider {
    static var previews: some View {
        TrackableDataView(data: TrackableData(name: "Title", symbol: ""))
    }
}
