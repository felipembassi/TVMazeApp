// DependencyInjectionContainer.swift

import Foundation

class DependencyInjectionContainer {
    private var services: [String: Any] = [:]

    func register<Service: Injectable>(_ type: Service.Type) {
        let key = String(describing: type)
        services[key] = type.init()
    }

    func resolve<Service: Injectable>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let service = services[key] as? Service else {
            fatalError("No registered service for \(key)")
        }
        return service
    }
}
