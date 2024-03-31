import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Typealias for default network layer implementation where request type is URLRequestConvertible
public typealias SimpleNetwork = GenericNetwork<PassthroughFactory>

public extension SimpleNetwork {
    /// Initialization
    /// - Parameters:
    ///   - configuration: URLSessionConfiguration
    ///   - fileMover: FileMover? (if not passed the default implementation will be used)
    init(configuration: URLSessionConfiguration,
         fileMover: FileMover? = nil) {
        self.init(factory: .init(),
                  urlSession: .init(configuration: configuration),
                  fileMover: fileMover)
    }
}
