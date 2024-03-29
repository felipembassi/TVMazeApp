// SettingsViewModel.swift

import Combine
import Foundation
import LocalAuthentication
import SwiftUI

@MainActor
protocol SettingsViewModelProtocol: ObservableObject {
    var pin: String { get set }
    var isBiometricsEnabled: Bool { get set }
    var canEvaluatePolicy: Bool { get set }

    func saveSettings()
}

final class SettingsViewModel<Coordinator: CoordinatorProtocol>: SettingsViewModelProtocol {
    @Published var pin: String = ""
    @Published var isBiometricsEnabled: Bool = false
    @Published var canEvaluatePolicy: Bool = false

    private let keychainService: KeychainServiceProtocol
    private weak var coordinator: Coordinator?

    init(keychainService: KeychainServiceProtocol, coordinator: Coordinator) {
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
