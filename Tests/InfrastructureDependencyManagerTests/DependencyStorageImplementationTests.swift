import XCTest
@testable import InfrastructureDependencyManager
import InfrastructureDependencyContainer

final class DependencyStorageImplementationTests: XCTestCase
{
    func test_whenServiceStored_andNoAttributes_thenStorageRetrievesExpectedService()
    {
        // Given
        let expectedServiceName = String(describing: DummyService.self)
        let expectedService = DummyServiceImplementation()
        let underTest = DependencyStorageImplementation.fixture()
        
        // When
		underTest.store(
			serviceName: expectedServiceName,
			instance: { expectedService as DummyService },
			lifetime: .transient
		)
		let retrievedService = try? underTest.retrieve(serviceName: expectedServiceName)() as? DummyService

        // Then
        XCTAssertNotNil(
            retrievedService,
            "DependencyStorage must return expected service instance when retrieve is called."
        )
    }

    func test_whenServiceStored_andNoAttributes_andLifetimeTransient_thenRetrieveNewInstance()
    {
        // Given
        let expectedServiceName = String(describing: DummyService.self)
        let underTest = DependencyStorageImplementation.fixture()
        
        // When
		underTest.store(
			serviceName: expectedServiceName,
			instance: { DummyServiceImplementation() as DummyService },
			lifetime: .transient
		)
        
		let firstRetrievedInstance = try? underTest.retrieve(serviceName: expectedServiceName)() as? DummyServiceImplementation
		let secondRetrievedService = try? underTest.retrieve(serviceName: expectedServiceName)() as? DummyServiceImplementation

        // Then
		XCTAssertFalse(secondRetrievedService === firstRetrievedInstance)
    }

    func test_whenServiceStored_andNoAttributes_andLifetimeSingleton_thenRetrieveSameInstance()
    {
        // Given
        let expectedServiceName = String(describing: DummyService.self)
        let underTest = DependencyStorageImplementation.fixture()
        
        // When
		underTest.store(
			serviceName: expectedServiceName,
			instance: { DummyServiceImplementation() as DummyService },
			lifetime: .singleton
		)
        
		let firstRetrievedInstance = try? underTest.retrieve(serviceName: expectedServiceName)() as? DummyServiceImplementation
		let secondRetrievedService = try? underTest.retrieve(serviceName: expectedServiceName)() as? DummyServiceImplementation

        // Then
		XCTAssertTrue(secondRetrievedService === firstRetrievedInstance)
    }
    
	func test_whenServiceStored_andAttributes_thenStorageRetrievesExpectedService()
	{
		// Given
		let expectedServiceName = String(describing: DummyService.self)
		let underTest = DependencyStorageImplementation.fixture()
		let args = "args"

		// When
		underTest.store(
			serviceName: expectedServiceName,
			instance: { args in  DummyArgumentedServiceImplementation(arg: args as! String)}
		)
		
		let retrievedService = try? underTest.retrieve(serviceName: expectedServiceName)(args) as? DummyService

		// Then
		XCTAssertNotNil(
			retrievedService,
			"DependencyStorage must return expected service instance when retrieve is called."
		)
	}
	
	
    func test_whenRetrieve_andServiceNotStored_StorageThrowsExpectedError()
    {
        // Given
        let expectedServiceName = "NonStoredService"
		let expectedError = DependencyContainerError.dependencyNotRegistered(expectedServiceName)
        let underTest = DependencyStorageImplementation.fixture()
        
        // When
		XCTAssertThrowsError(try underTest.retrieve(serviceName: expectedServiceName) as DependencyStorage.Closure) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
	}

    func test_whenRetrieveArgumented_andServiceNotStored_StorageThrowsExpectedError()
    {
        // Given
        let expectedServiceName = "NonStoredService"
		let expectedError = DependencyContainerError.dependencyNotRegistered(expectedServiceName)
        let underTest = DependencyStorageImplementation.fixture()
        
        // When
		XCTAssertThrowsError(try underTest.retrieve(serviceName: expectedServiceName) as DependencyStorage.ArgumentedClosure) { error in
			// Then
			XCTAssertEqual(error as? DependencyContainerError, expectedError)
		}
	}
}
