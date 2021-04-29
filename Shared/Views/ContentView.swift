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
    @ObservedObject var store = Store.shared

    @State var timeCounter: Int = 0
    @State var shortTimer: Int = 0
    @State var longTimer: Int = 0
    @State var isLongTime = false

    @State var timerPublisher = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    @State var isStart = false {
        didSet {
            if isStart {
                timeCounter = -4
                shortTimer = 0
                longTimer = 0
                isLongTime = false

                UIApplication.shared.isIdleTimerDisabled = true
                timerPublisher = timerPublisher.upstream.autoconnect()
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
        NavigationView {
            HStack {
                startButton
                stopButton
            }
            .onReceive(timerPublisher, perform: onReceiveTimerPublisher)
            .toolbar(content: {
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Image(systemName: "gear")
                    }
                )
            })
        }
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
            timeCounter += 1

            if longTimer == store.phaseCounter {
                print("stop")
                isStart = false
                notify(1021)
            } else if timeCounter == 1, shortTimer == 0 {
                print("start")
                notify(1023)
            } else if timeCounter.isMultiple(of: store.shortTimer), isLongTime == false {
                isLongTime = true
                shortTimer += 1
                timeCounter = 0
                notify(1005)
                print("shortTimer \(shortTimer)")
            } else if timeCounter.isMultiple(of: store.longTimer), isLongTime {
                isLongTime = false
                longTimer += 1
                timeCounter = 0
                notify(1005)
                print("longTimer \(longTimer)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
