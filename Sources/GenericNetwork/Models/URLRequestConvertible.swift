import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Protocol to describe NetworkRequest
public protocol URLRequestConvertible {
    /// host or full url
    var baseURL: String { get }

    /// path
    var path: String? { get }

    /// request parameters
    var parameters: [String: String] { get }

    /// headers
    var headers: [String: String] { get set }

    /// body as data
    var body: Data? { get }

    /// http method
    var method: RequestMethod { get }

    /// scheme
    var scheme: RequestScheme? { get }

    /// port
    var port: Int? { get }

    /// request timeout
    var requestTimeout: TimeInterval? { get }

    /// http3 support
    var assumesHTTP3Capable: Bool { get }
}
