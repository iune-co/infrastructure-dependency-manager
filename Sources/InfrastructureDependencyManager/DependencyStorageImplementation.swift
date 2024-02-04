import InfrastructureDependencyContainer

public final class DependencyStorageImplementation: DependencyStorage {
	private var storage: [String: ArgumentedClosure] = [:]
	private var singletonStorage: [String: Any] = [:]
	
    public init() {}
    
    public func store(
        serviceName: String,
        instance: @escaping Closure,
		lifetime: DependencyLifetime
    ) {
		switch lifetime {
		case .singletone:
			singletonStorage[serviceName] = instance()
		case .transient:
			storage[serviceName] = { _ in instance() }
		}
    }
    
	public func store(
		serviceName: String,
		instance: @escaping ArgumentedClosure
	) {
		storage[serviceName] = instance
	}

    public func retrieve(serviceName: String) throws -> Closure {
		guard let service = try singletonStorage[serviceName] ?? storage[serviceName]?(()) else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}
		
		return {
			service
		}
    }

    public func retrieve(serviceName: String) throws -> ArgumentedClosure {
		guard let service = storage[serviceName] else {
			throw DependencyContainerError.dependencyNotRegistered(serviceName)
		}

        return service
    }
}

public enum DependencyLifetime {
	case singletone
	case transient
}
