import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// swiftlint:disable closure_body_length
extension URLSession {
    func data(using request: URLRequest) async throws -> (Data, URLResponse) {
        #if canImport(FoundationNetworking)
        return try await dataForNetworkingFoundation(using: request)
        #else
        return try await data(for: request)
        #endif
    }

    private func dataForNetworkingFoundation(using request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            self.dataTask(with: request) { data, response, error in
                processResponse(body: data,
                                response: response,
                                downloadError: error,
                                original: request)
                .map { ($0.body, $0.response ) }
                .sink(continuation.resume)
            }
            .resume()
        }
    }
}

extension URLSession {
     func download(for request: URLRequest,
                   destination: URL,
                   mover: FileMover) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            downloadTask(with: request) { body, response, error in
                processResponse(body: body,
                                response: response,
                                downloadError: error,
                                original: request)
                .map { ($0.body, $0.response) }
                .doTry { try mover.move(from: $0.0, to: destination) }
                .map { (destination, $0.1) }
                .sink(continuation.resume)
            }
            .resume()
        }
    }
}

private typealias Continuation<T> = CheckedContinuation<(T, URLResponse), Error>

private func processResponse<T>(body: T?,
                                response: URLResponse?,
                                downloadError: Error?,
                                original: URLRequest) -> Result<URLResponseContainer<T>, Error> {
    GenericResponseAdapter().getResponse(data: body,
                                         response: response,
                                         error: downloadError,
                                         originalRequest: original)
}
