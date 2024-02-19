public protocol Resolver {
    func resolve<T>() throws -> T
	func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T
}
