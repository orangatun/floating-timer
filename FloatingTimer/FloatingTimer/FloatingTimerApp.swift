//
//  FloatingTimerApp.swift
//  FloatingTimer
//
//  Created by raghunadham g on 5/29/25.
//

import SwiftUI
import AppKit

@main
struct FloatingOverlayApp: App {
    var body: some Scene {
        WindowGroup {
            TimerView()
        }
    }
}


import Combine

struct TimerView: View {
    @State var timerMode: TimerMode = .countup
    @State var timerState: TimerState = .reset
    
    @State var setHours: UInt8 = 0
    @State var setMinutes: UInt8 = 0
    @State var setSeconds: UInt8 = 0
    
    @State var hours: UInt8 = 0
    @State var minutes: UInt8 = 0
    @State var seconds: UInt8 = 0
    
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            Button(action: toggleMode, label: {
                if(timerMode == .countup) {
                    Image(systemName: "timer")
                } else {
                    Image(systemName: "stopwatch")
                }
            })
            HStack {
                Text(String(format: "%02d", hours))
                Text(":")
                Text(String(format: "%02d", minutes))
                Text(":")
                Text(String(format: "%02d", seconds))
            }
            HStack {
                if(timerState == .running) {
                    Button(action: pauseClock, label: {
                        Image(systemName: "pause.fill")
                    })
                }
                Button(action: toggleState, label: {
                    if(timerState != .running) {
                        Image(systemName: "play.fill")
                    } else {
                        Image(systemName: "stop.fill")
                    }
                })
            }
            HStack {
                Text("Mode: \(timerMode)")
                Text("State: \(timerState)")
            }
        }
            .frame(minWidth: 300, minHeight: 200, alignment: .center)
    }
        
    func toggleState() {
        if(timerState == .reset || timerState == .paused) {
            cancellable = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
                incrementSeconds()
            }
            timerState = .running
        } else {
            cancellable?.cancel()
            cancellable = nil
            timerState = .reset
            resetClock()
        }
    }
    
    func resetClock() {
        if(timerMode == .countdown) {
            hours = setHours
            minutes = setMinutes
            seconds = setSeconds
        } else {
            hours = 0
            minutes = 0
            seconds = 0
        }
    }
    
    func pauseClock() {
        cancellable?.cancel()
        cancellable = nil
        timerState = .paused
    }
    
    func toggleMode() {
        if(timerMode == .countdown) {
            timerMode = .countup
        } else {
            timerMode = .countdown
        }
    }
    
    func incrementSeconds() {
        if(seconds == 59) {
            incrementMinutes()
            seconds = 0
        } else {
            seconds += 1
        }
    }
    
    func incrementMinutes() {
        if(minutes == 59) {
            incrementHours()
            minutes = 0
        } else {
            minutes += 1
        }
    }
    
    func incrementHours() {
        if(hours == 255) {
            hours = 0
        } else {
            hours += 1
        }
    }
}


enum TimerMode {
    case countdown
    case countup
}

enum TimerState {
    case running
    case paused
    case reset
}

#Preview {
    TimerView()
}
