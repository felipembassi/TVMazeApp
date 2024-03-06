// PinViewModel.swift

import LocalAuthentication

@MainActor
protocol PinViewModelProtocol: ObservableObject {
    var pin: String { get set }
    var errorMessage: String? { get set }
    
    func verifyPin()
    func authenticateWithBiometrics()
}

final class PinViewModel: PinViewModelProtocol {
    @Published var pin: String = ""
    @Published var errorMessage: String?

    private let keychainService: KeychainServiceProtocol
    private weak var coordinator: AppCoordinator?

    init(keychainService: KeychainServiceProtocol, coordinator: AppCoordinator) {
        self.keychainService = keychainService
        self.coordinator = coordinator
    }

    func verifyPin() {
        guard let storedPin = keychainService.loadPin(), !storedPin.isEmpty else {
            errorMessage = "PIN not set. Please configure your PIN in settings."
            return
        }

        if pin == storedPin {
            errorMessage = nil
            coordinator?.determineInitialView()
        } else {
            errorMessage = "Incorrect PIN. Please try again."
        }
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in with your fingerprint"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { [weak self] success, _ in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.coordinator?.determineInitialView()
                    } else {
                        self?.errorMessage = "Incorrect PIN. Please try again."
                    }
                }
            }
        }
    }
}
