//
//  ProgressRing.swift
//  Interval Timer
//
//  Created by Wiley Conte on 5/24/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import SwiftUI

struct ProgressRing: View {
    
    var progress: CGFloat = 0.0
    
    var color: Color = Palette.green
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(color)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
    }
}
