import XCTest
@testable import InfrastructureDependencyManager
import InfrastructureDependencyContainer

final class DependencyStorageImplementationTests: XCTestCase
{
    func test_whenServiceStored_StorageRetrievesExpectedService()
    {
        // Given
        let expectedServiceName = String(describing: DummyService.self)
        let expectedService = DummyServiceImplementation()
        let storage = DependencyStorageImplementation.fixture()
        storage.store(
            serviceName: expectedServiceName,
            instance: { expectedService as DummyService }
        )
        
        // When
		let retrievedService = try? storage.retrieve(serviceName: expectedServiceName)() as? DummyService
        
        // Then
        XCTAssertNotNil(
            retrievedService,
            "DependencyStorage must return expected service instance when retrieve is called."
        )
    }
    
    func test_whenServiceNotStored_StorageReturnsNil() throws
    {
        // Given
        let expectedServiceName = "NonStoredService"
        let storage = DependencyStorageImplementation.fixture()
        
        // When
		let retrievedService: DependencyStorage.Closure = try storage.retrieve(serviceName: expectedServiceName)
        
        // Then
        XCTAssertNil(
            retrievedService,
            "DependencyStorage must return nil when an unregistered service is retrieved."
        )
    }
}
