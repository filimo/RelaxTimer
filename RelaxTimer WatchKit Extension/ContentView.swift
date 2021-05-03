//
//  ContentView.swift
//  RelaxTimer WatchKit Extension
//
//  Created by Viktor Kushnerov on 3.05.21.
//
import SwiftUI
import UserNotifications

struct ContentView: View {
    @ObservedObject var timerManager = TimerManager.shared

    var body: some View {
        VStack {
            Button("Start") {
                timerManager.start()
            }
            .foregroundColor(timerManager.isStart ? .gray : .green)
            .padding(5)
            .disabled(timerManager.isStart)
            
            Button("Stop") {
                timerManager.stop()
            }
            .foregroundColor(timerManager.isStart ? .orange : .gray)
            .padding(5)
            .disabled(timerManager.isStart == false)

            Spacer()
            
            NavigationLink(
                destination: SettingsView(),
                label: {
                    Text("Settings")
                }
            )
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
