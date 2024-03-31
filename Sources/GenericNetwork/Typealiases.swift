import Foundation
import FunctionalSwift

/// Convenience type for Result<NetworkResponse<T>,Erroor>
public typealias NetworkResult<T> = Result<URLResponseContainer<T>, Error>

/// Convenience type for (Result<NetworkResponse<T>,Erroor>) -> Void
public typealias NetworkResultCompletion<T> = Closure<NetworkResult<T>>
