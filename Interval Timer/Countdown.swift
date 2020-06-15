//
//  Countdown.swift
//  Interval Timer
//
//  Created by Wiley Conte on 5/23/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onReceive(timer) { time in
            print("/(time)")
        }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        Countdown()
    }
}
