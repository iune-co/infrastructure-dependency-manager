@testable import InfrastructureDependencyManager
@testable import InfrastructureDependencyContainer

extension DependencyManager
{
    static func fixtureWithMocks(
        storage: DependencyStorage = DependencyStorageMock(),
        serviceRegisters: [ServiceRegister] = [ServiceRegisterMock()]
    ) -> DependencyManager {
        DependencyManager(
            storage: storage,
            serviceRegisters: serviceRegisters
        )
    }
}
