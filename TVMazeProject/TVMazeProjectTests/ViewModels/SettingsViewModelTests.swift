//
//  SettingsViewModelTests.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 07/03/24.
//

import XCTest
@testable import TVMazeProject

final class TVMazeProjectTests: XCTestCase {
    
    @MainActor
    func testLoadInitialSettings() async {
        let mockKeychainService = MockKeychainService()
        mockKeychainService.pin = "1234"
        mockKeychainService.biometricsEnabled = true
        
        let viewModel = SettingsViewModel(keychainService: mockKeychainService, coordinator: MockCoordinator())
        
        XCTAssertEqual(viewModel.pin, "1234", "The pin should be loaded from the keychain.")
        XCTAssertTrue(viewModel.isBiometricsEnabled, "Biometrics setting should be enabled.")
    }
    
    @MainActor
    func testSaveSettings() async {
        let mockKeychainService = MockKeychainService()
        let viewModel = SettingsViewModel(keychainService: mockKeychainService, coordinator: MockCoordinator())
        
        viewModel.pin = "4321"
        viewModel.isBiometricsEnabled = false
        viewModel.saveSettings()
        
        XCTAssertEqual(mockKeychainService.pin, "4321", "The pin should be saved to the keychain.")
        XCTAssertFalse(mockKeychainService.biometricsEnabled, "Biometrics setting should be disabled.")
    }
}
