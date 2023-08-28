//
//  LineGraph.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import SwiftUI

struct LineGraph: Shape {
    let data: TrackableData
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let minimum: Int = data.getMinimum()
        let maximum: Int = data.getMaximum()
        
        if data.entries.count < 2 || minimum == maximum {
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        } else {
            let unitHeight: CGFloat = rect.height/CGFloat(maximum - minimum)
            let unitWidth: CGFloat = rect.width/CGFloat(data.entries.count - 1)
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - unitHeight * CGFloat(data.entries[0] - minimum)))
            
            for index in 1 ..< data.entries.count {
                path.addLine(to: CGPoint(x: rect.minX + CGFloat(index) * unitWidth, y: rect.maxY - unitHeight * CGFloat(data.entries[index] - minimum)))
            }
        }
        
        return path
    }
}
