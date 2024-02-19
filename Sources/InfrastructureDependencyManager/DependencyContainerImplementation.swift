import InfrastructureDependencyContainer

final class DependencyContainerImplementation: DependencyContainer {
	private let storage: DependencyStorage
	
	init(
		storage: DependencyStorage
	) {
		self.storage = storage
	}

	init() {
		self.storage = DependencyStorageImplementation()
	}

    func register<T>(
        service: T.Type,
        withProvider provider: @escaping () -> T,
		scope: DependencyScope
    ) {
        storage.store(
            serviceName: String(describing: T.self),
            instance: provider,
			scope: scope
        )
    }

    func register<T: ArgumentedDependency>(
        service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T
    ) {
		let serviceName = String(describing: T.self)
        storage.store(
            serviceName: serviceName,
			instance: { argument in
				guard let argument = argument as? T.Arguments else {
					throw DependencyContainerError.incorrectArgumentType(serviceName, argumentName: String(describing: T.Arguments.self))
				}
				
				return try provider(argument)
			}
        )
    }
    
    func resolve<T>() throws -> T {
        let serviceName = String(describing: T.self)
		let initializer: DependencyStorage.Closure = try storage.retrieve(serviceName: serviceName)
		
		guard let instance = initializer() as? T  else {
			throw DependencyContainerError.corruptedDependencyInstance(serviceName)
		}
		
		return  instance
    }
	
	func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T {
		let serviceName = String(describing: T.self)
		let initializer: DependencyStorage.ArgumentedClosure = try storage.retrieve(serviceName: serviceName)
		
		guard let instance = try initializer(argument) as? T  else {
			throw DependencyContainerError.corruptedDependencyInstance(serviceName)
		}
		
		return  instance
    }
}
