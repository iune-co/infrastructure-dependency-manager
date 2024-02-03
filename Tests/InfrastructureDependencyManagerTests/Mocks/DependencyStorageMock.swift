@testable import InfrastructureDependencyContainer

final class DependencyStorageMock: DependencyStorage
{
	private(set) var didCallStore: Bool = false
    func store(
        serviceName: String,
        instance: @escaping () -> Any
    ) {
		didCallStore = true
    }
    
	var stubRetrieveReturn: Closure?
	private(set) var didCallRetrieve: Bool = false
    func retrieve(serviceName: String) -> Closure
    {
        didCallRetrieve = true
		return stubRetrieveReturn ?? {()}
    }
	
	func store(serviceName: String, instance: @escaping ArgumentedClosure) {
		
	}
	
	var stubAttributedRetrieveReturn: ArgumentedClosure?
	private(set) var didCallAttributedRetrieve: Bool = false
	func retrieve(serviceName: String) throws -> ArgumentedClosure {
		didCallAttributedRetrieve = true
		return stubAttributedRetrieveReturn ?? { _ in () }
	}
}
