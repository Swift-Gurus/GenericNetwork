import Foundation

public struct PassthroughFactory: RequestFactory {
    public typealias RequestType = URLRequestConvertible

    public func request(for type: RequestType) throws -> URLRequestConvertible {
        type
    }
}
