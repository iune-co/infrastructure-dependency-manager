import InfrastructureDependencyContainer

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
	
    init() {}
    
    func store(
        serviceName: String,
        instance: @escaping Closure,
		scope: DependencyScope
    ) {
		switch scope {
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
