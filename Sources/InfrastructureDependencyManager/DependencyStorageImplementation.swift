import InfrastructureDependencyContainer

public final class DependencyStorageImplementation: DependencyStorage {
	private var storage: [String: ArgumentedClosure]
    
    public init(){
        self.storage = [:]
    }
    
    public func store(
        serviceName: String,
        instance: @escaping Closure
    ) {
        storage[serviceName] = { _ in instance() }
    }
    
	public func store(
		serviceName: String,
		instance: @escaping ArgumentedClosure
	) {
		storage[serviceName] = instance
	}

    public func retrieve(serviceName: String) throws -> Closure {
		guard let service = try storage[serviceName]?(()) else {
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
