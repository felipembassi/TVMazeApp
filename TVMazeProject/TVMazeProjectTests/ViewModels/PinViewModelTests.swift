// PinViewModelTests.swift

import XCTest
@testable import TVMazeProject

class PinViewModelTests: XCTestCase {
    var viewModel: PinViewModel!
    var mockKeychainService: MockKeychainService!

    override func setUp() {
        super.setUp()
        mockKeychainService = MockKeychainService()
        viewModel = PinViewModel(keychainService: mockKeychainService)
    }

    override func tearDown() {
        viewModel = nil
        mockKeychainService = nil
        super.tearDown()
    }

    func testSaveAndLoadPin() {
        let pin = "1234"
        viewModel.keychainService.savePin(pin)
        XCTAssertEqual(mockKeychainService.loadPin(), pin, "The loaded PIN should match the saved PIN.")
    }

    func testBiometricEnabled() {
        viewModel.keychainService.setBiometricsEnabled(true)
        XCTAssertTrue(mockKeychainService.isBiometricsEnabled(), "Biometrics should be enabled.")
    }
}
