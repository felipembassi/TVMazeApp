// PinViewModel.swift

import LocalAuthentication

@MainActor
protocol PinViewModelProtocol: ObservableObject {
    var pin: String { get set }
    var errorMessage: String? { get set }
    var canUseBiometrics: Bool { get }
    var isLoading: Bool { get set }

    func verifyPin()
    func authenticateWithBiometrics()
}

final class PinViewModel<Coordinator: CoordinatorProtocol>: PinViewModelProtocol {
    @Published var pin: String = ""
    @Published var errorMessage: String?
    @Published var canUseBiometrics: Bool = false
    @Published var isLoading: Bool = false

    private let keychainService: KeychainServiceProtocol
    private weak var coordinator: Coordinator?

    init(keychainService: KeychainServiceProtocol, coordinator: Coordinator) {
        self.keychainService = keychainService
        self.coordinator = coordinator
        checkBiometricSupport()
    }

    func verifyPin() {
        guard let storedPin = keychainService.loadPin(), !storedPin.isEmpty else {
            errorMessage = "PIN not set. Please configure your PIN in settings."
            return
        }

        if pin == storedPin {
            errorMessage = nil
            coordinator?.setRootPageHome()
        } else {
            errorMessage = "Incorrect PIN. Please try again."
        }
    }

    func authenticateWithBiometrics() {
        isLoading = true
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { [weak self] success, _ in
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    if success {
                        self?.coordinator?.setRootPageHome()
                    } else {
                        self?.errorMessage = "Incorrect PIN. Please try again."
                    }
                }
            }
        }
    }

    private func checkBiometricSupport() {
        let context = LAContext()
        var error: NSError?

        canUseBiometrics = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
