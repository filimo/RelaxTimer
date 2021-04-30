//
//  TimerStatus.swift
//  RelaxTimer (iOS)
//
//  Created by Viktor Kushnerov on 30.04.21.
//

enum TimerStatus {
    case beforeStart
    case shortTime
    case longTime
    case stop

    var seconds: Int {
        switch self {
        case .beforeStart:
            return Store.shared.beforeStart
        case .shortTime:
            return Store.shared.shortTimer
        case .longTime:
            return Store.shared.longTimer
        case .stop:
            return 0
        }
    }
}
