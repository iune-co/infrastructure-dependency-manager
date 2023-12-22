import XCTest
@testable import InfrastructureDependencyManager

final class DependencyStorageImplementationTests: XCTestCase 
{
    func test_whenServiceStored_StorageRetrievesExpectedService()
    {
        // given
        let expectedServiceName = String(describing: DummyService.self)
        let expectedService = DummyServiceImplementation()
        let storage = DependencyStorageImplementation.fixture()
        storage.store(
            serviceName: expectedServiceName,
            instance: { expectedService as DummyService }
        )
        
        // when
        let retrievedService = storage.retrieve(serviceName: expectedServiceName)?() as? DummyService
        
        // then
        XCTAssertNotNil(
            retrievedService,
            "DependencyStorage must return expected service instance when retrieve is called."
        )
    }
    
    func test_whenServiceNotStored_StorageReturnsNil()
    {
        // given
        let expectedServiceName = "NonStoredService"
        let storage = DependencyStorageImplementation.fixture()
        
        // when
        let retrievedService = storage.retrieve(serviceName: expectedServiceName)
        
        // then
        XCTAssertNil(
            retrievedService,
            "DependencyStorage must return nil when an unregistered service is retrieved."
        )
    }
}
