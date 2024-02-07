public protocol DependencyContainer: Resolver {
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
