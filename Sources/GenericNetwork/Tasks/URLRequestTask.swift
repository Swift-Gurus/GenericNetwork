import Foundation

protocol URLRequestTask {
    associatedtype Body
    func perform(using: URLRequest) async throws -> URLResponseContainer<Body>
}

extension URLRequestTask {
    func with(validator: URLContainerValidator) -> RequestTask<Self> {
        .init(wrapped: self, validator: validator)
    }
}
