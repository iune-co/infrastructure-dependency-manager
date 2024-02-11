import Foundation

@propertyWrapper
open class DIManager {
	public let wrappedValue: DependencyManager

	public init(_ dependencyManager: DependencyManager? = nil) {
		guard let dependencyManager = dependencyManager ?? InjectConfig.dependencyManager else {
			fatalError("Dependency manager is not set in the `InjectConfig`")
		}
	
		self.wrappedValue = dependencyManager
	}
}
