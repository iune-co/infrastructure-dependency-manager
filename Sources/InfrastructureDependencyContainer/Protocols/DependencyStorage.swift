public protocol DependencyStorage {
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
