import Foundation
import InfrastructureDependencyContainer

public final class DependencyInjectionManager: DependencyManager {
	public let globalContainer: DependencyContainer
	public let localContainer: DependencyContainer
	
	public init(
		from container: DependencyContainer? = nil,
		serviceRegistrars: [ServiceRegistrar]
	) {
		self.globalContainer = container ?? DependencyContainerImplementation()
		self.localContainer = DependencyContainerImplementation()
		
		registerServices(using: serviceRegistrars)
	}
	
	init(globalContainer: DependencyContainer, localContainer: DependencyContainer) {
		self.localContainer = localContainer
		self.globalContainer = globalContainer
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
		guard let value: T = try? globalContainer.resolve() else {
			return try localContainer.resolve()
		}
		
		return value
	}
	
	public func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T {
		guard let value: T = try? globalContainer.resolve(argument: argument) else {
			return try localContainer.resolve(argument: argument)
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
	
	private func registerServices(using registrars: [ServiceRegistrar]) {
		registrars.forEach { $0.register(on: self) }
	}
}
