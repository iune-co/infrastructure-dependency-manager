@testable import InfrastructureDependencyManager
import InfrastructureDependencyContainer


final class DependencyContainerMock: DependencyContainer {
	
	private(set) var didCallRegister: Bool = false
	private(set) var registerServiceType: Any.Type?
	private(set) var registerProviderClosure: (() -> Any)?
	private(set) var registerScope: DependencyScope?
	
	func register<T>(service: T.Type, withProvider provider: @escaping () -> T, scope: DependencyScope) {
		didCallRegister = true
		registerServiceType = service
		registerProviderClosure = provider
		registerScope = scope
	}
	
	private(set) var didCallArgumentedRegister: Bool = false
	private(set) var argumentedRegisterServiceType: (any ArgumentedDependency.Type)?
	private(set) var argumentedRegisterProviderClosure: ((Any) throws -> Any)?
	
	func register<T: ArgumentedDependency>(service: T.Type, withProvider provider: @escaping (T.Arguments) throws -> T) {
		didCallArgumentedRegister = true
		argumentedRegisterServiceType = service
		argumentedRegisterProviderClosure = { arguments in
			try provider(arguments as! T.Arguments)
		}
	}
	
	private(set) var didCallResolve: Bool = false
	private(set) var resolveReturnType: Any.Type?
	var resolveReturn: Any?
	func resolve<T>() throws -> T {
		didCallResolve = true
		resolveReturnType = T.self
		
		guard let resolveReturn else {
			throw DependencyContainerError.dependencyNotRegistered("")
		}

		return resolveReturn as! T
	}
	
	private(set) var didCallArgumentedResolve: Bool = false
	private(set) var argumentedResolveReturnType: (any ArgumentedDependency.Type)?
	var argumentedResolveReturn: (any ArgumentedDependency)?
	func resolve<T: ArgumentedDependency>(argument: T.Arguments) throws -> T {
		didCallArgumentedResolve = true
		argumentedResolveReturnType = T.self
		
		guard let argumentedResolveReturn else {
			throw DependencyContainerError.dependencyNotRegistered("")
		}
		return argumentedResolveReturn as! T
	}
}
