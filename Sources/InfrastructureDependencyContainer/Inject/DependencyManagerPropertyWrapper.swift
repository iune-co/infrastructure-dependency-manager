import Foundation

@propertyWrapper
public class DIManager {
	public let wrappedValue: DependencyManager

	public init() {
		guard let dependencyManager = InjectConfig.dependencyManager else {
			fatalError("Dependency manager is not set in the `InjectConfig`")
		}
	
		self.wrappedValue = dependencyManager
	}
}
