import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Request factory to convert request type into URLRequestConvertible
public protocol RequestFactory {
    /// Generic RequestType
    associatedtype RequestType

    /// Prepare URLRequestConvertible from a generic type RequesType
    /// - Parameter type: RequestType
    /// - Returns: URLRequestConvertible
    func request(for type: RequestType) throws -> URLRequestConvertible
}

/// High-level GenericNetwokr Layer
public struct GenericNetwork<F: RequestFactory> {
    /// Adpater for custom validation
    public var adapter: URLContainerValidator = URLContainerValidatorBase(successCodeRange: Array(DefaultSuccessCodes))

    /// URLSession
    public var urlSession: URLSession = .shared

    /// Decoder
    public var decoder: JSONDecoder = .init()
    internal let factory: F
    internal let fileMover: FileMover

    /// Initialization
    /// - Parameters:
    ///   - factory: RequestFactory
    ///   - urlSession: URLSession (default  == .shared)
    ///   - fileMover: FileMover (optional otherwise a default implementation is used)
    public init(factory: F,
                urlSession: URLSession = .shared,
                fileMover: FileMover? = nil) {
        self.urlSession = urlSession
        self.factory = factory
        self.fileMover = fileMover ?? FileMoverBase()
    }
}
