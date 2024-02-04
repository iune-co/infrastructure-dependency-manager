public enum DependencyContainerError: Error, Equatable {
	case dependencyNotRegistered(_ serviceName: String)
	case corruptedDependencyInstance(_ serviceName: String)
	case incorrectArgumentType(_ serviceName: String, argumentName: String)
}
