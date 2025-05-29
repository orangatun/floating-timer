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


struct TimerView: View {
    @State var timerMode: TimerMode = .countdown
    @State var timerState: TimerState = .reset
    var body: some View {
        VStack {
            HStack {
                Text("00")
                Text(":")
                Text("00")
                Text(":")
                Text("00")
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
            timerState = .running
        } else {
            timerState = .reset
        }
    }
    
    func pauseClock() {
        timerState = .paused
    }
    
    func toggleMode() {
        if(timerMode == .countdown) {
            timerMode = .stopwatch
        } else {
            timerMode = .countdown
        }
    }
}


enum TimerMode {
    case countdown
    case stopwatch
}

enum TimerState {
    case running
    case paused
    case reset
}

#Preview {
    TimerView()
}
