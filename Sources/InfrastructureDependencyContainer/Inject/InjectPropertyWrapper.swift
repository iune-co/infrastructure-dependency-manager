import Foundation

@propertyWrapper
open class Inject<T> {
	public let wrappedValue: T

	public init(_ dependencyManager: DependencyManager? = nil) {
		guard let dependencyManager = dependencyManager ?? InjectConfig.dependencyManager else {
			fatalError("Dependency manager is not set in the `InjectConfig`")
		}
		
		do {
			self.wrappedValue = try dependencyManager.resolve()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
