import Foundation

@propertyWrapper
public struct Inject<T> {
	public let wrappedValue: T

	public init() {
		guard let dependencyManager = InjectConfig.dependencyManager else {
			fatalError("Dependency manager is not set in the `InjectConfig`")
		}
		
		do {
			self.wrappedValue = try dependencyManager.resolve()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
