import Foundation
@testable import GenericNetwork

struct FactoryMock: RequestFactory {
    typealias RequestType = String

    func request(for type: String) throws -> URLRequestConvertible {
        MockRequest()
    }
}
