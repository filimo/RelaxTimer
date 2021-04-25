//
//  SettingsView.swift
//  RelaxTimer
//
//  Created by Viktor Kushnerov on 25.04.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var shortTime: Int
    @Binding var longTime: Int
    @Binding var counter: Int

    var body: some View {
        Form {
            Section {
                picker(label: "Short time", value: $shortTime)
                picker(label: "Long time", value: $longTime)
                picker(label: "Counter", value: $counter)
            }
        }
    }

    private func picker<T>(
        label: String,
        value: Binding<T>) -> some View where T: Hashable, T: _FormatSpecifiable
    {
        HStack {
            Text(label)
            Spacer()
            Picker("\(value.wrappedValue)", selection: value) {
                ForEach(1 ... 60, id: \.self) {
                    Text("\($0)").tag(Optional($0))
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_Previews.previews
    }
}
