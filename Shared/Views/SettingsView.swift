//
//  SettingsView.swift
//  RelaxTimer
//
//  Created by Viktor Kushnerov on 25.04.21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var store = Store.shared
    
    var body: some View {
        Form {
            Section {
                picker(label: "Short time", value: $store.shortTimer)
                picker(label: "Long time", value: $store.longTimer)
                picker(label: "Counter", value: $store.phaseCounter)
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
        SettingsView()
    }
}
