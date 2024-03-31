import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Protocol that allows providing custom validation of the network resposne
public protocol URLContainerValidator {
    /// Custom validation transformation of URLResponseContainer
    /// - Parameter container: URLResponseContainer<T>
    /// - Returns: URLResponseContainer<T>
    func response<T>(for container: URLResponseContainer<T>) throws -> URLResponseContainer<T>
}

struct URLContainerValidatorBase: URLContainerValidator {
    let successCodeRange: [Int]

    func response<T>(for container: URLResponseContainer<T>) throws -> URLResponseContainer<T> {
        if !successCodeRange.isEmpty &&
            !successCodeRange.contains(container.response.responseCode) {
            let response = NetworkResponse(status: container.status, body: container.body)
            throw GenericNetworkError.serverError(response)
        }

        return container
    }
}
