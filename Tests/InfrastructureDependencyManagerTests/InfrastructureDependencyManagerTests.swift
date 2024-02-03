import XCTest
import InfrastructureDependencyContainer
@testable import InfrastructureDependencyManager

final class InfrastructureDependencyManagerTests: XCTestCase 
{
    func test_whenDependencyManagerInits_callsRegisterMethodOnServiceRegister()
    {
        // Given
        let serviceRegisterMock = ServiceRegisterMock()
        
        // When
        _ = DependencyManager.fixtureWithMocks(
            serviceRegisters: [serviceRegisterMock]
        )
        
        // Then
        XCTAssertTrue(
            serviceRegisterMock.registerMethodWasCalled,
            "DependencyManager must call ServiceRegister's register method when initializing."
        )
    }
    
    func test_whenDependecyManagerRegisterMethodIsCalled_callsStoreMethodOnStorage()
    {
        // Given
        let dependencyStorageMock = DependencyStorageMock()
        let dummyService = DummyServiceImplementation()
        let dependencyManager = DependencyManager.fixtureWithMocks(
            storage: dependencyStorageMock
        )
        
        // When
        dependencyManager.register(service: DummyService.self) {
            dummyService as DummyService
        }
        
        // Then
        XCTAssertTrue(
            dependencyStorageMock.didCallStore,
            "DependencyManager must call DependencyStorage's store method when registering a service."
        )
    }
    
    func test_whenDependencyManagerResolvesUnregisteredService_ReturnsNil()
    {
        // Given
        let dependencyManager = DependencyManager.fixtureWithMocks()
        
        // When
        let retrievedService: DummyService? = try? dependencyManager.resolve()
        
        // Then
        XCTAssertNil(
            retrievedService,
            "DependencyManager must return nil when resolving an unregistered service."
        )
    }
    
    func test_whenDependencyManagerResolvesRegisteredService_ReturnsExpectedInstance()
    {
        // Given
        let dummyService = DummyServiceImplementation()
        let dependencyStorageStub = DependencyStorageStub()
		dependencyStorageStub.stubRetrieveReturn = {
            dummyService as DummyService
        }
        let dependencyManager = DependencyManager.fixtureWithMocks(
            storage: dependencyStorageStub
        )
        
        // When
        let retrievedService: DummyService = try! dependencyManager.resolve()
        
        // Then
        XCTAssertNotNil(
            retrievedService,
            "DependencyManager must return the expected instance when resolving a registered service."
        )
    }
	
    func test_whenDependencyManagerResolvesRegisteredService_andArgs_ReturnsExpectedInstance() throws
    {
        // Given
		let arg = "arg"
        let dummyService = MockArgumentedDependency(id: arg)
		let dependencyStorageStub = DependencyStorageStub()
		dependencyStorageStub.stubArgumentedRetrieveReturn = { _ in
			dummyService
		}

        let dependencyManager = DependencyManager.fixtureWithMocks(
            storage: dependencyStorageStub
        )
        
        // When
		let retrievedService: MockArgumentedDependency = try dependencyManager.resolve(argument: arg)
        
        // Then
		
		
        XCTAssertNotNil(
            retrievedService,
            "DependencyManager must return the expected instance when resolving a registered service."
        )
    }
}

