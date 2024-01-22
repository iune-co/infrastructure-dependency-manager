@testable import InfrastructureDependencyContainer

final class DependencyStorageMock: DependencyStorage
{
    var serviceToRetrieve: (() -> Any)?
    private(set) var retrieveMethodWasCalled: Bool = false
    private(set) var storeMethodWasCalled: Bool = false
    
    init(serviceToRetrieve: (() -> Any)? = nil)
    {
        self.serviceToRetrieve = serviceToRetrieve
    }
    
    func store(
        serviceName: String,
        instance: @escaping () -> Any
    ) {
        storeMethodWasCalled = true
    }
    
    func retrieve(serviceName: String) -> (() -> Any)?
    {
        retrieveMethodWasCalled = true
        return serviceToRetrieve
    }
}
