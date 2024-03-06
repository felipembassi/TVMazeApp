// KeychainService.swift

import Foundation
import LocalAuthentication
import Security

protocol HasAPIKeychainService {
    var keychainService: KeychainServiceProtocol { get }
}

protocol KeychainServiceProtocol {
    func savePin(_ pin: String)
    func loadPin() -> String?
    func deletePin()
    func setBiometricsEnabled(_ enabled: Bool)
    func isBiometricsEnabled() -> Bool
}

final class KeychainService: KeychainServiceProtocol {
    private let serviceName = "com.tvmazeapp.keychain"
    private let account = "userPIN"
    private let accessGroup: String? = nil

    required init() {}

    func savePin(_ pin: String) {
        let pinData = pin.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: pinData
        ]

        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: pinData] as CFDictionary)

        if status == errSecItemNotFound {
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    func loadPin() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data, let pin = String(data: data, encoding: .utf8) else {
            return nil
        }

        return pin
    }

    func deletePin() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }

    func setBiometricsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "biometricsEnabled")
    }

    func isBiometricsEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: "biometricsEnabled")
    }
}
