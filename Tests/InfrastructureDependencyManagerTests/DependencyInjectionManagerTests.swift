import XCTest
@testable import InfrastructureDependencyContainer
@testable import InfrastructureDependencyManager

final class DependencyInjectionManagerTests: XCTestCase {
	// MARK: - Tear Down

	override func tearDown() {
		super.tearDown()
	}

	// MARK: - Init

	func test_init_noGlobalContainer_thenCallsRegisterMethodOnServiceRegistrar() {
		// Given
		let serviceRegistrarMock = ServiceRegistrarMock()
		
		// When
		_ = DependencyInjectionManager.init(serviceRegistrars: [serviceRegistrarMock])
		
		// Then
		XCTAssertTrue(
			serviceRegistrarMock.registerMethodWasCalled,
			"DependencyContainerImplementation must call ServiceRegistrar's register method when initializing."
		)
	}

	func test_init_withGlobalContainer_thenCallsRegisterMethodOnServiceRegistrar() {
		// Given
		let serviceRegistrarMock = ServiceRegistrarMock()
		let globalContainer = DependencyContainerMock()
		
		// When
		_ = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainer,
			serviceRegistrars: [serviceRegistrarMock]
		)
		
		// Then
		XCTAssertTrue(
			serviceRegistrarMock.registerMethodWasCalled,
			"DependencyContainerImplementation must call ServiceRegistrar's register method when initializing."
		)
	}
	
	// MARK: - Register No Arguments

	func test_register_andNoArguments_andLocal_thenCallsStoreMethodOnLocalContainer() {
		// Given
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let dummyService = DummyServiceImplementation()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		
		// When
		underTest.register(
			service: DummyService.self,
			withProvider: {
				dummyService as DummyService
			},
			scope: .unique,
			context: .local
		)
		
		// Then
		XCTAssertFalse(
			globalContainerMock.didCallRegister,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
		XCTAssertTrue(
			localContainerMock.didCallRegister,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
	}

	func test_register_andNoArguments_andGlobal_thenCallsStoreMethodOnLocalContainer() {
		// Given
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let dummyService = DummyServiceImplementation()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		
		// When
		underTest.register(
			service: DummyService.self,
			withProvider: {
				dummyService as DummyService
			},
			scope: .unique,
			context: .global
		)
		
		// Then
		XCTAssertTrue(
			globalContainerMock.didCallRegister,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
		XCTAssertFalse(
			localContainerMock.didCallRegister,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
	}

	// MARK: - Register with Arguments

	func test_register_andArguments_thenCallsRegisterArgumentOnLoval() throws {
		// Given
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let arg = "arg"
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		
		// When
		underTest.register(
			service: DummyArgumentedServiceImplementation.self,
			withProvider: { _ in
				DummyArgumentedServiceImplementation(arg: arg)
			}
		)
				
		// Then
		XCTAssertTrue(
			localContainerMock.didCallArgumentedRegister,
			"DependencyContainerImplementation must call Local DependencyContainer"
		)
	}
		
	// MARK: - Resolve No Arguments

	func test_resolve_andNoArguments_andLocal_thenCallGlobalAndLocalContainer() {
		// Given
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		localContainerMock.resolveReturn = DummyServiceImplementation()
		
		// When
		let _ : DummyService = try! underTest.resolve()
		
		// Then
		XCTAssertTrue(
			globalContainerMock.didCallResolve,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
		XCTAssertTrue(
			localContainerMock.didCallResolve,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
	}

	func test_resolve_andNoArguments_andGlobal_thenCallGlobalContainer() {
		// Given
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		globalContainerMock.resolveReturn = DummyServiceImplementation()
		
		// When
		let _ : DummyService = try! underTest.resolve()
		
		// Then
		XCTAssertTrue(
			globalContainerMock.didCallResolve,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
		XCTAssertFalse(
			localContainerMock.didCallResolve,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
	}

	// MARK: - Resolve with Arguments

	func test_resolve_andArguments_thenCallGlobalAndLocalContainer() throws {
		// Given
		let arg = "arg"
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		localContainerMock.argumentedResolveReturn = MockArgumentedDependency()

		// When
		let _: MockArgumentedDependency = try underTest.resolve(argument: arg)
		
		// Then
		XCTAssertTrue(
			globalContainerMock.didCallArgumentedResolve,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
		XCTAssertTrue(
			localContainerMock.didCallArgumentedResolve,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
	}

	func test_resolve_andArguments_thenCallGlobalContainer() throws {
		// Given
		let arg = "arg"
		let globalContainerMock = DependencyContainerMock()
		let localContainerMock = DependencyContainerMock()
		let underTest = DependencyInjectionManager.fixtureWithMocks(
			globalContainer: globalContainerMock,
			localContainer: localContainerMock
		)
		globalContainerMock.argumentedResolveReturn = MockArgumentedDependency()

		// When
		let _: MockArgumentedDependency = try underTest.resolve(argument: arg)
		
		// Then
		XCTAssertTrue(
			globalContainerMock.didCallArgumentedResolve,
			"DependencyContainerImplementation must call Global DependencyContainer."
		)
		XCTAssertFalse(
			localContainerMock.didCallArgumentedResolve,
			"DependencyContainerImplementation must call Local DependencyContainer."
		)
	}
}
