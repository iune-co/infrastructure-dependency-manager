import InfrastructureDependencyContainer

public final class DependencyStorageImplementation: DependencyStorage {
	private var transientStorage: [String: ArgumentedClosure] = [:]
	private var singletonStorage: [String: Any] = [:]
	
    public init() {}
    
    public func store(
        serviceName: String,
        instance: @escaping Closure,
		lifetime: DependencyLifetime
    ) {
		switch lifetime {
		case .singleton:
			singletonStorage[serviceName] = instance()
		case .transient:
			transientStorage[serviceName] = { _ in instance() }
		}
    }
    
	public func store(
		serviceName: String,
		instance: @escaping ArgumentedClosure
	) {
		transientStorage[serviceName] = instance
	}

    public func retrieve(serviceName: String) throws -> Closure {
		guard let service = try singletonStorage[serviceName] ?? transientStorage[serviceName]?(()) else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}
		
		return {
			service
		}
    }

    public func retrieve(serviceName: String) throws -> ArgumentedClosure {
		guard let service = transientStorage[serviceName] else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}

        return service
    }
}
