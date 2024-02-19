import Foundation

extension NSRecursiveLock {
	func locked<ReturnValue>(_ subject: () -> ReturnValue) -> ReturnValue {
		lock()
		defer { unlock() }
		return subject()
	}
}
