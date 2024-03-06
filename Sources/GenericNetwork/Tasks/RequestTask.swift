import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct RequestTask<Wrapped: URLRequestTask>: NetworkTask {

    private let wrapped: Wrapped
    private let validator: URLContainerValidator
    init(wrapped: Wrapped,
         validator: URLContainerValidator) {
        self.wrapped = wrapped
        self.validator = validator
    }
    
    func perform(using request: URLRequestConvertible) async throws -> NetworkResponse<Wrapped.Body> {
        let urlRequest = try request.urlRequest()
        let responseContainer = try await wrapped.perform(using: urlRequest)
        let validatedResponseContainer = try validator.response(for: responseContainer)
        return .init(status: validatedResponseContainer.status, body: validatedResponseContainer.body)
    }
}
