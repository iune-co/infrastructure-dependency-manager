@testable import InfrastructureDependencyContainer

class DependencyStorageMock: DependencyStorage
{
    var serviceToRetrieve: (() -> Any)?
    var retrieveMethodWasCalled: Bool
    var storeMethodWasCalled: Bool
    
    init(serviceToRetrieve: (() -> Any)? = nil)
    {
        self.serviceToRetrieve = serviceToRetrieve
        retrieveMethodWasCalled = false
        storeMethodWasCalled = false
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
