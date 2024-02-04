public protocol Registrar {
    func register<T>(
		service: T.Type,
		withProvider: @escaping () -> T,
		lifetime: DependencyLifetime
	)
	func register<T: ArgumentedDependency>(
		service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T
	)
}

extension Registrar {
	public func register<T>(
		service: T.Type,
		withProvider: @escaping () -> T,
		lifetime: DependencyLifetime = .transient
	){
		register(
			service: service,
			withProvider: withProvider,
			lifetime: lifetime
		)
	}
}

