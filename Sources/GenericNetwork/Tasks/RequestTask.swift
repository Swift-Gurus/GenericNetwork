import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct RequestTask<Wrapped: URLRequestTaskAsync>: NetworkTaskAsync {
    private let wrapped: Wrapped

    init(wrapped: Wrapped) {
        self.wrapped = wrapped
    }

    func perform(using request: URLRequestConvertible) async throws -> URLResponseContainer<Wrapped.Body> {
        let urlRequest = try request.urlRequest()
        return try await wrapped.perform(using: urlRequest)
    }
}

extension URLRequestTaskAsync {
    var requestTask: RequestTask<Self> {
        .init(wrapped: self)
    }
}
