// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section(header: Text("Security")) {
                SecureField("Set PIN", text: $viewModel.pin)
                if viewModel.canEvaluatePolicy {
                    Toggle("Enable Fingerprint/Face ID", isOn: $viewModel.isBiometricsEnabled)
                }
            }

            Button("Save Settings") {
                viewModel.saveSettings()
            }
        }
        .navigationTitle("Settings")
    }
}

// #Preview {
//    SettingsView(viewModel: SettingsViewModel(keychainService: KeychainService()))
// }
