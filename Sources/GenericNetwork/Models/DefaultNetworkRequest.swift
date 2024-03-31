import Foundation

public struct DefaultNetworkRequest: URLRequestConvertible {
    public let baseURL: String

    public var path: String?

    public var parameters: [String: String] = [:]

    public var headers: [String: String] = [:]

    public var body: Data?

    public var method: RequestMethod = .get

    public var scheme: RequestScheme? = .https

    public var port: Int?

    public var requestTimeout: TimeInterval?

    public var assumesHTTP3Capable = false
}
