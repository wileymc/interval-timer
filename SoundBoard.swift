//
//  Sounds.swift
//  Interval Timer
//
//  Created by Wiley Conte on 5/23/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import AVFoundation
import SwiftUI

var audioPlayer: AVAudioPlayer?

let longBeepFile = Bundle.main.path(forResource: "longBeep", ofType: "wav")

func playSound(sound: String, type: String) {
    
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not locate and play this sound")
        }
    }
}

