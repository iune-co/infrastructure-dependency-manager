public enum DependencyContainerError: Error {
	case dependencyNotRegistered(_ serviceName: String)
	case corruptedDependencyInstance(_ serviceName: String)
	case incorrectArgumentType(_ serviceName: String, argumentName: String)
}
