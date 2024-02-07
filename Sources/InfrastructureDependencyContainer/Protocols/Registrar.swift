public protocol DependencyManager: Resolver {
    func register<T>(
		service: T.Type,
		withProvider: @escaping () -> T,
		scope: DependencyScope,
		context: DependencyContext
	)
	func register<T: ArgumentedDependency>(
		service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T,
		context: DependencyContext
	)
}

extension DependencyManager {
	public func register<T>(
		service: T.Type,
		withProvider: @escaping () -> T,
		scope: DependencyScope = .unique,
		context: DependencyContext = .local
	){
		register(
			service: service,
			withProvider: withProvider,
			scope: scope,
			context: context
		)
	}
	
	public func register<T: ArgumentedDependency>(
		service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T,
		context: DependencyContext = .local
	) {
		register(
			service: service,
			withProvider: provider,
			context: context
		)
	}
}

