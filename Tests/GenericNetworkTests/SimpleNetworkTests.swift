@testable import GenericNetwork
import XCTest

final class SimpleNetworkTests: GenericNetworkBaseTestCase<PassthroughFactory> {
    override var factory: PassthroughFactory { .init() }
    override var sut: GenericNetwork<PassthroughFactory> {
        SimpleNetwork(configuration: sessionConfiguration, fileMover: fileMoverMock)
    }

    override var fakeRequestType: PassthroughFactory.RequestType {
        MockRequest()
    }
}
