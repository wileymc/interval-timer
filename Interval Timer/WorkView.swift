//
//  WorkView.swift
//  Interval Timer
//
//  Created by Wiley Conte on 6/8/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import SwiftUI
import Combine

struct WorkView: View {
    
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var initialTime: Int
    @Binding var intervalsSelectedIndex: Int
    @Binding var warmupTimeSelectedIndex: Int
    @Binding var workTimeSelectedIndex: Int
    @Binding var restTimeSelectedIndex: Int
    @Binding var timeRemaining: Int
    @Binding var currentInterval: Int
    @Binding var timerMode: TimerMode
    @Binding var paused: Bool
    
    var warmupSeconds: Int { (warmupTimeSelectedIndex + 1) * 5 }
    var workSeconds: Int { (workTimeSelectedIndex + 1) * 5 }
    var restSeconds: Int { (restTimeSelectedIndex + 1) * 5 }
    var progress: Double { Double(timeRemaining) / Double(initialTime) }
    
    var body: some View {
        return GeometryReader { proxy in
            Palette.green.edgesIgnoringSafeArea(.all)
            if proxy.size.width < proxy.size.height {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.initialTime = self.warmupSeconds
                            self.timeRemaining = self.warmupSeconds
                            self.currentInterval = 1
                            self.timerMode = .idle
                        }) {
                            Text("Exit").padding().font(.system(size: 15))
                        }.foregroundColor(Palette.gray)
                    }
                    Text("Work").font(.system(size: 60))
                    Text("Set \(self.currentInterval) of \(self.intervalsSelectedIndex + 1)").font(.system(size: 40))
                    Spacer()
                    ZStack {
                        ProgressRing(progress: CGFloat(self.progress), color: Palette.salmon)
                        Text("\(self.timeRemaining)").font(.system(size: 160))
                            .onReceive(self.timer) { _ in
                             if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                                if self.timeRemaining <= 3 {
                                    playSound(sound: "race-beep", type: "wav")
                                }
                            }
                            
                            if self.timeRemaining == 0 {
                                if self.currentInterval == self.intervalsSelectedIndex + 1 {
                                    playSound(sound: "game-win", type: "mp3")
                                    self.currentInterval = 1
                                    self.initialTime = 10
                                    self.timeRemaining = 10
                                    self.timerMode = .idle
                                } else {
                                    playSound(sound: "race-start", type: "wav")
                                    self.timeRemaining = self.restSeconds
                                    self.initialTime = self.restSeconds
                                    self.timerMode = .rest
                                }
                            }
                        }
                    }.frame(width: 270, height: 270)
                }
            } else {
                HStack {
                    VStack {
                      Spacer()
                      Button(action: {
                           self.initialTime = self.warmupSeconds
                           self.timeRemaining = self.warmupSeconds
                           self.currentInterval = 1
                           self.timerMode = .idle
                       }) {
                           Text("Exit").padding().font(.system(size: 15))
                       }.foregroundColor(Palette.salmon)
                    }
                    VStack {
                      Text("Work").font(.system(size: 60))
                        Text("Set \(self.currentInterval) of \(self.intervalsSelectedIndex + 1)").font(.system(size: 40))
                    }
                    Spacer()
                    ZStack {
                        ProgressRing(progress: CGFloat(self.progress), color: Palette.salmon)
                        Text("\(self.timeRemaining)").font(.system(size: 160))
                            .onReceive(self.timer) { _ in
                             if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            }
                            if self.timeRemaining > 0 && self.timeRemaining <= 3 {
                                playSound(sound: "race-beep", type: "wav")
                            }
                            if self.timeRemaining == 0 {
                                if self.currentInterval == self.intervalsSelectedIndex + 1 {
                                    playSound(sound: "game-win", type: "mp3")
                                    self.currentInterval = 1
                                    self.initialTime = 10
                                    self.timeRemaining = 10
                                    self.timerMode = .idle
                                } else {
                                    playSound(sound: "race-start", type: "wav")
                                    self.timeRemaining = self.restSeconds
                                    self.initialTime = self.restSeconds
                                    self.timerMode = .rest
                                }
                            }
                        }
                    }.frame(width: 270, height: 270)
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        self.paused
                            ? Image(systemName: "play")
                                .font(.system(size: 56.0, weight: .bold))
                            : Image(systemName: "pause")
                                .font(.system(size: 56.0, weight: .bold))
                    }
                    Spacer()
                }
            }
        }
    }
}
