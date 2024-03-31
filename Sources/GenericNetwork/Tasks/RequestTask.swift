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

    func perform(using request: URLRequestConvertible, completion: @escaping ResultClosure<URLResponseContainer<Wrapped.Body>>) {
        do {
            let urlRequest = try request.urlRequest()
            wrapped.perform(using: urlRequest) {result in
                result.sink(completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
}

extension URLRequestTaskAsync {
    var requestTask: RequestTask<Self> {
        .init(wrapped: self)
    }
}
