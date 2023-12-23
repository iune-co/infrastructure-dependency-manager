@testable import InfrastructureDependencyContainer

class DependencyStorageStub: DependencyStorage
{
    var serviceToRetrieve: (() -> Any)?
    
    init(serviceToRetrieve: (() -> Any)? = nil)
    {
        self.serviceToRetrieve = serviceToRetrieve
    }
    
    func store(
        serviceName: String,
        instance: @escaping () -> Any
    ) {
        // do nothing
    }
    
    func retrieve(serviceName: String) -> (() -> Any)?
    {
        serviceToRetrieve
    }
}
