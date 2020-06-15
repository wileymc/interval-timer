//
//  RestView.swift
//  Interval Timer
//
//  Created by Wiley Conte on 6/8/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import SwiftUI
import Combine

struct RestView: View {
    
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
            Palette.salmon.edgesIgnoringSafeArea(.all)
            
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
                    Text("Rest").font(.system(size: 60))
                    Text("Set \(self.currentInterval) of \(self.intervalsSelectedIndex + 1)").font(.system(size: 40))
                    Spacer()
                    ZStack {
                        ProgressRing(progress: CGFloat(self.progress), color: Palette.green)
                        Text("\(self.timeRemaining)").font(.system(size: 160))
                            .onReceive(self.timer) { _ in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            }
                            if self.timeRemaining > 0 && self.timeRemaining <= 3 {
                                playSound(sound: "race-beep", type: "wav")
                            }
                            if self.timeRemaining == 0 {
                                playSound(sound: "race-start", type: "wav")
                                self.currentInterval += 1
                                self.timeRemaining = self.workSeconds
                                self.initialTime = self.workSeconds
                                self.timerMode = .work
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
                        Text("Rest").font(.system(size: 60))
                        Text("Set \(self.currentInterval) of \(self.intervalsSelectedIndex + 1)").font(.system(size: 40))
                    }
                    Spacer()
                    ZStack {
                        ProgressRing(progress: CGFloat(self.progress), color: Palette.green)
                        Text("\(self.timeRemaining)").font(.system(size: 160))
                            .onReceive(self.timer) { _ in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            }
                            if self.timeRemaining > 0 && self.timeRemaining <= 3 {
                                playSound(sound: "race-beep", type: "wav")
                            }
                            if self.timeRemaining == 0 {
                                playSound(sound: "race-start", type: "wav")
                                self.currentInterval += 1
                                self.timeRemaining = self.workSeconds
                                self.initialTime = self.workSeconds
                                self.timerMode = .work
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
