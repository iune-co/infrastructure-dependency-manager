@testable import InfrastructureDependencyContainer

final class ServiceRegistrarMock: ServiceRegistrar {
    private(set) var registerMethodWasCalled: Bool = false
    func register(on container: DependencyManager)
    {
        registerMethodWasCalled = true
    }
}
