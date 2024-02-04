import InfrastructureDependencyContainer

final class DummyArgumentedServiceImplementation: DummyService, ArgumentedDependency {
	typealias Arguments = String
	
	let arg: Arguments
	
	init(arg: Arguments) {
		self.arg = arg
	}
}
