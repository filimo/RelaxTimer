//
//  ContentView.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import AudioToolbox
import Combine
import SwiftUI

struct ContentView: View {
    @State var downCounter = 0
    @State var duration: Double = 7

    @State var timerPublisher = Timer.publish(
        every: 7,
        on: .main,
        in: .common
    ).autoconnect()

    @State var isStart = false {
        didSet {
            if isStart {
                UIApplication.shared.isIdleTimerDisabled = true
                timerPublisher = Timer.publish(
                    every: duration,
                    on: .main,
                    in: .common
                ).autoconnect()
            } else {
                UIApplication.shared.isIdleTimerDisabled = false
                timerPublisher.upstream.connect().cancel()
            }
        }
    }

    private let generator = UINotificationFeedbackGenerator()

    init() {
        timerPublisher.upstream.connect().cancel()
        generator.prepare()
    }

    var body: some View {
        HStack {
            startButton
            stopButton
        }
        .onReceive(timerPublisher, perform: onReceiveTimerPublisher)
    }

    private var stopButton: some View {
        Button("Stop") {
            isStart = false
        }
        .foregroundColor(isStart ? .orange : .gray)
        .font(.title)
        .padding()
        .disabled(isStart == false)
    }

    private var startButton: some View {
        Button("Start") {
            downCounter = 0
            isStart = true
        }
        .foregroundColor(isStart ? .gray : .green)
        .font(.title)
        .padding()
        .disabled(isStart)
    }

    private func notify(_ inSystemSoundID: UInt32) {
        generator.notificationOccurred(.success)

        // https://iphonedev.wiki/index.php/AudioServices
        AudioServicesPlaySystemSound(inSystemSoundID)
    }
    
    func onReceiveTimerPublisher(_: Date) {
        if isStart {
            if downCounter == 0 {
                notify(1023)
            } else if [1, 3, 4, 6, 7, 9, 10, 12, 13].contains(downCounter) {
                notify(1005)
            } else {
                if downCounter == 15 {
                    isStart = false
                    notify(1021)
                }
            }

            downCounter += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
