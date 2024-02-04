@testable import InfrastructureDependencyManager
@testable import InfrastructureDependencyContainer

extension DependencyManager
{
    static func fixtureWithMocks(
        storage: DependencyStorage = DependencyStorageMock(),
        serviceRegistrars: [ServiceRegistrar] = [ServiceRegistrarMock()]
    ) -> DependencyManager {
        DependencyManager(
            storage: storage,
            serviceRegistrars: serviceRegistrars
        )
    }
}
