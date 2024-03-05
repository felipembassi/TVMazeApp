// SettingsViewModel.swift

import Combine
import Foundation
import LocalAuthentication
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var pin: String = ""
    @Published var isBiometricsEnabled: Bool = false
    @Published var canEvaluatePolicy: Bool = false

    private let keychainService: KeychainServiceProtocol
    private weak var coordinator: AppCoordinator?

    init(keychainService: KeychainServiceProtocol, coordinator: AppCoordinator) {
        self.keychainService = keychainService
        self.coordinator = coordinator
        loadInitialSettings()
        checkBiometricSupport()
    }

    func saveSettings() {
        keychainService.savePin(pin)
        keychainService.setBiometricsEnabled(isBiometricsEnabled)
        coordinator?.determineInitialView()
    }

    private func loadInitialSettings() {
        pin = keychainService.loadPin() ?? ""
        isBiometricsEnabled = keychainService.isBiometricsEnabled()
    }

    private func checkBiometricSupport() {
        let context = LAContext()
        var error: NSError?

        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
