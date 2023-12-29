import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias SimpleNetwork = GenericNetwork<PassthroughFactory>

public extension SimpleNetwork {
    init(configuration: URLSessionConfiguration) {
        self.init(urlSession: .init(configuration: configuration), factory: .init())
    }
}
