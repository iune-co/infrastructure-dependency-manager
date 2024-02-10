@testable import InfrastructureDependencyManager
@testable import InfrastructureDependencyContainer

extension DependencyContainerImplementation
{
    static func fixtureWithMocks(
        storage: DependencyStorage = DependencyStorageMock()
    ) -> DependencyContainerImplementation {
        DependencyContainerImplementation(
            storage: storage
        )
    }
}
