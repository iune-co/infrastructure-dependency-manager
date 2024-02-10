@testable import InfrastructureDependencyManager
@testable import InfrastructureDependencyContainer

extension DependencyInjectionManager
{
	static func fixtureWithMocks(
		globalContainer: DependencyContainer? = nil,
		serviceRegistrars: [ServiceRegistrar] = [ServiceRegistrarMock()]
	) -> DependencyInjectionManager {
		DependencyInjectionManager(
			from: globalContainer,
			serviceRegistrars: serviceRegistrars
		)
	}
	static func fixtureWithMocks(
		globalContainer: DependencyContainer = DependencyContainerMock(),
		localContainer: DependencyContainer = DependencyContainerMock()
	) -> DependencyInjectionManager {
		DependencyInjectionManager(
			globalContainer: globalContainer,
			localContainer: localContainer
		)
	}
}
