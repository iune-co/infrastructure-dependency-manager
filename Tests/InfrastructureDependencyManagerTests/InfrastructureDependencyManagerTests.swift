import XCTest
import InfrastructureDependencyContainer
@testable import InfrastructureDependencyManager

final class InfrastructureDependencyManagerTests: XCTestCase 
{
	// MARK: - Init

    func test_init_thenCallsRegisterMethodOnServiceRegistrar()
    {
        // Given
        let serviceRegistrarMock = ServiceRegistrarMock()
        
        // When
        _ = DependencyContainerImplementation.fixtureWithMocks(
            serviceRegistrars: [serviceRegistrarMock]
        )
        
        // Then
        XCTAssertTrue(
            serviceRegistrarMock.registerMethodWasCalled,
            "DependencyContainerImplementation must call ServiceRegistrar's register method when initializing."
        )
    }
    
	// MARK: - Register No Arguments

    func test_register_andNoArguments_thenCallsStoreMethodOnStorage()
    {
        // Given
        let dependencyStorageMock = DependencyStorageMock()
        let dummyService = DummyServiceImplementation()
        let underTest = DependencyContainerImplementation.fixtureWithMocks(
            storage: dependencyStorageMock
        )
        
		// When
		underTest.register(
			service: DummyService.self,
			withProvider: {
				dummyService as DummyService
			},
			scope: .unique
		)
		
		// Then
		XCTAssertTrue(
            dependencyStorageMock.didCallStore,
            "DependencyContainerImplementation must call DependencyStorage's store method when registering a service."
        )
    }

	// MARK: - Register with Arguments

    func test_register_andArguments_thenCallsStoreMethodOnStorage() throws
    {
        // Given
        let dependencyStorageMock = DependencyStorageMock()
		let arg = "arg"
        let underTest = DependencyContainerImplementation.fixtureWithMocks(
            storage: dependencyStorageMock
        )
        
		// When
		underTest.register(
			service: DummyArgumentedServiceImplementation.self,
			withProvider: { _ in
				DummyArgumentedServiceImplementation(arg: arg)
			}
		)
		
		_ = try dependencyStorageMock.storeInstanceArgumentedClosure?(arg)
		
		// Then
		XCTAssertTrue(
            dependencyStorageMock.didCallArgumentedStore,
            "DependencyContainerImplementation must call DependencyStorage's store method when registering a service."
        )
    }
    
    func test_register_andArguments_andIncorrectArgumentType_thenThrowsExpectedError()
    {
        // Given
        let dependencyStorageMock = DependencyStorageMock()
		let arg = "arg"
		let expectedServiceName = String(describing: DummyArgumentedServiceImplementation.self)
		let expectedArgumentName = String(describing: DummyArgumentedServiceImplementation.Arguments.self)
		let expectedError = DependencyContainerError.incorrectArgumentType(expectedServiceName, argumentName: expectedArgumentName)
		let underTest = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageMock
		)
		underTest.register(
			service: DummyArgumentedServiceImplementation.self,
			withProvider: { _ in
				DummyArgumentedServiceImplementation(arg: arg)
			}
		)

		// When
		XCTAssertThrowsError(try dependencyStorageMock.storeInstanceArgumentedClosure?(10)) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
    }
    
	// MARK: - Resolve No Arguments

	func test_resolve_andNoArguments_ReturnsExpectedInstance()
	{
		// Given
		let dummyService = DummyServiceImplementation()
		let dependencyStorageStub = DependencyStorageMock()
		dependencyStorageStub.stubRetrieveReturn = {
			dummyService as DummyService
		}
		let dependencyContainer = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageStub
		)
		
		// When
		let retrievedService: DummyService = try! dependencyContainer.resolve()
		
		// Then
		XCTAssertNotNil(
			retrievedService,
			"DependencyContainerImplementation must return the expected instance when resolving a registered service."
		)
	}

    func test_resolve_andNoArguments_andUnregisteredService_thenThrowsExpectedError()
    {
        // Given
		let dependencyStorageMock = DependencyStorageMock()
		let underTest = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageMock
		)
		let expectedServiceName = "DummyService"
		let expectedError = DependencyContainerError.corruptedDependencyInstance(expectedServiceName)
		dependencyStorageMock.stubArgumentedError = expectedError
		
		// When
		XCTAssertThrowsError(try underTest.resolve() as DummyService) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
    }

    func test_resolve_andNoArguments_andIncorrectType_thenThrowsExpectedError()
    {
        // Given
		let dependencyStorageMock = DependencyStorageMock()
		let underTest = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageMock
		)
		let expectedServiceName = "DummyArgumentedServiceImplementation"
		let expectedError = DependencyContainerError.corruptedDependencyInstance(expectedServiceName)
		dependencyStorageMock.stubRetrieveReturn = { DummyServiceImplementation() }
		// When
		XCTAssertThrowsError(try underTest.resolve() as DummyArgumentedServiceImplementation) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
    }

	// MARK: - Resolve with Arguments

	func test_resolve_andArguments_ReturnsExpectedInstance() throws
	{
		// Given
		let arg = "arg"
		let dummyService = MockArgumentedDependency(id: arg)
		let dependencyStorageStub = DependencyStorageMock()
		dependencyStorageStub.stubArgumentedRetrieveReturn = { _ in
			dummyService
		}

		let dependencyContainer = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageStub
		)
		
		// When
		let retrievedService: MockArgumentedDependency = try dependencyContainer.resolve(argument: arg)
		
		// Then
		
		
		XCTAssertNotNil(
			retrievedService,
			"DependencyContainerImplementation must return the expected instance when resolving a registered service."
		)
	}
    
    func test_resolve_andArguments_andUnregisteredService_thenThrowsExpectedError()
    {
        // Given
		let dependencyStorageMock = DependencyStorageMock()
		let underTest = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageMock
		)
		let expectedServiceName = "NonStoredService"
		let expectedError = DependencyContainerError.corruptedDependencyInstance(expectedServiceName)
		dependencyStorageMock.stubArgumentedError = expectedError
		let arg = "arg"
		
		// When
		XCTAssertThrowsError(try underTest.resolve(argument: arg) as DummyArgumentedServiceImplementation) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
    }

    func test_resolve_andArguments_andIncorrectType_thenThrowsExpectedError()
    {
        // Given
		let dependencyStorageMock = DependencyStorageMock()
		let underTest = DependencyContainerImplementation.fixtureWithMocks(
			storage: dependencyStorageMock
		)
		let expectedServiceName = "DummyArgumentedServiceImplementation"
		let expectedError = DependencyContainerError.corruptedDependencyInstance(expectedServiceName)
		dependencyStorageMock.stubRetrieveReturn = { DummyServiceImplementation() }
		let arg = "arg"

		// When
		XCTAssertThrowsError(try underTest.resolve(argument: arg) as DummyArgumentedServiceImplementation) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
    }
}
