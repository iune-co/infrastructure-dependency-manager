public enum InjectConfig {
	static var totalSet = 0
	public static var dependencyManager: DependencyManager? = nil {
		didSet {
			totalSet += 1
			guard totalSet <= 1 else {
				fatalError("@Inject is corrupted. It lost reference of \(oldValue.debugDescription)")
			}
		}
	}
}
