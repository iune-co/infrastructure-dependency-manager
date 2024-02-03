@testable import InfrastructureDependencyContainer

class DependencyStorageStub: DependencyStorage
{
	func store(serviceName: String, instance: @escaping Closure) {}
	func store(serviceName: String, instance: @escaping ArgumentedClosure) {}

	var stubRetrieveReturn: Closure?
	func retrieve(serviceName: String) throws -> Closure {
		stubRetrieveReturn ?? {()}
	}
	
	var stubArgumentedRetrieveReturn: ArgumentedClosure?
	func retrieve(serviceName: String) throws -> ArgumentedClosure {
		stubArgumentedRetrieveReturn ?? { _ in () }
	}
}
