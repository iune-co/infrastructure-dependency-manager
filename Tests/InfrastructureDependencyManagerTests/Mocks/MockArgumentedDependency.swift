import InfrastructureDependencyContainer

struct MockArgumentedDependency: ArgumentedDependency {
	typealias Arguments = String
	
	var id: String = "" 
}
