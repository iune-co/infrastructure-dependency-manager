import Foundation
import InfrastructureDependencyContainer

public final class DependencyInjectionManager: DependencyManager {
	private let globalContainer: DependencyContainer
	private let localContainer: DependencyContainer
	
	init(
		from container: DependencyContainer,
		serviceRegistrars: [ServiceRegistrar]) {
			self.globalContainer = container
			self.localContainer = DependencyContainerImplementation(serviceRegistrars: serviceRegistrars)
		}
	
	public func register<T: ArgumentedDependency>(
		service: T.Type,
		withProvider provider: @escaping (T.Arguments) throws -> T,
		context: DependencyContext
	) {
		getContainer(for: context)
			.register(
				service: service,
				withProvider: provider
			)
	}
	
	public func register<T>(
		service: T.Type,
		withProvider provider: @escaping () -> T,
		scope: DependencyScope,
		context: DependencyContext
	) {
		getContainer(for: context)
			.register(
				service: service,
				withProvider: provider,
				scope: scope
			)
	}
	
	public func resolve<T>() throws -> T {
		guard let value: T = try? localContainer.resolve() else {
			return try globalContainer.resolve()
		}
		
		return value
	}
	
	public func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T {
		guard let value: T = try? localContainer.resolve() else {
			return try globalContainer.resolve()
		}
		
		return value
	}

}

// MARK: - Private Methods

extension DependencyInjectionManager {
	private func getContainer(for context: DependencyContext) -> DependencyContainer {
		switch context {
		case .global:
			globalContainer
		case .local:
			localContainer
		}
	}
}
