import InfrastructureDependencyContainer
import Foundation


protocol DependencyStorage {
	typealias ArgumentedClosure = ((Any) throws -> Any)
	typealias Closure = () -> Any
	func store(
		serviceName: String,
		instance: @escaping Closure,
		scope: DependencyScope
	)
	func retrieve(serviceName: String) throws -> Closure
	func store(serviceName: String, instance: @escaping ArgumentedClosure)
	func retrieve(serviceName: String) throws -> ArgumentedClosure
}

final class DependencyStorageImplementation: DependencyStorage {
	private var uniqueStorage: [String: ArgumentedClosure] = [:]
	private var singletonStorage: [String: Any] = [:]
	private let singletonStorageLock = NSRecursiveLock()
	private let uniqueStorageLock = NSRecursiveLock()

    init() {}
    
    func store(
        serviceName: String,
        instance: @escaping Closure,
		scope: DependencyScope
    ) {
		switch scope {
		case .singleton:
			singletonStorageLock.locked {
				singletonStorage[serviceName] = instance()
			}
		case .unique:
			uniqueStorageLock.locked {
				uniqueStorage[serviceName] = { _ in instance() }
			}
		}
    }
    
	func store(
		serviceName: String,
		instance: @escaping ArgumentedClosure
	) {
		uniqueStorageLock.locked {
			uniqueStorage[serviceName] = instance
		}
	}

    func retrieve(serviceName: String) throws -> Closure {
		guard let service = try singletonStorage[serviceName] ?? uniqueStorage[serviceName]?(()) else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}
		
		return {
			service
		}
    }

    func retrieve(serviceName: String) throws -> ArgumentedClosure {
		guard let service = uniqueStorage[serviceName] else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}

        return service
    }
}
