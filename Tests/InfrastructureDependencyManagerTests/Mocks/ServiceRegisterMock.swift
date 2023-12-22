@testable import InfrastructureDependencyContainer

class ServiceRegisterMock: ServiceRegister
{
    var registerMethodWasCalled: Bool
    var servicesToRegister: [Any]?
    
    init(servicesToRegister: [Any]? = nil)
    {
        self.servicesToRegister = servicesToRegister
        registerMethodWasCalled = false
    }
    
    func register(on container: DependencyContainer)
    {
        registerMethodWasCalled = true
        
        if let servicesToRegister = servicesToRegister
        {
            servicesToRegister.forEach { instance in
                container.register(instance)
            }
        }
    }
}
