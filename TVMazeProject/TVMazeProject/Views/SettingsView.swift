// SettingsView.swift

import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelProtocol>: View {
    @ObservedObject private(set) var viewModel: ViewModel

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

#Preview {
    class PreviewSettingsViewModel: SettingsViewModelProtocol {
        var pin: String = "1234"
        var isBiometricsEnabled: Bool = false
        var canEvaluatePolicy: Bool = false
        
        func saveSettings() {}
    }
    let viewModel = PreviewSettingsViewModel()
    return SettingsView(viewModel:viewModel)
}
