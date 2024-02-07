public protocol Registrar {
    func register<T>(
		service: T.Type,
		withProvider: @escaping () -> T,
		scope: DependencyScope
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
		scope: DependencyScope = .unique
	){
		register(
			service: service,
			withProvider: withProvider,
			scope: scope
		)
	}
}

