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

    @State var counter: Int = 0

    @State var timerStatus: TimerStatus = .beforeStart {
        didSet {
            print("timer status", timerStatus, Date())

            if timerStatus == .stop {
                UIApplication.shared.isIdleTimerDisabled = false
                counter = 0
                timerPublisher = nil
                notify(1021)
                return
            }

            if timerStatus == .beforeStart {
                generator.prepare()
                UIApplication.shared.isIdleTimerDisabled = true
            }

            timerPublisher =
                Timer.publish(
                    every: Double(timerStatus.seconds),
                    on: .main,
                    in: .common
                )
                .autoconnect()
                .sink(receiveValue: onReceiveTimerPublisher)
        }
    }

    @State var timerPublisher: Cancellable? = nil

    private let generator = UINotificationFeedbackGenerator()

    var isStart: Bool { timerPublisher != nil }

    var body: some View {
        NavigationView {
            HStack {
                startButton
                stopButton
            }
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
            timerStatus = .stop
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .foregroundColor(isStart ? .orange : .gray)
        .font(.title)
        .padding()
        .disabled(isStart == false)
    }

    private var startButton: some View {
        Button("Start") {
            timerStatus = .beforeStart
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
            switch timerStatus {
            case .stop:
                return
            case .beforeStart:
                notify(1023)
                timerStatus = .shortTime
            case .shortTime:
                notify(1005)
                timerStatus = .longTime
            case .longTime:
                counter += 1
                print("counter:", counter)
                if counter == 5 {
                    timerStatus = .stop
                } else {
                    notify(1005)
                    timerStatus = .shortTime
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
