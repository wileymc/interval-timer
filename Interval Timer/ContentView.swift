//
//  ContentView.swift
//  Interval Timer
//
//  Created by Wiley Conte on 5/22/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import SwiftUI
import AVFoundation
import Combine


struct ContentView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var availableIntervals = Array(1...30)
    var seconds = Array(stride(from: 5, to: 100, by: 5))
    
    @State private var timerMode: TimerMode = .idle
    @State private var intervals = 16
    @State private var initialTime = 10
    @State private var timeRemaining = 10
    @State private var intervalsSelectedIndex = 0
    @State private var warmupTimeSelectedIndex = 0
    @State private var workTimeSelectedIndex = 0
    @State private var restTimeSelectedIndex = 0
    @State private var currentInterval = 1
    @State private var paused: Bool = false
    
    var progress: Double { Double(timeRemaining) / Double(initialTime) }
    
    var warmupSeconds: Int { (warmupTimeSelectedIndex + 1) * 5 }
    var workSeconds: Int { (workTimeSelectedIndex + 1) * 5 }
    var restSeconds: Int { (restTimeSelectedIndex + 1) * 5 }
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            if timerMode == .idle {
                NavigationView {
                    VStack {
                        Form {
                            Section {
                                Picker(selection: $intervalsSelectedIndex, label: Text("Sets")) {
                                    ForEach(0 ..< availableIntervals.count) {
                                        Text("\(self.availableIntervals[$0])")
                                    }
                                }
                            }
                            
                            Section {
                                Picker(selection: $warmupTimeSelectedIndex, label: Text("Warmup Time")) {
                                    ForEach(0 ..< seconds.count) {
                                        Text("\(self.seconds[$0]) seconds")
                                    }
                                }
                            }

                            Section {
                                Picker(selection: $workTimeSelectedIndex, label: Text("Work Time")) {
                                    ForEach(0 ..< seconds.count) {
                                        Text("\(self.seconds[$0]) seconds")
                                    }
                                }
                            }
                            
                            Section {
                                Picker(selection: $restTimeSelectedIndex, label: Text("Rest Time")) {
                                    ForEach(0 ..< seconds.count) {
                                        Text("\(self.seconds[$0]) seconds")
                                    }
                                }
                            }
                            Button(action: {
                                self.initialTime = self.warmupSeconds
                                self.timeRemaining = self.warmupSeconds
                                self.timerMode = .warmup
                            }) {
                                Text("Get Started").frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                    }.navigationBarTitle("Interval Timer")
                    
                }.navigationViewStyle(StackNavigationViewStyle())
                    .onAppear(perform: { self.loadDefaults() })
                    .onDisappear(perform: { self.saveDefaults() })
            }
            
            ZStack {
                if self.timerMode == .warmup {
                    WarmupView(
                        timer: $timer,
                        initialTime: $initialTime,
                        warmupTimeSelectedIndex: $warmupTimeSelectedIndex,
                        workTimeSelectedIndex: $workTimeSelectedIndex,
                        timeRemaining: $timeRemaining,
                        currentInterval: $currentInterval,
                        timerMode: $timerMode,
                        paused: $paused
                    )
                }

                
                if self.timerMode == .work {
                    WorkView(
                        timer: $timer,
                        initialTime: $initialTime,
                        intervalsSelectedIndex: $intervalsSelectedIndex,
                        warmupTimeSelectedIndex: $warmupTimeSelectedIndex,
                        workTimeSelectedIndex: $workTimeSelectedIndex,
                        restTimeSelectedIndex: $restTimeSelectedIndex,
                        timeRemaining: $timeRemaining,
                        currentInterval: $currentInterval,
                        timerMode: $timerMode,
                        paused: $paused
                    )
                }

                if self.timerMode == .rest {
                    RestView(
                        timer: $timer,
                        initialTime: $initialTime, intervalsSelectedIndex: $intervalsSelectedIndex, warmupTimeSelectedIndex: $warmupTimeSelectedIndex, workTimeSelectedIndex: $workTimeSelectedIndex, restTimeSelectedIndex: $restTimeSelectedIndex, timeRemaining: $timeRemaining, currentInterval: $currentInterval, timerMode: $timerMode, paused: $paused)
                }
            }.gesture(TapGesture().onEnded({  self.handlePause()  }))
        }.onAppear(perform: {
            do{
               try AVAudioSession.sharedInstance().setCategory(.ambient)
               try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
               NSLog(error.localizedDescription)
            }
        })
    }
    
    func handlePause() {
        self.paused = !self.paused
        if self.paused {
            self.timer.upstream.connect().cancel()
        } else {
//            self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
    }
    
    func saveDefaults() {
        defaults.set(intervals, forKey: "intervals")
        defaults.set(warmupTimeSelectedIndex, forKey: "warmupTimeSelectedIndex")
        defaults.set(workTimeSelectedIndex, forKey: "workTimeSelectedIndex")
        defaults.set(restTimeSelectedIndex, forKey: "restTimeSelectedIndex")
    }
    
    func loadDefaults() {
        let savedIntervals = defaults.integer(forKey: "intervals")
        let savedWarmupTimeSelectedIndex = defaults.integer(forKey: "warmupTimeSelectedIndex")
        let savedWorkTimeSelectedIndex = defaults.integer(forKey: "workTimeSelectedIndex")
        let savedRestTimeSelectedIndex = defaults.integer(forKey: "restTimeSelectedIndex")
        
        intervals = savedIntervals
        warmupTimeSelectedIndex = savedWarmupTimeSelectedIndex
        workTimeSelectedIndex = savedWorkTimeSelectedIndex
        restTimeSelectedIndex = savedRestTimeSelectedIndex
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
