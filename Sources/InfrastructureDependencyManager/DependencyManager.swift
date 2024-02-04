import InfrastructureDependencyContainer

public class DependencyManager: DependencyContainer
{
    private let storage: DependencyStorage

    public init(
        storage: DependencyStorage,
		serviceRegistrars: [ServiceRegistrar]
    ) {
        self.storage = storage
		serviceRegistrars.forEach {
            $0.register(on: self)
        }
    }
    
    public func register<T>(
        service: T.Type,
        withProvider provider: @escaping () -> T,
		lifetime: DependencyLifetime
    ) {
        storage.store(
            serviceName: String(describing: T.self),
            instance: provider,
			lifetime: lifetime
        )
    }

    public func register<T: ArgumentedDependency>(
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
    
    public func resolve<T>() throws -> T {
        let serviceName = String(describing: T.self)
		let initializer: DependencyStorage.Closure = try storage.retrieve(serviceName: serviceName)
		
		guard let instance = initializer() as? T  else {
			throw DependencyContainerError.corruptedDependencyInstance(serviceName)
		}
		
		return  instance
    }
	
	public func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T {
		let serviceName = String(describing: T.self)
		let initializer: DependencyStorage.ArgumentedClosure = try storage.retrieve(serviceName: serviceName)
		
		guard let instance = try initializer(argument) as? T  else {
			throw DependencyContainerError.corruptedDependencyInstance(serviceName)
		}
		
		return  instance
    }
}
