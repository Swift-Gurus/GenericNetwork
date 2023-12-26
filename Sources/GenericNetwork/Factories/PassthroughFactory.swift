import Foundation

public struct PassthroughFactory: RequestFactory {
    public func request(for type: RequestType) throws -> URLRequestConvertible {
        type
    }
    
    public typealias RequestType = URLRequestConvertible
}
