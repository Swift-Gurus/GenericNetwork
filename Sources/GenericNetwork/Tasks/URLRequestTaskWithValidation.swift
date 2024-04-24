import Foundation
import FunctionalSwift

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct URLRequestTaskWithValidation<Wrapped: URLRequestTaskAsync>: URLRequestTaskAsync {
    typealias Body = Wrapped.Body

    private let wrapped: Wrapped
    private let validator: URLContainerValidator

    init(wrapped: Wrapped,
         validator: URLContainerValidator) {
        self.wrapped = wrapped
        self.validator = validator
    }

    func perform(using urlRequest: URLRequest) async throws -> URLResponseContainer<Wrapped.Body> {
        let responseContainer = try await wrapped.perform(using: urlRequest)
        return try validator.response(for: responseContainer)
    }

    func perform(using urlRequest: URLRequest, completion: @escaping ResultClosure<URLResponseContainer<Wrapped.Body>>) {
        wrapped.perform(using: urlRequest) {[validator] result in
            result.tryMap { try validator.response(for: $0 ) }
                .sink(completion)
        }
    }
}

extension URLRequestTaskAsync {
    func with(validator: URLContainerValidator) -> URLRequestTaskWithValidation<Self> {
        URLRequestTaskWithValidation(wrapped: self, validator: validator)
    }
}
