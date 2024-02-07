import InfrastructureDependencyContainer

final class DependencyStorageImplementation: DependencyStorage {
	private var uniqueStorage: [String: ArgumentedClosure] = [:]
	private var singletonStorage: [String: Any] = [:]
	
    init() {}
    
    func store(
        serviceName: String,
        instance: @escaping Closure,
		lifetime: DependencyScope
    ) {
		switch lifetime {
		case .singleton:
			singletonStorage[serviceName] = instance()
		case .unique:
			uniqueStorage[serviceName] = { _ in instance() }
		}
    }
    
	func store(
		serviceName: String,
		instance: @escaping ArgumentedClosure
	) {
		uniqueStorage[serviceName] = instance
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
