@testable import InfrastructureDependencyManager
@testable import InfrastructureDependencyContainer

extension DependencyContainerImplementation
{
    static func fixtureWithMocks(
        storage: DependencyStorage = DependencyStorageMock(),
        serviceRegistrars: [ServiceRegistrar] = [ServiceRegistrarMock()]
    ) -> DependencyContainerImplementation {
        DependencyContainerImplementation(
            storage: storage,
            serviceRegistrars: serviceRegistrars
        )
    }
}
