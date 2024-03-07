// MockKeychainService.swift

//
//  MockKeychainService.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 04/03/24.
//
@testable import TVMazeProject

final class MockKeychainService: KeychainServiceProtocol {
    var pin: String?
    var biometricsEnabled: Bool = false

    func savePin(_ pin: String) {
        self.pin = pin
    }

    func loadPin() -> String? {
        return pin
    }

    func deletePin() {
        pin = nil
    }

    func setBiometricsEnabled(_ enabled: Bool) {
        biometricsEnabled = enabled
    }

    func isBiometricsEnabled() -> Bool {
        return biometricsEnabled
    }
}
