//
//  Store.swift
//  RelaxTimer
//
//  Created by Viktor Kushnerov on 25.04.21.
//

import Foundation

class Store: ObservableObject {
    private init() {}
    static let shared = Store()
    
    @Published(key: "shortTimer") var shortTimer: Int = 7
    @Published(key: "longTimer") var longTimer: Int = 14
    @Published(key: "phaseCounter") var phaseCounter: Int = 5
}
