@testable import InfrastructureDependencyContainer

final class ServiceRegisterMock: ServiceRegister
{
    private(set) var registerMethodWasCalled: Bool = false
    
    init()
    {
        
    }
    
    func register(on container: DependencyContainer)
    {
        registerMethodWasCalled = true
    }
}
