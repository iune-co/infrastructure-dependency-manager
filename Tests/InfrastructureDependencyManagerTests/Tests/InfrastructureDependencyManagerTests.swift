import XCTest
@testable import InfrastructureDependencyManager

final class InfrastructureDependencyManagerTests: XCTestCase 
{
    func test_whenDependencyManagerInits_callsRegisterMethodOnServiceRegister()
    {
        // given
        let dummyService = DummyServiceImplementation()
        let serviceRegisterMock = ServiceRegisterMock(
            servicesToRegister: [
                { dummyService as DummyService }
            ]
        )
        
        // when
        _ = DependencyManager.fixtureWithMocks(
            serviceRegisters: [serviceRegisterMock]
        )
        
        // then
        XCTAssertTrue(
            serviceRegisterMock.registerMethodWasCalled,
            "DependencyManager must call ServiceRegister's register method when initializing."
        )
    }
    
    func test_whenDependecyManagerRegisterMethodIsCalled_callsStoreMethodOnStorage()
    {
        // given
        let dependencyStorageMock = DependencyStorageMock()
        let dummyService = DummyServiceImplementation()
        let dependencyManager = DependencyManager.fixtureWithMocks(
            storage: dependencyStorageMock
        )
        
        // when
        dependencyManager.register {
            dummyService as DummyService
        }
        
        // then
        XCTAssertTrue(
            dependencyStorageMock.storeMethodWasCalled,
            "DependencyManager must call DependencyStorage's store method when registering a service."
        )
    }
    
    func test_whenDependencyManagerResolvesUnregisteredService_ReturnsNil()
    {
        // given
        let dependencyManager = DependencyManager.fixtureWithMocks()
        
        // when
        let retrievedService: DummyService? = dependencyManager.resolve()
        
        // then
        XCTAssertNil(
            retrievedService,
            "DependencyManager must return nil when resolving an unregistered service."
        )
    }
    
    func test_whenDependencyManagerResolvesRegisteredService_ReturnsExpectedInstance()
    {
        // given
        let dummyService = DummyServiceImplementation()
        let dependencyStorageStub = DependencyStorageStub {
            dummyService as DummyService
        }
        let dependencyManager = DependencyManager.fixtureWithMocks(
            storage: dependencyStorageStub
        )
        
        // when
        let retrievedService: DummyService? = dependencyManager.resolve()
        
        // then
        XCTAssertNotNil(
            retrievedService,
            "DependencyManager must return the expected instance when resolving a registered service."
        )
    }
}
