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
    
    @State var fontSize = CGFloat(24)
    @State var hours: UInt8 = 0
    @State var minutes: UInt8 = 0
    @State var seconds: UInt8 = 0
    
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            if(timerState == .reset) {
                Button(action: toggleMode, label: {
                    if(timerMode == .countup) {
                        Image(systemName: "timer")
                    } else {
                        Image(systemName: "stopwatch")
                    }
                })
            }
            HStack {
                if(timerMode == .countdown && timerState == .reset) {
                    TimePickerView(setTimeUnit: $setHours, limit: 23, fontSize: $fontSize)
                    Text(":")
                    TimePickerView(setTimeUnit: $setMinutes, limit: 60, fontSize: $fontSize)
                    Text(":")
                    TimePickerView(setTimeUnit: $setSeconds, limit: 60, fontSize: $fontSize)
                } else {
                    Text(String(format: "%02d", hours))
                    Text(":")
                    Text(String(format: "%02d", minutes))
                    Text(":")
                    Text(String(format: "%02d", seconds))
                }
            }.font(.system(size: fontSize))
            HStack {
                if(timerState == .running) {
                    Button(action: pauseClock, label: {
                        Image(systemName: "pause.fill")
                    })
                } else {
                    Button(action: toggleState, label: {
                        Image(systemName: "play.fill")
                    })
                }
                if(timerState == .paused || timerState == .running) {
                    Button(action: resetClock, label: {
                        Image(systemName: "stop.fill")
                    })
                }
            }
            Picker("", selection: $fontSize) {
                ForEach(Array<CGFloat>(stride(from: 16, through: 128, by: 8)), id: \.self) { number in
                    Text(String(format:"%.0f", number))
                        .font(.system(size: fontSize))
                        .tag(number)

                }
            }
            .font(.system(size: fontSize))
            .buttonStyle(.plain)
            .labelsHidden()
            .fixedSize(horizontal: true, vertical: false)
            .pickerStyle(.automatic)
        }
        .font(.system(size: fontSize/2))
        .frame(minWidth: 300, minHeight: 200, alignment: .center)
    }
        
    func toggleState() {
        if(timerState == .reset || timerState == .paused) {
            if(timerState == .reset && timerMode == .countdown) {
                hours = setHours
                minutes = setMinutes
                seconds = setSeconds
            }
            cancellable = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
                if(timerMode == .countup) {
                    incrementSeconds()
                } else {
                    decrementSeconds()
                }
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
        cancellable?.cancel()
        cancellable = nil
        timerState = .reset
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
        resetClock()
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
        if(hours == 23) {
            hours = 0
        } else {
            hours += 1
        }
    }
    
    func decrementSeconds() {
        if(seconds == 0) {
            decrementMinutes()
            seconds = 59
        } else {
            seconds -= 1
        }
    }
    
    func decrementMinutes() {
        if(minutes == 0) {
            decrementHours()
            minutes = 59
        } else {
            minutes -= 1
        }
    }
    
    func decrementHours() {
        if(hours == 0) {
            resetClock()
            // Handle a case of Timer end view using a flag
        } else {
            hours -= 1
        }
    }
}


struct TimePickerView: View {
    @Binding var setTimeUnit: UInt8
    let limit: UInt8
    @Binding var fontSize: CGFloat
    var body: some View {
        Picker("", selection: $setTimeUnit) {
            ForEach(Array<UInt8>(0...limit), id: \.self) { number in
                Text(String(format:"%02d", number))
                    .font(.system(size: fontSize))
                    .tag(number)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .font(.system(size: fontSize))
        .buttonStyle(.plain)
        .labelsHidden()
        .fixedSize(horizontal: true, vertical: false)
        .scaledToFit()
        .pickerStyle(.automatic)
        .padding(.horizontal, -3) //To remove the extra padding from Picker View
        .padding(.vertical, -3) //To align it with the default Text View
        .menuIndicator(.hidden)
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
//    TimePickerView(setTimeUnit: .constant(32), limit: 32, fontSize: .constant(24))
}
