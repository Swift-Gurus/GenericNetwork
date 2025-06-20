import Foundation
import FunctionalSwift

/// Convenience type for Result<NetworkResponse<T>,Erroor>
public typealias NetworkResult<T> = Result<URLResponseContainer<T>, Error>

/// Convenience type for (Result<NetworkResponse<T>,Erroor>) -> Void
public typealias NetworkResultCompletion<T> = Closure<NetworkResult<T>>

public protocol NetworkSession: NetworkDownloadSession {
}

public protocol NetworkDownloadSession {
}

public protocol NetworkDataSession {
    func data(for request: URLRequest,
              delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}
