
//
//  SettingsView.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//
import SwiftUI
struct SettingsView: View {
    @AppStorage("soundEnabled") private var SoundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled  = true
    var body: some View {
        Form {
            Toggle("Sound Effects", isOn: $SoundEnabled)
            Toggle("Haptics", isOn: $hapticsEnabled)
            
        }
        .navigationTitle("Settings")
    }
}
