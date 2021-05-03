//
//  TimerManager.swift
//  RelaxTimer WatchKit Extension
//
//  Created by Viktor Kushnerov on 3.05.21.
//
import Combine
import WatchKit

class TimerManager: ObservableObject {
    private init() {}
    static let shared = TimerManager()

    var isStart: Bool { timerPublisher != nil }
    
    @Published private var timerPublisher: Cancellable?
    private var session = WKExtendedRuntimeSession()

    private var counter: Int = 0
        
    private var timerStatus: TimerStatus = .beforeStart {
        didSet {
            print("timer status", timerStatus, Date())

            if timerStatus == .stop {
                counter = 0
                timerPublisher = nil
                WKInterfaceDevice.current().play(.stop)
                return
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
    
    func start() {
        startSessionIfNeeded()
        timerStatus = .beforeStart
    }
    
    func stop() {
        timerStatus = .stop
    }

    private func startSessionIfNeeded() {
        session = WKExtendedRuntimeSession()
        session.start()
    }

    private func stopSession() {
        session.invalidate()
    }

    private func onReceiveTimerPublisher(_: Date) {
        if isStart {
            switch timerStatus {
            case .stop:
                return
            case .beforeStart:
                WKInterfaceDevice.current().play(.start)
                timerStatus = .shortTime
            case .shortTime:
                WKInterfaceDevice.current().play(.success)
                timerStatus = .longTime
            case .longTime:
                counter += 1
                print("counter:", counter)
                if counter == 5 {
                    timerStatus = .stop
                } else {
                    WKInterfaceDevice.current().play(.success)
                    timerStatus = .shortTime
                }
            }
        }
    }
}
