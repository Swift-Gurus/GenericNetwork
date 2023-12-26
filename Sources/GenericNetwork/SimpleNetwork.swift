import Foundation

public typealias SimpleNetwork = GenericNetwork<PassthroughFactory>

public extension SimpleNetwork {
    init(configuration: URLSessionConfiguration) {
        self.init(urlSession: .init(configuration: configuration), factory: .init())
    }
}
