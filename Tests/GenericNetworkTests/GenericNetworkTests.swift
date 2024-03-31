import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import GenericNetwork
import XCTest
import XCTestToolKit

final class GenericNetworkTests: GenericNetworkBaseTestCase<FactoryMock> {
    private var factoryMock = FactoryMock()
    override var factory: FactoryMock {
        factoryMock
    }
    override var fakeRequestType: String { "fakeRequest" }

    override func setUp() async throws {
        factoryMock = .init()
        try await super.setUp()
    }
}
