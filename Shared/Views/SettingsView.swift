//
//  SettingsView.swift
//  RelaxTimer
//
//  Created by Viktor Kushnerov on 25.04.21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var store = Store.shared

    private var pickerStyle: some PickerStyle {
        #if os(watchOS)
        DefaultPickerStyle()
        #else
        MenuPickerStyle()
        #endif
    }

    var body: some View {
        Form {
            picker(label: "Short time", value: $store.shortTimer)
            picker(label: "Long time", value: $store.longTimer)
            picker(label: "Counter", value: $store.phaseCounter)
        }
        .padding(.vertical)
    }

    private func picker<T>(
        label: String,
        value: Binding<T>
    ) -> some View where T: Hashable, T: _FormatSpecifiable {
        Picker(
            selection: value,
            label: HStack {
                Text(label)
                Spacer()
                #if !os(watchOS)
                Text("\(value.wrappedValue)")
                #endif
            }

        ) {
            ForEach(5 ... 60, id: \.self) {
                Text("\($0)").tag(Optional($0))
            }
        }
        .pickerStyle(pickerStyle)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
