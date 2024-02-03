public protocol Registrar {
    func register<T>(service: T.Type, withProvider: @escaping () -> T)
	func register<T: ArgumentedDependency>(
		service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T
	)
}
