import InfrastructureDependencyContainer

public class DependencyManager: DependencyContainer
{
    private let storage: DependencyStorage

    public init(
        storage: DependencyStorage,
        serviceRegisters: [ServiceRegister]
    ) {
        self.storage = storage
        serviceRegisters.forEach {
            $0.register(on: self)
        }
    }
    
    public func register<T>(_ dependency: @escaping @autoclosure () -> T)
    {
        storage.store(
            serviceName: String(describing: T.self),
            instance: dependency
        )
    }
    
    public func resolve<T>() -> T?
    {
        let serviceName = String(describing: T.self)
        let initializer = storage.retrieve(serviceName: serviceName)
        return initializer?() as? T
    }
}
