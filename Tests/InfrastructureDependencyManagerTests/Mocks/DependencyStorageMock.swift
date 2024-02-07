@testable import InfrastructureDependencyContainer

final class DependencyStorageMock: DependencyStorage
{
	private(set) var didCallStore: Bool = false
	private(set) var storeInstanceClosure: Closure?
    func store(
        serviceName: String,
        instance: @escaping Closure,
		lifetime: DependencyScope
    ) {
		didCallStore = true
		storeInstanceClosure = instance
    }
    
	var stubRetrieveReturn: Closure?
	private(set) var didCallRetrieve: Bool = false
    func retrieve(serviceName: String) -> Closure
    {
        didCallRetrieve = true
		return stubRetrieveReturn ?? {()}
    }
	
	private(set) var didCallArgumentedStore = false
	private(set) var storeInstanceArgumentedClosure: ArgumentedClosure?
	func store(serviceName: String, instance: @escaping ArgumentedClosure) {
		didCallArgumentedStore = true
		storeInstanceArgumentedClosure = instance
	}
	
	var stubArgumentedRetrieveReturn: ArgumentedClosure?
	var stubArgumentedError: Error?
	private(set) var didCallAttributedRetrieve: Bool = false
	func retrieve(serviceName: String) throws -> ArgumentedClosure {
		didCallAttributedRetrieve = true
		guard stubArgumentedError == nil else {
			throw stubArgumentedError!
		}

		return stubArgumentedRetrieveReturn ?? { _ in () }
	}
}
